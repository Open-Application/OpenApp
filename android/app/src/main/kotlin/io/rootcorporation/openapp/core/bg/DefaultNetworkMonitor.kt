package io.rootcorporation.openapp.bg

import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build
import io.rootcorporation.liboc.InterfaceUpdateListener
import io.rootcorporation.openapp.Application
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.net.NetworkInterface

object DefaultNetworkMonitor {
    var defaultNetwork: Network? = null
    private var listener: InterfaceUpdateListener? = null 

    suspend fun start() {
        DefaultNetworkListener.start(this) {
            if (it == null || !isVpnNetwork(it)) {
                defaultNetwork = it
                checkDefaultInterfaceUpdate(it)
            }
        }
        defaultNetwork = findUnderlyingNetwork()
    }

    private fun findUnderlyingNetwork(): Network? {
        val allNetworks = Application.connectivity.allNetworks
        for (network in allNetworks) {
            if (!isVpnNetwork(network)) {
                val caps = Application.connectivity.getNetworkCapabilities(network)
                if (caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true) {
                    return network
                }
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val active = Application.connectivity.activeNetwork
            if (active != null && !isVpnNetwork(active)) {
                return active
            }
        }
        return null
    }

    suspend fun stop() {
        DefaultNetworkListener.stop(this)
        listener = null
        defaultNetwork = null
    }

    suspend fun require(): Network {
        val network = defaultNetwork
        if (network != null) {
            return network
        }
        return DefaultNetworkListener.get()
    }

    fun setListener(listener: InterfaceUpdateListener?) {
        this.listener = listener
        checkDefaultInterfaceUpdate(defaultNetwork)
    }

    private fun checkDefaultInterfaceUpdate(newNetwork: Network?) {
        val listener = listener ?: return
        if (newNetwork != null) {
            val interfaceName =
                (Application.connectivity.getLinkProperties(newNetwork) ?: return).interfaceName
            for (times in 0 until 10) {
                var interfaceIndex: Int
                try {
                    interfaceIndex = NetworkInterface.getByName(interfaceName).index
                } catch (e: Exception) {
                    Thread.sleep(100)
                    continue
                }
                GlobalScope.launch(Dispatchers.IO) {
                    listener.updateDefaultInterface(interfaceName, interfaceIndex, false, false)
                }
                break
            }
        } else {
            GlobalScope.launch(Dispatchers.IO) {
                listener.updateDefaultInterface("", -1, false, false)
            }
        }
    }

    private fun isVpnNetwork(network: Network): Boolean {
        return try {
            val capabilities = Application.connectivity.getNetworkCapabilities(network)
            capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true
        } catch (e: Exception) {
            false
        }
    }

}