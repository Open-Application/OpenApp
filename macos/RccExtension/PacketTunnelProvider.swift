import NetworkExtension
import Liboc

@objc(PacketTunnelProvider)
class PacketTunnelProvider: NEPacketTunnelProvider {
    private var boxService: LibocBoxService?
    private var platformInterface: RccPlatformInterface?

    override func startTunnel(options: [String : NSObject]?) async throws {
        LibocClearServiceError()

        let setupOptions = LibocSetupOptions()

        guard let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.rootcorporation.openapp") else {
            writeFatalError("Failed to get App Group container")
            return
        }

        setupOptions.basePath = containerPath.path
        setupOptions.workingPath = containerPath.appendingPathComponent("working").path
        setupOptions.tempPath = FileManager.default.temporaryDirectory.path
        setupOptions.fixAndroidStack = false
        setupOptions.isTVOS = false

        var error: NSError?
        LibocSetup(setupOptions, &error)

        if let error = error {
            writeFatalError("Setup error: \(error.localizedDescription)")
            return
        }

        let stderrPath = containerPath.appendingPathComponent("stderr.log").path
        LibocRedirectStderr(stderrPath, &error)
        if let error = error {
            writeFatalError("Failed to redirect stderr: \(error.localizedDescription)")
            return
        }

        LibocSetMemoryLimit(true)

        if platformInterface == nil {
            platformInterface = RccPlatformInterface(provider: self)
        }

        await startService()
    }

    private func startService() async {
        guard let configContent = UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.string(forKey: "io.rootcorporation.openapp.config") else {
            writeFatalError("No configuration found")
            return
        }

        let maxRetries = 10
        var lastError: Error?

        for attempt in 0..<maxRetries {
            let delayMs = attempt * 500
            if delayMs > 0 {
                writeLog("Waiting \(delayMs)ms before attempt \(attempt + 1)/\(maxRetries)")
                do {
                    try await Task.sleep(nanoseconds: UInt64(delayMs) * 1_000_000)
                } catch {
                    writeLog("Sleep interrupted: \(error.localizedDescription)")
                }
            }

            var error: NSError?
            guard let service = LibocNewService(configContent, platformInterface, &error) else {
                lastError = error ?? NSError(domain: "io.rootcorporation.openapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create service"])
                if attempt < maxRetries - 1 {
                    writeLog("Attempt \(attempt + 1)/\(maxRetries) failed: \(lastError!.localizedDescription), retrying...")
                    continue
                } else {
                    writeFatalError("All \(maxRetries) attempts failed: \(lastError!.localizedDescription)")
                    return
                }
            }

            do {
                try service.start()
                boxService = service
                writeLog("Service started successfully after \(attempt + 1) attempt(s)")

                if service.needWIFIState() {
                    writeLog("WiFi state requested but not available (location permission not granted)")
                }

                UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.set("STARTED", forKey: "io.rootcorporation.openapp.status")
                return
            } catch {
                lastError = error
                if attempt < maxRetries - 1 {
                    writeLog("Attempt \(attempt + 1)/\(maxRetries) failed to start: \(error.localizedDescription), retrying...")
                } else {
                    writeFatalError("All \(maxRetries) attempts failed to start: \(error.localizedDescription)")
                    return
                }
            }
        }
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

    func writeFatalError(_ message: String) {
        NSLog("[Rcc] FATAL: \(message)")
        var error: NSError?
        LibocWriteServiceError(message, &error)
        cancelTunnelWithError(nil)
    }
}
