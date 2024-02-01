import Flutter
import UIKit

public class GoogleSignInAllPlatformsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "google_sign_in_all_platforms_ios", binaryMessenger: registrar.messenger())
    let instance = GoogleSignInAllPlatformsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS")
  }
}
