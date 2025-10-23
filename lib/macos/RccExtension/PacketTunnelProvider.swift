import NetworkExtension
import Librcc

@objc(PacketTunnelProvider)
class PacketTunnelProvider: NEPacketTunnelProvider {
    private var boxService: LibrccBoxService?
    private var platformInterface: RccPlatformInterface?

    override func startTunnel(options: [String : NSObject]?) async throws {
        LibrccClearServiceError()

        // Setup directories
        let setupOptions = LibrccSetupOptions()

        // Get container path for App Group
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
        LibrccSetup(setupOptions, &error)

        if let error = error {
            writeFatalError("Setup error: \(error.localizedDescription)")
            return
        }

        // Redirect stderr to log file for crash logging
        let stderrPath = containerPath.appendingPathComponent("stderr.log").path
        LibrccRedirectStderr(stderrPath, &error)
        if let error = error {
            writeFatalError("Failed to redirect stderr: \(error.localizedDescription)")
            return
        }

        // Set memory limit
        LibrccSetMemoryLimit(true)

        // Initialize platform interface
        if platformInterface == nil {
            platformInterface = RccPlatformInterface(provider: self)
        }

        // Start service
        await startService()
    }

    private func startService() async {
        // Get configuration from shared preferences
        guard let configContent = UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.string(forKey: "io.rootcorporation.openapp.config") else {
            writeFatalError("No configuration found")
            return
        }

        var error: NSError?
        let service = LibrccNewService(configContent, platformInterface, &error)

        if let error {
            writeFatalError("Failed to create service: \(error.localizedDescription)")
            return
        }

        guard let service else {
            writeFatalError("Failed to create service: unknown error")
            return
        }

        do {
            try service.start()
        } catch {
            writeFatalError("Failed to start service: \(error.localizedDescription)")
            return
        }

        boxService = service
        writeLog("Service started successfully")

        // Update status
        UserDefaults(suiteName: "group.io.rootcorporation.openapp")?.set("STARTED", forKey: "io.rootcorporation.openapp.status")
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

        // Update status
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
        NSLog("[RccVPN] FATAL: \(message)")
        var error: NSError?
        LibrccWriteServiceError(message, &error)
        cancelTunnelWithError(nil)
    }
}
