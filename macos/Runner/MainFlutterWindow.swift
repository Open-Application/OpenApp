import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    // Set window size to 2880x1800
    let windowFrame = NSRect(x: 100, y: 100, width: 2880, height: 1800)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.center() // Center the window on screen

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
