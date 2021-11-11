import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
    
    var batteryLevel: Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == .unknown {
            return -1
        } else {
            return Int(device.batteryLevel * 100)
        }
    }
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      if let controller = self.window.rootViewController as? FlutterBinaryMessenger {
          let batteryChannel = FlutterMethodChannel(name: "course.flutter.dev/battery", binaryMessenger: controller)
          batteryChannel.setMethodCallHandler({call, result in
              if (call.method == "getBatteryLevel") {
                  if (self.batteryLevel == -1) {
                      result(FlutterError(code: "UNAVAILABLE", message: "Battery Info not available", details: nil))
                  } else {
                      result(self.batteryLevel)
                  }
              } else {
                  result(FlutterMethodNotImplemented)
              }
          })
      }
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
