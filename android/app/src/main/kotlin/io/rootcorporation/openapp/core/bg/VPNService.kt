package io.rootcorporation.openapp.bg

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager.NameNotFoundException
import android.net.ProxyInfo
import android.net.VpnService
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import io.rootcorporation.openapp.MainActivity
import io.rootcorporation.openapp.R
import io.rootcorporation.liboc.TunOptions
import android.net.IpPrefix
import java.net.InetAddress
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class VPNService : VpnService(), PlatformInterfaceWrapper {

    companion object {
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "vpn_service_channel"
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "VPN Service",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "VPN service running"
                setShowBadge(false)
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("RootCorporation")
            .setContentText("RootCorporation is running")
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .build()
    }

    private val service = BoxService(this, this)

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        return service.onStartCommand()
    }

    override fun onBind(intent: Intent): IBinder? {
        return super.onBind(intent)
    }

    override fun onDestroy() {
        service.onDestroy()
    }

    @OptIn(DelicateCoroutinesApi::class)
    override fun onRevoke() {
        GlobalScope.launch(Dispatchers.Main) {
            service.onRevoke()
        }
    }

    override fun autoDetectInterfaceControl(fd: Int) {
        protect(fd)
    }

    var systemProxyAvailable = false
    var systemProxyEnabled = false

    override fun openTun(options: TunOptions): Int {
        if (prepare(this) != null) error("android: missing vpn permission")

        val builder = Builder()
            .setSession("RootCorporation")
            .setMtu(options.mtu)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            builder.setMetered(false)
        }

        val inet4Address = options.inet4Address
        while (inet4Address.hasNext()) {
            val address = inet4Address.next()
            builder.addAddress(address.address(), address.prefix())
        }

        val inet6Address = options.inet6Address
        while (inet6Address.hasNext()) {
            val address = inet6Address.next()
            builder.addAddress(address.address(), address.prefix())
        }

        if (options.autoRoute) {
            builder.addDnsServer(options.dnsServerAddress.value)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val inet4RouteAddress = options.inet4RouteAddress
                if (inet4RouteAddress.hasNext()) {
                    while (inet4RouteAddress.hasNext()) {
                        val route = inet4RouteAddress.next()
                        builder.addRoute(IpPrefix(InetAddress.getByName(route.address()), route.prefix()))
                    }
                } else if (options.inet4Address.hasNext()) {
                    builder.addRoute("0.0.0.0", 0)
                }

                val inet6RouteAddress = options.inet6RouteAddress
                if (inet6RouteAddress.hasNext()) {
                    while (inet6RouteAddress.hasNext()) {
                        val route = inet6RouteAddress.next()
                        builder.addRoute(IpPrefix(InetAddress.getByName(route.address()), route.prefix()))
                    }
                } else if (options.inet6Address.hasNext()) {
                    builder.addRoute("::", 0)
                }

                val inet4RouteExcludeAddress = options.inet4RouteExcludeAddress
                while (inet4RouteExcludeAddress.hasNext()) {
                    val route = inet4RouteExcludeAddress.next()
                    builder.excludeRoute(IpPrefix(InetAddress.getByName(route.address()), route.prefix()))
                }

                val inet6RouteExcludeAddress = options.inet6RouteExcludeAddress
                while (inet6RouteExcludeAddress.hasNext()) {
                    val route = inet6RouteExcludeAddress.next()
                    builder.excludeRoute(IpPrefix(InetAddress.getByName(route.address()), route.prefix()))
                }
            } else {
                val inet4RouteAddress = options.inet4RouteRange
                if (inet4RouteAddress.hasNext()) {
                    while (inet4RouteAddress.hasNext()) {
                        val address = inet4RouteAddress.next()
                        builder.addRoute(address.address(), address.prefix())
                    }
                }

                val inet6RouteAddress = options.inet6RouteRange
                if (inet6RouteAddress.hasNext()) {
                    while (inet6RouteAddress.hasNext()) {
                        val address = inet6RouteAddress.next()
                        builder.addRoute(address.address(), address.prefix())
                    }
                }
            }
        }

        if (options.isHTTPProxyEnabled && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            systemProxyAvailable = true
            systemProxyEnabled = true
            builder.setHttpProxy(
                ProxyInfo.buildDirectProxy(
                    options.httpProxyServer,
                    options.httpProxyServerPort,
                    mutableListOf<String>().apply {
                        while (options.httpProxyBypassDomain.hasNext()) {
                            add(options.httpProxyBypassDomain.next())
                        }
                    }
                )
            )
        } else {
            systemProxyAvailable = false
            systemProxyEnabled = false
        }

        val pfd =
            builder.establish() ?: error("android: the application is not prepared or is revoked")
        service.fileDescriptor = pfd
        return pfd.fd
    }

    override fun writeLog(message: String) = service.writeLog(message)
    override fun sendNotification(notification: io.rootcorporation.liboc.Notification) {}

}