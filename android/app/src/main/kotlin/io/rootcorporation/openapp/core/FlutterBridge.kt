package io.rootcorporation.openapp

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import androidx.activity.result.ActivityResultLauncher
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.rootcorporation.openapp.utils.FileLogger
import java.io.File
import kotlinx.coroutines.*

class FlutterBridge(
    private val activity: FlutterFragmentActivity,
    private val vpnPermissionLauncher: ActivityResultLauncher<Intent>
) {
    private val CHANNEL = "io.rootcorporation.openapp/core"
    private val EVENT_CHANNEL = "io.rootcorporation.openapp/status"
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var permissionGrantedTime: Long = 0
    private var pendingPermissionResult: MethodChannel.Result? = null

    fun handleVpnPermissionResult(granted: Boolean) {
        if (granted) {
            permissionGrantedTime = System.currentTimeMillis()
            FileLogger.info("VPN permission granted at $permissionGrantedTime")
        } else {
            FileLogger.warn("VPN permission denied by user")
        }
        pendingPermissionResult?.success(granted)
        pendingPermissionResult = null
    }

    private fun startVpnService(config: String, needsDelay: Boolean = false) {
        coroutineScope.launch(Dispatchers.IO) {
            if (needsDelay) {
                FileLogger.info("Adding 1s delay before starting service")
                kotlinx.coroutines.delay(1000L)
            }
            try {
                FileLogger.info("Starting service")
                io.rootcorporation.openapp.bg.BoxService.start(config)
            } catch (e: Exception) {
                FileLogger.error("Failed to start VPN service: ${e.message}")
            }
        }
    }

    fun setup(flutterEngine: FlutterEngine) {
        FileLogger.init(activity.applicationContext)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)

        eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                io.rootcorporation.openapp.bg.BoxService.setStatusListener { status ->
                    coroutineScope.launch(Dispatchers.Main) {
                        eventSink?.success(mapOf("type" to "status", "data" to status))
                    }
                }
                val currentStatus = io.rootcorporation.openapp.bg.BoxService.getCurrentStatus()
                eventSink?.success(mapOf("type" to "status", "data" to currentStatus))
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
                io.rootcorporation.openapp.bg.BoxService.setStatusListener(null)
            }
        })
        
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkRccPermission" -> {
                    val intent = VpnService.prepare(activity)
                    val hasPermission = intent == null
                    result.success(hasPermission)
                }
                
                "requestRccPermission" -> {
                    val intent = VpnService.prepare(activity)
                    if (intent != null) {
                        FileLogger.info("Requesting VPN permission from user")
                        pendingPermissionResult = result
                        vpnPermissionLauncher.launch(intent)
                    } else {
                        FileLogger.info("VPN permission already granted")
                        result.success(true)
                    }
                }
                
                "startRcc" -> {
                    val config = call.argument<String>("config")
                    if (config == null) {
                        FileLogger.error("Invalid configuration provided")
                        result.error("INVALID_CONFIG", "Configuration is required", null)
                        return@setMethodCallHandler
                    }

                    val needsDelay = if (permissionGrantedTime > 0) {
                        val elapsedTime = System.currentTimeMillis() - permissionGrantedTime
                        FileLogger.info("User clicked ${elapsedTime}ms after permission grant")
                        permissionGrantedTime = 0
                        true
                    } else {
                        val hasVpnPermission = VpnService.prepare(activity) == null
                        FileLogger.info("Starting service (permission: $hasVpnPermission)")
                        false
                    }

                    startVpnService(config, needsDelay)
                    result.success(true)
                }
                
                "stopRcc" -> {
                    io.rootcorporation.openapp.bg.BoxService.stop()
                    result.success(true)
                }

                "getRccStatus" -> {
                    val status = io.rootcorporation.openapp.bg.BoxService.getCurrentStatus()
                    result.success(status)
                }
                else -> result.notImplemented()
            }
        }
    }
    

    fun cleanup() {
        eventChannel?.setStreamHandler(null)
        coroutineScope.cancel()
        eventSink = null
        io.rootcorporation.openapp.bg.BoxService.setStatusListener(null)
    }
}