import Flutter
import NetworkExtension
import UIKit

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

        initializeExistingManager()
    }

    private func initializeExistingManager() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            guard let self = self else { return }

            if let error = error {
                NSLog("[FlutterBridge] Error loading service configurations at startup: \(error.localizedDescription)")
                return
            }

            let ourBundleId = "io.rootcorporation.openapp.core"
            let existingManager = managers?.first(where: { manager in
                if let proto = manager.protocolConfiguration as? NETunnelProviderProtocol {
                    return proto.providerBundleIdentifier == ourBundleId
                }
                return false
            })

            if let existingManager = existingManager {
                NSLog("[FlutterBridge] Found existing service configuration at startup, syncing status")
                self.vpnManager = existingManager

                if self.statusObserver == nil {
                    self.observeVPNStatus()
                }

                self.sendStatusUpdate()
            } else {
                NSLog("[FlutterBridge] No existing service configuration found at startup")
            }
        }
    }

    private func ensureServiceManager(completion: @escaping (Error?) -> Void) {
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

            let ourBundleId = "io.rootcorporation.openapp.core"
            let existingManager = managers?.first(where: { manager in
                if let proto = manager.protocolConfiguration as? NETunnelProviderProtocol {
                    return proto.providerBundleIdentifier == ourBundleId
                }
                return false
            })

            if let existingManager = existingManager {
                NSLog("[FlutterBridge] Found existing configuration, reusing it")
                self.vpnManager = existingManager

                if self.statusObserver == nil {
                    self.observeVPNStatus()
                    NSLog("[FlutterBridge] Status observer set up")
                }

                completion(nil)
                return
            }

            if self.vpnManager != nil {
                NSLog("[FlutterBridge] Configuration was manually deleted, cleaning up cache")

                let currentStatus = self.vpnManager?.connection.status.rawValue ?? -1
                NSLog("[FlutterBridge] Stopping VPN connection (current status: \(currentStatus))")
                self.vpnManager?.connection.stopVPNTunnel()

                if let observer = self.statusObserver {
                    NSLog("[FlutterBridge] Removing status observer")
                    NotificationCenter.default.removeObserver(observer)
                    self.statusObserver = nil
                }

                self.vpnManager = nil

                NSLog("[FlutterBridge] Waiting for system VPN state cleanup...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    guard let self = self else {
                        completion(NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bridge deallocated"]))
                        return
                    }
                    self.proceedWithManagerCleanupAndCreation(managers: managers, completion: completion)
                }
                return
            }

            self.proceedWithManagerCleanupAndCreation(managers: managers, completion: completion)
        }
    }

    private func proceedWithManagerCleanupAndCreation(managers: [NETunnelProviderManager]?, completion: @escaping (Error?) -> Void) {

        if let managers = managers, !managers.isEmpty {
            NSLog("[FlutterBridge] Found \(managers.count) leftover VPN configuration(s), removing them")

            let group = DispatchGroup()
            for manager in managers {
                group.enter()
                manager.removeFromPreferences { removeError in
                    if let removeError = removeError {
                        NSLog("[FlutterBridge] Error removing old configuration: \(removeError.localizedDescription)")
                    }
                    group.leave()
                }
            }

            group.notify(queue: .main) { [weak self] in
                NSLog("[FlutterBridge] All old configurations removed, creating fresh one")
                self?.createServiceManager(completion: completion)
            }
        } else {
            NSLog("[FlutterBridge] No existing configurations found, creating new one")
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
        ensureServiceManager { [weak self] error in
            guard let self = self else {
                result(FlutterError(code: "NO_BRIDGE", message: "Bridge deallocated", details: nil))
                return
            }

            if let error = error {
                result(FlutterError(code: "MANAGER_INIT_ERROR", message: error.localizedDescription, details: nil))
                return
            }

            guard let manager = self.vpnManager else {
                result(FlutterError(code: "NO_MANAGER", message: "Rcc manager not initialized", details: nil))
                return
            }

            if self.statusObserver == nil {
                self.observeVPNStatus()
                NSLog("[FlutterBridge] Status observer set up")
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
            result("STOPPED")
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
