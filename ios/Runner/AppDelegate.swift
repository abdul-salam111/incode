import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var previousBrightness: CGFloat = 0.5
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let brightnessChannel = FlutterMethodChannel(name: "com.example.brightness",
                                              binaryMessenger: controller.binaryMessenger)
    brightnessChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "setBrightness":
        if let args = call.arguments as? [String: Any],
           let brightness = args["brightness"] as? Double {
          self.setScreenBrightness(brightness: brightness)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT",
                            message: "Brightness value is required",
                            details: nil))
        }
      case "getBrightness":
        let currentBrightness = self.getCurrentBrightness()
        result(currentBrightness)
      case "setMaxBrightness":
        // Store current brightness and set to maximum
        self.previousBrightness = self.getCurrentBrightness()
        print("iOS: Stored previous brightness: \(self.previousBrightness)")
        self.setScreenBrightness(brightness: 1.0)
        result(nil)
      case "restoreBrightness":
        // Restore to previous brightness
        print("iOS: Restoring brightness to: \(self.previousBrightness)")
        self.setScreenBrightness(brightness: Double(self.previousBrightness))
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setScreenBrightness(brightness: Double) {
    DispatchQueue.main.async {
      let currentBrightness = UIScreen.main.brightness
      let newBrightness = CGFloat(brightness)
      print("iOS: Setting brightness from \(currentBrightness) to \(newBrightness)")
      UIScreen.main.brightness = newBrightness
    }
  }
  
  private func getCurrentBrightness() -> CGFloat {
    return UIScreen.main.brightness
  }
}
