import NetworkExtension
import Liboc

class PacketTunnelProvider: NEPacketTunnelProvider {
    private var boxService: LibocBoxService?
    private var platformInterface: RccPlatformInterface?

    override func startTunnel(options: [String : NSObject]?) async throws {
        let setupOptions = LibocSetupOptions()

        guard let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.rootcorporation.openapp") else {
            throw NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get App Group container"])
        }

        setupOptions.basePath = containerPath.path
        setupOptions.workingPath = containerPath.appendingPathComponent("working").path
        setupOptions.tempPath = FileManager.default.temporaryDirectory.path
        setupOptions.fixAndroidStack = false
        setupOptions.isTVOS = false

        var error: NSError?
        LibocSetup(setupOptions, &error)

        if let error = error {
            writeLog("Setup error: \(error.localizedDescription)")
            throw error
        }

        let stderrPath = containerPath.appendingPathComponent("stderr.log").path
        LibocRedirectStderr(stderrPath, &error)
        if let error = error {
            writeLog("Failed to redirect stderr: \(error.localizedDescription)")
        }

        LibocSetMemoryLimit(true)

        if platformInterface == nil {
            platformInterface = RccPlatformInterface(provider: self)
        }

        try await startService()
    }

    private func startService() async throws {
        guard let configContent = UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.string(forKey: "io.rootcorporation.openapp.config") else {
            let error = NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "No configuration found"])
            writeLog("Error: \(error.localizedDescription)")
            throw error
        }

        let maxRetries = 10
        var lastError: Error?

        for attempt in 0..<maxRetries {
            let delayMs = attempt * 500
            if delayMs > 0 {
                writeLog("Waiting \(delayMs)ms before attempt \(attempt + 1)/\(maxRetries)")
                try await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
            }

            do {
                var error: NSError?
                guard let service = LibocNewService(configContent, platformInterface, &error) else {
                    throw error ?? NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create service"])
                }

                try service.start()
                boxService = service
                writeLog("Service started successfully after \(attempt + 1) attempt(s)")

                if service.needWIFIState() {
                    writeLog("WiFi state requested but not available (location permission not granted)")
                }

                UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.set("STARTED", forKey: "io.rootcorporation.openapp.status")
                return
            } catch let error {
                lastError = error
                if attempt < maxRetries - 1 {
                    writeLog("Attempt \(attempt + 1)/\(maxRetries) failed: \(error.localizedDescription), retrying...")
                } else {
                    writeLog("All \(maxRetries) attempts failed")
                }
            }
        }

        throw lastError ?? NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Service start failed after \(maxRetries) attempts"])
    }

    override func stopTunnel(with reason: NEProviderStopReason) async {
        writeLog("Stopping tunnel, reason: \(reason.rawValue)")

        if let service = boxService {
            do {
                try service.close()
            } catch {
                writeLog("Error closing service: \(error.localizedDescription)")
            }
            boxService = nil
        }

        UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.set("STOPPED", forKey: "io.rootcorporation.openapp.status")
    }

    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        completionHandler?(messageData)
    }

    override func sleep(completionHandler: @escaping () -> Void) {
        boxService?.pause()
        completionHandler()
    }

    override func wake() {
        boxService?.wake()
    }

    func writeLog(_ message: String) {
        FileLogger.info(message)
    }
}
