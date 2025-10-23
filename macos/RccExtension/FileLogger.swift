import Foundation

/// FileLogger writes service logs to a file in the app documents directory
/// matching the path where Flutter's getApplicationDocumentsDirectory() points.
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

    /// Get the log file path - matches Flutter's getApplicationDocumentsDirectory()
    private static func getLogFilePath() -> URL? {
        // For macOS, use the app's Application Support directory (same as Flutter's getApplicationDocumentsDirectory)
        guard let appSupportPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        let appPath = appSupportPath.appendingPathComponent("io.rootcorporation.openapp")

        // Create the app directory if it doesn't exist
        try? FileManager.default.createDirectory(at: appPath, withIntermediateDirectories: true, attributes: nil)

        return appPath.appendingPathComponent(logFileName)
    }

    /// Initialize the logger automatically (lazy initialization)
    private static func initialize() {
        guard !isInitialized else { return }
        guard let logFileURL = getLogFilePath() else {
            NSLog("[FileLogger] Failed to get log file path")
            return
        }

        // Create the file if it doesn't exist
        if !FileManager.default.fileExists(atPath: logFileURL.path) {
            FileManager.default.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }

        // Check file size and truncate if too large
        do {
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

    /// Write a log message to the file
    static func log(level: String, message: String) {
        // Initialize on first use (lazy initialization like Android)
        if !isInitialized {
            initialize()
        }

        guard let logFile = logFile else {
            NSLog("[Rcc] [\(level)] \(message)")
            return
        }

        // Clean the message by removing ANSI escape codes
        let cleanMessage = message
            .replacingOccurrences(of: #"\x1B\[[0-9;]*[a-zA-Z]|\[\d+m|\[\d{4}\]|\[38;5;\d+m|\[.*?\]"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\s+"#, with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Format: [HH:mm:ss.SSS] [LEVEL] message
        let timestamp = dateFormatter.string(from: Date())
        let logLine = "[\(timestamp)] [\(level)] \(cleanMessage)\n"

        // Write to system log as well
        NSLog("[Rcc] [\(level)] \(cleanMessage)")

        // Write to file
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
