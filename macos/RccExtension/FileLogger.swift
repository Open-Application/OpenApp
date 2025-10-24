import Foundation

class FileLogger {
    private static let logFileName = "debug.log"
    private static let maxLogSize = 1024 * 1024 // 1 MB
    private static var logFile: URL?
    private static var isInitialized = false
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

    private static func getLogFilePath() -> URL? {
        guard let appSupportPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        let appPath = appSupportPath.appendingPathComponent("io.rootcorporation.openapp")

        try? FileManager.default.createDirectory(at: appPath, withIntermediateDirectories: true, attributes: nil)

        return appPath.appendingPathComponent(logFileName)
    }

    private static func initialize() {
        guard !isInitialized else { return }
        guard let logFileURL = getLogFilePath() else {
            NSLog("[FileLogger] Failed to get log file path")
            return
        }

        if !FileManager.default.fileExists(atPath: logFileURL.path) {
            FileManager.default.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }

        do{
            let attributes = try FileManager.default.attributesOfItem(atPath: logFileURL.path)
            if let fileSize = attributes[.size] as? Int, fileSize > maxLogSize {
                try "".write(to: logFileURL, atomically: true, encoding: .utf8)
            }
        } catch {
            NSLog("[FileLogger] Error checking log file size: \(error)")
        }

        logFile = logFileURL
        isInitialized = true
    }

    static func log(level: String, message: String) {
        if !isInitialized {
            initialize()
        }

        guard let logFile = logFile else {
            NSLog("[Rcc] [\(level)] \(message)")
            return
        }

        let cleanMessage = message
            .replacingOccurrences(of: #"\x1B\[[0-9;]*[a-zA-Z]|\[\d+m|\[\d{4}\]|\[38;5;\d+m|\[.*?\]"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let timestamp = dateFormatter.string(from: Date())
        let logLine = "[\(timestamp)] [\(level)] \(cleanMessage)\n"

        NSLog("[Rcc] [\(level)] \(cleanMessage)")

        if let fileHandle = try? FileHandle(forWritingTo: logFile) {
            fileHandle.seekToEndOfFile()
            if let data = logLine.data(using: .utf8) {
                fileHandle.write(data)
            }
            fileHandle.closeFile()
        }
    }

    static func info(_ message: String) {
        log(level: "I", message: message)
    }

    static func debug(_ message: String) {
        log(level: "D", message: message)
    }

    static func warn(_ message: String) {
        log(level: "W", message: message)
    }

    static func error(_ message: String) {
        log(level: "E", message: message)
    }

    static func clear() {
        guard let logFile = logFile else { return }
        do {
            try "".write(to: logFile, atomically: true, encoding: .utf8)
        } catch {
            NSLog("[FileLogger] Error clearing log file: \(error)")
        }
    }
}
