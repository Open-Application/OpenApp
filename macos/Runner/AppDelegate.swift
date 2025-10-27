import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var flutterBridge: FlutterBridge?

  override func applicationDidFinishLaunching(_ notification: Notification) {
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      flutterBridge = FlutterBridge()
      flutterBridge?.setup(binaryMessenger: controller.engine.binaryMessenger)
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
