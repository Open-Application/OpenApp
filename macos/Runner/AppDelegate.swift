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

    // Set window size to 2880x1800
    if let window = mainFlutterWindow {
      let frame = NSRect(x: 100, y: 100, width: 2880, height: 1800)
      window.setFrame(frame, display: true)
      window.center()
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
