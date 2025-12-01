import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var flutterBridge: FlutterBridge?
  lazy var flutterEngine = FlutterEngine(name: "main engine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    let binaryMessenger = flutterEngine.binaryMessenger
    flutterBridge = FlutterBridge()
    flutterBridge?.setup(binaryMessenger: binaryMessenger)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}
