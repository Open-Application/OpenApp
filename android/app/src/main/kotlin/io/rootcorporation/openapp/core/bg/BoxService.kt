package io.rootcorporation.openapp.bg

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import android.os.ParcelFileDescriptor
import android.os.PowerManager
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import io.rootcorporation.liboc.BoxService as LibocBoxService
import io.rootcorporation.liboc.Liboc
import io.rootcorporation.liboc.PlatformInterface
import io.rootcorporation.openapp.Application
import io.rootcorporation.openapp.utils.FileLogger
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class BoxService(
    private val service: Service, private val platformInterface: PlatformInterface
) {

    companion object {
        private const val SERVICE_CLOSE = "io.rootcorporation.openapp.SERVICE_CLOSE"
        var pendingConfig: String? = null
        @Volatile
        var startedByUser: Boolean = false

        @Volatile
        private var currentStatus: String = "STOPPED"
        @Volatile
        private var statusListener: ((String) -> Unit)? = null

        fun getCurrentStatus(): String = currentStatus

        fun setStatusListener(listener: ((String) -> Unit)?) {
            statusListener = listener
        }

        @OptIn(DelicateCoroutinesApi::class)
        fun start(config: String) {
            pendingConfig = config
            GlobalScope.launch(Dispatchers.Main.immediate) {
                val intent = withContext(Dispatchers.IO) {
                    Intent(Application.application, VPNService::class.java)
                }
                ContextCompat.startForegroundService(Application.application, intent)
            }
        }

        fun stop() {
            Application.application.sendBroadcast(
                Intent(SERVICE_CLOSE).setPackage(
                    Application.application.packageName
                )
            )
        }
    }

    var fileDescriptor: ParcelFileDescriptor? = null

    private var boxService: LibocBoxService? = null
    private var receiverRegistered = false
    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            when (intent.action) {
                SERVICE_CLOSE -> {
                    stopService()
                }
                PowerManager.ACTION_DEVICE_IDLE_MODE_CHANGED -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        serviceUpdateIdleMode()
                    }
                }
            }
        }
    }


    private suspend fun startService() {
        try {
            val content = pendingConfig
                ?: throw IllegalStateException("Configuration not provided from Flutter")

            pendingConfig = null

            FileLogger.init(service.applicationContext)
            FileLogger.info("Initializing Service...")

            DefaultNetworkMonitor.start()
            Liboc.setMemoryLimit(true)

            FileLogger.info("Starting service with retry mechanism")
            var retryCount = 0
            val maxRetries = 10
            var newService: LibocBoxService? = null
            var lastException: Exception? = null

            while (retryCount < maxRetries) {
                try {
                    val delayMs = retryCount * 500L
                    FileLogger.info("Waiting ${delayMs}ms before attempt ${retryCount + 1}/${maxRetries}")
                    kotlinx.coroutines.delay(delayMs)

                    val serviceInstance = Liboc.newService(content, platformInterface)
                    serviceInstance.start()

                    FileLogger.info("Service started successfully after ${retryCount + 1} attempts")
                    newService = serviceInstance
                    break
                } catch (e: Exception) {
                    lastException = e
                    retryCount++
                    if (retryCount < maxRetries) {
                        FileLogger.warn("Attempt ${retryCount}/${maxRetries} failed: ${e.message}, retrying...")
                    } else {
                        FileLogger.error("All ${maxRetries} attempts failed: ${e.message}")
                    }
                }
            }

            if (newService == null || retryCount == maxRetries) {
                FileLogger.error("Failed to start service after $maxRetries attempts: ${lastException?.message}")
                startedByUser = false
                return
            }


            if (newService.needWIFIState()) {
                FileLogger.info("WiFi state requested but not available (location permission not granted)")
            }

            boxService = newService
            updateStatus("STARTED")
        } catch (e: Exception) {
            FileLogger.error("Failed to start service: ${e.message}")
            startedByUser = false
            return
        }
    }


    @RequiresApi(Build.VERSION_CODES.M)
    private fun serviceUpdateIdleMode() {
        if (Application.powerManager.isDeviceIdleMode) {
            boxService?.pause()
        } else {
            boxService?.wake()
        }
    }

    @OptIn(DelicateCoroutinesApi::class)
    private fun stopService() {
        if (currentStatus != "STARTED") return
        updateStatus("STOPPING")
        if (receiverRegistered) {
            service.unregisterReceiver(receiver)
            receiverRegistered = false
        }
        GlobalScope.launch(Dispatchers.IO) {
            boxService?.apply {
                runCatching {
                    close()
                }.onFailure {
                    writeLog("service: error when closing: $it")
                }
            }
            boxService = null
            kotlinx.coroutines.delay(1000)

            DefaultNetworkMonitor.stop()
            val pfd = fileDescriptor
            if (pfd != null) {
                pfd.close()
                fileDescriptor = null
            }

            startedByUser = false
            withContext(Dispatchers.Main) {
                updateStatus("STOPPED")
                service.stopSelf()
            }
        }
    }


    @OptIn(DelicateCoroutinesApi::class)
    @Suppress("SameReturnValue")
    internal fun onStartCommand(): Int {
        if (currentStatus != "STOPPED") return Service.START_NOT_STICKY
        updateStatus("STARTING")

        if (!receiverRegistered) {
            ContextCompat.registerReceiver(service, receiver, IntentFilter().apply {
                addAction(SERVICE_CLOSE)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    addAction(PowerManager.ACTION_DEVICE_IDLE_MODE_CHANGED)
                }
            }, ContextCompat.RECEIVER_NOT_EXPORTED)
            receiverRegistered = true
        }

        GlobalScope.launch(Dispatchers.IO) {
            startedByUser = true
            startService()
        }
        return Service.START_NOT_STICKY
    }

    internal fun onBind(): IBinder? {
        return null
    }

    internal fun onDestroy() {
    }

    private fun updateStatus(status: String) {
        currentStatus = status
        statusListener?.invoke(status)
    }

    internal fun onRevoke() {
        stopService()
    }

    internal fun writeLog(message: String) {
        FileLogger.info(message)
    }

}