import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var flutterBridge: FlutterBridge?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    setupLogFileSymlink()

    if let controller = window?.rootViewController as? FlutterViewController {
      flutterBridge = FlutterBridge()
      flutterBridge?.setup(binaryMessenger: controller.binaryMessenger)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setupLogFileSymlink() {
    let fileManager = FileManager.default

    guard let appGroupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.io.rootcorporation.openapp") else {
      NSLog("[AppDelegate] Failed to get App Group container")
      return
    }

    guard let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
      NSLog("[AppDelegate] Failed to get Application Support directory")
      return
    }

    let bundleIdentifier = Bundle.main.bundleIdentifier ?? "io.rootcorporation.openapp"
    let appSupportDirectory = appSupportURL.appendingPathComponent(bundleIdentifier, isDirectory: true)

    try? fileManager.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)

    let sourceLogFile = appGroupURL.appendingPathComponent("debug.log")
    let targetLogFile = appSupportDirectory.appendingPathComponent("debug.log")

    if fileManager.fileExists(atPath: targetLogFile.path) {
      do {
        try fileManager.removeItem(at: targetLogFile)
        NSLog("[AppDelegate] Removed existing debug.log at target location")
      } catch {
        NSLog("[AppDelegate] Failed to remove existing debug.log: \(error)")
        return
      }
    }

    do {
      try fileManager.createSymbolicLink(at: targetLogFile, withDestinationURL: sourceLogFile)
      NSLog("[AppDelegate] Created symlink: \(targetLogFile.path) -> \(sourceLogFile.path)")
    } catch {
      NSLog("[AppDelegate] Failed to create symlink: \(error)")
    }
  }
}
