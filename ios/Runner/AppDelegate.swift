import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var flutterBridge: FlutterBridge?

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let binaryMessenger = engineBridge.pluginRegistry.registrar(forPlugin: "FlutterBridge")!.messenger()
    flutterBridge = FlutterBridge()
    flutterBridge?.setup(binaryMessenger: binaryMessenger)
  }
}
