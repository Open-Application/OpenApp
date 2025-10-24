package io.rootcorporation.openapp.bg

import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.Process
import android.system.OsConstants
import android.util.Log
import androidx.annotation.RequiresApi
import io.rootcorporation.liboc.InterfaceUpdateListener
import io.rootcorporation.liboc.Liboc
import io.rootcorporation.liboc.LocalDNSTransport
import io.rootcorporation.liboc.NetworkInterfaceIterator
import io.rootcorporation.liboc.PlatformInterface
import io.rootcorporation.liboc.StringIterator
import io.rootcorporation.liboc.TunOptions
import io.rootcorporation.liboc.WIFIState
import io.rootcorporation.openapp.Application
import java.net.Inet6Address
import java.net.InetSocketAddress
import java.net.InterfaceAddress
import java.net.NetworkInterface
import io.rootcorporation.liboc.NetworkInterface as LibocNetworkInterface

interface PlatformInterfaceWrapper : PlatformInterface {

    override fun usePlatformAutoDetectInterfaceControl(): Boolean {
        return true
    }

    override fun autoDetectInterfaceControl(fd: Int) {
    }

    override fun openTun(options: TunOptions): Int {
        error("invalid argument")
    }

    override fun useProcFS(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.Q
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun findConnectionOwner(
        ipProtocol: Int,
        sourceAddress: String,
        sourcePort: Int,
        destinationAddress: String,
        destinationPort: Int
    ): Int {
        try {
            val uid = Application.connectivity.getConnectionOwnerUid(
                ipProtocol,
                InetSocketAddress(sourceAddress, sourcePort),
                InetSocketAddress(destinationAddress, destinationPort)
            )
            if (uid == Process.INVALID_UID) error("android: connection owner not found")
            return uid
        } catch (e: Exception) {
            Log.e("PlatformInterface", "getConnectionOwnerUid", e)
            e.printStackTrace(System.err)
            throw e
        }
    }

    override fun packageNameByUid(uid: Int): String {
        val packages = Application.packageManager.getPackagesForUid(uid)
        if (packages.isNullOrEmpty()) error("android: package not found")
        return packages[0]
    }

    @Suppress("DEPRECATION")
    override fun uidByPackageName(packageName: String): Int {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                Application.packageManager.getPackageUid(
                    packageName, PackageManager.PackageInfoFlags.of(0)
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Application.packageManager.getPackageUid(packageName, 0)
            } else {
                Application.packageManager.getApplicationInfo(packageName, 0).uid
            }
        } catch (e: PackageManager.NameNotFoundException) {
            error("android: package not found")
        }
    }

    override fun startDefaultInterfaceMonitor(listener: InterfaceUpdateListener) {
        DefaultNetworkMonitor.setListener(listener)
    }

    override fun closeDefaultInterfaceMonitor(listener: InterfaceUpdateListener) {
        DefaultNetworkMonitor.setListener(null)
    }

    @Suppress("DEPRECATION")
    override fun getInterfaces(): NetworkInterfaceIterator {
        val networks = Application.connectivity.allNetworks
        val networkInterfaces = NetworkInterface.getNetworkInterfaces().toList()
        val interfaces = mutableListOf<LibocNetworkInterface>()
        for (network in networks) {
            val boxInterface = LibocNetworkInterface()
            val linkProperties = Application.connectivity.getLinkProperties(network) ?: continue
            val networkCapabilities =
                Application.connectivity.getNetworkCapabilities(network) ?: continue
            boxInterface.name = linkProperties.interfaceName
            val networkInterface =
                networkInterfaces.find { it.name == boxInterface.name } ?: continue
            boxInterface.dnsServer =
                StringArray(linkProperties.dnsServers.mapNotNull { it.hostAddress }.iterator())
            boxInterface.type = when {
                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> Liboc.InterfaceTypeWIFI
                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> Liboc.InterfaceTypeCellular
                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> Liboc.InterfaceTypeEthernet
                else -> Liboc.InterfaceTypeOther
            }
            boxInterface.index = networkInterface.index
            runCatching {
                boxInterface.mtu = networkInterface.mtu
            }.onFailure {
                Log.e(
                    "PlatformInterface", "failed to get mtu for interface ${boxInterface.name}", it
                )
            }
            boxInterface.addresses =
                StringArray(networkInterface.interfaceAddresses.mapTo(mutableListOf()) { it.toPrefix() }
                    .iterator())
            var dumpFlags = 0
            if (networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)) {
                dumpFlags = OsConstants.IFF_UP or OsConstants.IFF_RUNNING
            }
            if (networkInterface.isLoopback) {
                dumpFlags = dumpFlags or OsConstants.IFF_LOOPBACK
            }
            if (networkInterface.isPointToPoint) {
                dumpFlags = dumpFlags or OsConstants.IFF_POINTOPOINT
            }
            if (networkInterface.supportsMulticast()) {
                dumpFlags = dumpFlags or OsConstants.IFF_MULTICAST
            }
            boxInterface.flags = dumpFlags
            boxInterface.metered =
                !networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_METERED)
            interfaces.add(boxInterface)
        }
        return InterfaceArray(interfaces.iterator())
    }

    override fun underNetworkExtension(): Boolean {
        return false
    }

    override fun includeAllNetworks(): Boolean {
        return false
    }

    override fun clearDNSCache() {}

    override fun readWIFIState(): WIFIState? {
        return null
    }

    override fun localDNSTransport(): LocalDNSTransport? {
        return null
    }

    override fun systemCertificates(): StringIterator {
        return StringArray(emptyList<String>().iterator())
    }

    private class InterfaceArray(private val iterator: Iterator<LibocNetworkInterface>) :
        NetworkInterfaceIterator {

        override fun hasNext(): Boolean {
            return iterator.hasNext()
        }

        override fun next(): LibocNetworkInterface {
            return iterator.next()
        }

    }

    private class StringArray(private val iterator: Iterator<String>) : StringIterator {
        override fun len(): Int {
            return 0
        }

        override fun hasNext(): Boolean {
            return iterator.hasNext()
        }

        override fun next(): String {
            return iterator.next()
        }
    }

    private fun InterfaceAddress.toPrefix(): String {
        return if (address is Inet6Address) {
            "${Inet6Address.getByAddress(address.address).hostAddress}/${networkPrefixLength}"
        } else {
            "${address.hostAddress}/${networkPrefixLength}"
        }
    }

    private val NetworkInterface.flags: Int
        @SuppressLint("SoonBlockedPrivateApi") get() {
            val getFlagsMethod = NetworkInterface::class.java.getDeclaredMethod("getFlags")
            return getFlagsMethod.invoke(this) as Int
        }
}