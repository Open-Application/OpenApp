package io.rootcorporation.openapp.bg

import android.annotation.TargetApi
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.rootcorporation.openapp.Application
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.ObsoleteCoroutinesApi
import kotlinx.coroutines.channels.actor
import kotlinx.coroutines.launch

object DefaultNetworkListener {
    private sealed class NetworkMessage {
        class Start(val key: Any, val listener: (Network?) -> Unit) : NetworkMessage()
        class Get : NetworkMessage() {
            val response = CompletableDeferred<Network>()
        }

        class Stop(val key: Any) : NetworkMessage()

        class Put(val network: Network) : NetworkMessage()
        class Update(val network: Network) : NetworkMessage()
        class Lost(val network: Network) : NetworkMessage()
    }

    @OptIn(DelicateCoroutinesApi::class, ObsoleteCoroutinesApi::class)
    private val networkActor = GlobalScope.actor<NetworkMessage>(Dispatchers.Unconfined) {
        val listeners = mutableMapOf<Any, (Network?) -> Unit>()
        var network: Network? = null
        val pendingRequests = arrayListOf<NetworkMessage.Get>()
        for (message in channel) when (message) {
            is NetworkMessage.Start -> {
                if (listeners.isEmpty()) register()
                listeners[message.key] = message.listener
                if (network != null) message.listener(network)
            }

            is NetworkMessage.Get -> {
                check(listeners.isNotEmpty()) { "Getting network without any listeners is not supported" }
                if (network == null) pendingRequests += message else message.response.complete(
                    network
                )
            }

            is NetworkMessage.Stop -> if (listeners.isNotEmpty() &&
                listeners.remove(message.key) != null && listeners.isEmpty()
            ) {
                network = null
                unregister()
            }

            is NetworkMessage.Put -> {
                network = message.network
                pendingRequests.forEach { it.response.complete(message.network) }
                pendingRequests.clear()
                listeners.values.forEach { it(network) }
            }

            is NetworkMessage.Update -> if (network == message.network) listeners.values.forEach {
                it(
                    network
                )
            }

            is NetworkMessage.Lost -> if (network == message.network) {
                network = null
                listeners.values.forEach { it(null) }
            }
        }
    }

    suspend fun start(key: Any, listener: (Network?) -> Unit) = networkActor.send(
        NetworkMessage.Start(
            key,
            listener
        )
    )

    suspend fun get() = if (fallback) @TargetApi(23) {
        Application.connectivity.activeNetwork?: error("missing default network")
    } else NetworkMessage.Get().run {
        networkActor.send(this)
        response.await()
    }

    suspend fun stop(key: Any) = networkActor.send(NetworkMessage.Stop(key))

    private object Callback : ConnectivityManager.NetworkCallback() {
        @OptIn(DelicateCoroutinesApi::class)
        override fun onAvailable(network: Network) {
            GlobalScope.launch(Dispatchers.Main) {
                networkActor.send(
                    NetworkMessage.Put(
                        network
                    )
                )
            }
        }

        @OptIn(DelicateCoroutinesApi::class)
        override fun onCapabilitiesChanged(
            network: Network,
            networkCapabilities: NetworkCapabilities
        ) {
            GlobalScope.launch(Dispatchers.Main) {
                networkActor.send(NetworkMessage.Update(network))
            }
        }

        @OptIn(DelicateCoroutinesApi::class)
        override fun onLost(network: Network) {
            GlobalScope.launch(Dispatchers.Main) {
                networkActor.send(
                    NetworkMessage.Lost(
                        network
                    )
                )
            }
        }
    }

    private var fallback = false
    private val request = NetworkRequest.Builder().apply {
        addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
        addCapability(NetworkCapabilities.NET_CAPABILITY_NOT_RESTRICTED)
        if (Build.VERSION.SDK_INT == 23) {
            removeCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
            removeCapability(NetworkCapabilities.NET_CAPABILITY_CAPTIVE_PORTAL)
        }
    }.build()
    private val mainHandler = Handler(Looper.getMainLooper())

    private fun register() {
        when (Build.VERSION.SDK_INT) {
            in 31..Int.MAX_VALUE -> @TargetApi(31) {
                Application.connectivity.registerBestMatchingNetworkCallback(
                    request,
                    Callback,
                    mainHandler
                )
            }

            in 28 until 31 -> @TargetApi(28) {
                Application.connectivity.requestNetwork(request, Callback, mainHandler)
            }

            in 26 until 28 -> @TargetApi(26) {
                Application.connectivity.registerDefaultNetworkCallback(Callback, mainHandler)
            }

            in 24 until 26 -> @TargetApi(24) {
                Application.connectivity.registerDefaultNetworkCallback(Callback)
            }

            else -> try {
                fallback = false
                Application.connectivity.requestNetwork(request, Callback)
            } catch (e: RuntimeException) {
                fallback = true
            }
        }
    }

    private fun unregister() {
        runCatching {
            Application.connectivity.unregisterNetworkCallback(Callback)
        }
    }
}