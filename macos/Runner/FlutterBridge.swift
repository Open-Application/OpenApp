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

            case "getLogFilePath":
                self.getLogFilePath(result: result)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func ensureServiceManager(completion: @escaping (Error?) -> Void) {
        if vpnManager != nil {
            completion(nil)
            return
        }

        let expectedBundleID = "io.rootcorporation.openapp.core"

        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self = self else {
                completion(NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bridge deallocated"]))
                return
            }

            if let error = error {
                NSLog("Error loading service manager: \(error.localizedDescription)")
                completion(error)
                return
            }

            if let existingManagers = managers, !existingManagers.isEmpty {
                NSLog("[FlutterBridge] Found \(existingManagers.count) existing VPN configuration(s)")

                var needsRecreate = false
                var managersToRemove: [NETunnelProviderManager] = []

                for existingManager in existingManagers {
                    if let proto = existingManager.protocolConfiguration as? NETunnelProviderProtocol {
                        if proto.providerBundleIdentifier != expectedBundleID {
                            NSLog("[FlutterBridge] Bundle ID mismatch: expected '\(expectedBundleID)', found '\(proto.providerBundleIdentifier ?? "nil")' - marking for removal")
                            needsRecreate = true
                            managersToRemove.append(existingManager)
                        } else {
                            NSLog("[FlutterBridge] Found matching configuration, reusing it")
                            self.vpnManager = existingManager
                            self.observeVPNStatus()
                            completion(nil)
                            return
                        }
                    } else {
                        NSLog("[FlutterBridge] Invalid protocol configuration - marking for removal")
                        needsRecreate = true
                        managersToRemove.append(existingManager)
                    }
                }

                if !managersToRemove.isEmpty {
                    NSLog("[FlutterBridge] Removing \(managersToRemove.count) mismatched configuration(s)")
                    for manager in managersToRemove {
                        manager.removeFromPreferences { removeError in
                            if let removeError = removeError {
                                NSLog("[FlutterBridge] Error removing old configuration: \(removeError.localizedDescription)")
                            }
                        }
                    }
                }
            }

            NSLog("[FlutterBridge] Creating new VPN configuration")
            self.createServiceManager(completion: completion)
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

    private func createServiceManager(completion: @escaping (Error?) -> Void) {
        let manager = NETunnelProviderManager()
        manager.localizedDescription = "OpenApp Core"

        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = "io.rootcorporation.openapp.core"
        proto.serverAddress = "OpenApp Core"
        manager.protocolConfiguration = proto
        manager.isEnabled = true

        manager.saveToPreferences { [weak self] error in
            if let error = error {
                NSLog("Error saving Rcc manager: \(error.localizedDescription)")
                completion(error)
                return
            }

            NSLog("[FlutterBridge] Manager saved, reloading from preferences")
            NETunnelProviderManager.loadAllFromPreferences { managers, error in
                guard let self = self else {
                    completion(NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bridge deallocated"]))
                    return
                }

                if let error = error {
                    NSLog("Error reloading manager: \(error.localizedDescription)")
                    completion(error)
                    return
                }

                if let manager = managers?.first {
                    self.vpnManager = manager
                    self.observeVPNStatus()
                    NSLog("[FlutterBridge] Manager successfully reloaded and ready")
                    completion(nil)
                } else {
                    completion(NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to reload manager"]))
                }
            }
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
        NSLog("[FlutterBridge] startVPN called")

        ensureServiceManager { [weak self] error in
            guard let self = self else {
                result(FlutterError(code: "NO_BRIDGE", message: "Bridge deallocated", details: nil))
                return
            }

            if let error = error {
                NSLog("[FlutterBridge] ERROR: Manager initialization failed: \(error.localizedDescription)")
                result(FlutterError(code: "MANAGER_INIT_ERROR", message: error.localizedDescription, details: nil))
                return
            }

            guard let manager = self.vpnManager else {
                NSLog("[FlutterBridge] ERROR: No manager")
                result(FlutterError(code: "NO_MANAGER", message: "Rcc manager not initialized", details: nil))
                return
            }

            NSLog("[FlutterBridge] Manager exists, checking connection status: \(manager.connection.status.rawValue)")

            let defaults = UserDefaults(suiteName: "group.io.rootcorporation.openapp")
            defaults?.set(config, forKey: "io.rootcorporation.openapp.config")
            defaults?.synchronize()

            NSLog("[FlutterBridge] Saved config to UserDefaults, length: \(config.count)")
            NSLog("[FlutterBridge] Attempting to start VPN tunnel...")

            do {
                try manager.connection.startVPNTunnel()
                NSLog("[FlutterBridge] startVPNTunnel() call succeeded")
                result(true)
            } catch {
                NSLog("[FlutterBridge] ERROR starting Rcc service: \(error.localizedDescription)")
                NSLog("[FlutterBridge] Error details: \(error)")
                defaults?.set("STOPPED", forKey: "io.rootcorporation.openapp.status")
                defaults?.synchronize()
                result(FlutterError(code: "START_ERROR", message: error.localizedDescription, details: nil))
            }
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

    private func getLogFilePath(result: @escaping FlutterResult) {
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.rootcorporation.openapp") else {
            result(FlutterError(code: "NO_APP_GROUP", message: "Failed to get App Group container", details: nil))
            return
        }

        let logFilePath = appGroupURL.appendingPathComponent("debug.log").path
        result(logFilePath)
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
