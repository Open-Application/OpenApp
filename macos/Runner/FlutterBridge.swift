import Cocoa
import FlutterMacOS
import NetworkExtension

class FlutterBridge: NSObject {
    private let channelName = "io.rootcorporation.openapp/core"
    private let eventChannelName = "io.rootcorporation.openapp/status"
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var vpnManager: NETunnelProviderManager?
    private var statusObserver: Any?

    func setup(binaryMessenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)
        eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: binaryMessenger)

        eventChannel?.setStreamHandler(self)
        methodChannel?.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }

            switch call.method {
            case "checkRccPermission":
                self.checkPermission(result: result)

            case "requestRccPermission":
                self.requestPermission(result: result)

            case "startRcc":
                guard let args = call.arguments as? [String: Any],
                      let config = args["config"] as? String else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Configuration is required", details: nil))
                    return
                }
                self.startVPN(config: config, result: result)

            case "stopRcc":
                self.stopVPN(result: result)

            case "getRccStatus":
                self.getStatus(result: result)

            case "clearRccStatus":
                self.clearStatus(result: result)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        loadVPNManager()
    }

    private func loadVPNManager() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self = self else { return }

            if let error = error {
                NSLog("Error loading Rcc manager: \(error.localizedDescription)")
                return
            }

            if let manager = managers?.first {
                self.vpnManager = manager
                self.observeVPNStatus()
                self.validateAndClearStaleStatus()
            } else {
                self.createVPNManager()
            }
        }
    }

    private func validateAndClearStaleStatus() {
        guard let manager = vpnManager else { return }

        let defaults = UserDefaults(suiteName: "group.io.rootcorporation.openapp")
        let storedStatus = defaults?.string(forKey: "io.rootcorporation.openapp.status") ?? "STOPPED"

        if (manager.connection.status == .disconnected || manager.connection.status == .invalid) &&
           (storedStatus == "STARTING" || storedStatus == "STOPPING") {
            NSLog("[FlutterBridge] Clearing stale status: \(storedStatus)")
            defaults?.removeObject(forKey: "io.rootcorporation.openapp.status")
            defaults?.synchronize()
        }
    }

    private func createVPNManager() {
        let manager = NETunnelProviderManager()
        manager.localizedDescription = "Root Corporation Core"

        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = "io.rootcorporation.openapp.core"
        proto.serverAddress = "RootCorporation"
        manager.protocolConfiguration = proto
        manager.isEnabled = true

        manager.saveToPreferences { [weak self] error in
            if let error = error {
                NSLog("Error saving Rcc manager: \(error.localizedDescription)")
                return
            }

            self?.vpnManager = manager
            self?.observeVPNStatus()
        }
    }

    private func observeVPNStatus() {
        statusObserver = NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: vpnManager?.connection,
            queue: .main
        ) { [weak self] _ in
            self?.sendStatusUpdate()
        }
    }

    private func sendStatusUpdate() {
        guard let status = vpnManager?.connection.status else { return }

        let statusString: String
        switch status {
        case .invalid:
            statusString = "INVALID"
        case .disconnected:
            statusString = "STOPPED"
        case .connecting:
            statusString = "STARTING"
        case .connected:
            statusString = "STARTED"
        case .reasserting:
            statusString = "STARTING"
        case .disconnecting:
            statusString = "STOPPING"
        @unknown default:
            statusString = "UNKNOWN"
        }

        eventSink?(["type": "status", "data": statusString])
    }

    private func checkPermission(result: @escaping FlutterResult) {
        result(true)
    }

    private func requestPermission(result: @escaping FlutterResult) {
        result(true)
    }

    private func startVPN(config: String, result: @escaping FlutterResult) {
        guard let manager = vpnManager else {
            result(FlutterError(code: "NO_MANAGER", message: "Rcc manager not initialized", details: nil))
            return
        }

        let defaults = UserDefaults(suiteName: "group.io.rootcorporation.openapp")
        defaults?.set(config, forKey: "io.rootcorporation.openapp.config")
        defaults?.synchronize()

        NSLog("[FlutterBridge] Saved config to UserDefaults, length: \(config.count)")

        do {
            try manager.connection.startVPNTunnel()
            result(true)
        } catch {
            NSLog("Error starting Rcc service: \(error.localizedDescription)")
            defaults?.set("STOPPED", forKey: "io.rootcorporation.openapp.status")
            defaults?.synchronize()
            result(FlutterError(code: "START_ERROR", message: error.localizedDescription, details: nil))
        }
    }

    private func stopVPN(result: @escaping FlutterResult) {
        guard let manager = vpnManager else {
            result(FlutterError(code: "NO_MANAGER", message: "Rcc manager not initialized", details: nil))
            return
        }

        manager.connection.stopVPNTunnel()
        result(true)
    }

    private func getStatus(result: @escaping FlutterResult) {
        if let manager = vpnManager {
            let statusString: String
            switch manager.connection.status {
            case .invalid:
                statusString = "STOPPED"
            case .disconnected:
                statusString = "STOPPED"
            case .connecting:
                statusString = "STARTING"
            case .connected:
                statusString = "STARTED"
            case .reasserting:
                statusString = "STARTING"
            case .disconnecting:
                statusString = "STOPPING"
            @unknown default:
                statusString = "STOPPED"
            }
            result(statusString)
        } else {
            let defaults = UserDefaults(suiteName: "group.io.rootcorporation.openapp")
            let status = defaults?.string(forKey: "io.rootcorporation.openapp.status") ?? "STOPPED"
            result(status)
        }
    }

    private func clearStatus(result: @escaping FlutterResult) {
        let defaults = UserDefaults(suiteName: "group.io.rootcorporation.openapp")
        defaults?.removeObject(forKey: "io.rootcorporation.openapp.status")
        defaults?.synchronize()
        NSLog("[FlutterBridge] Status cleared manually")
        result(true)
    }

    deinit {
        if let observer = statusObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension FlutterBridge: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        sendStatusUpdate()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
