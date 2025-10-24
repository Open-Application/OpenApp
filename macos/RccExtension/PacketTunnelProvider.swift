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

        var error: NSError?
        let service = LibocNewService(configContent, platformInterface, &error)

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

        if service.needWIFIState() {
            writeLog("WiFi state requested but not available (location permission not granted)")
        }

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
