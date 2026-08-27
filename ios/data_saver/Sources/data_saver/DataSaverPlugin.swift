import Flutter
import Network
import UIKit

public class DataSaverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "data_saver", binaryMessenger: registrar.messenger())
    let instance = DataSaverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if #available(iOS 13.0, *) {
      let monitor = NWPathMonitor()
      monitor.pathUpdateHandler = { path in
        result(path.isConstrained ? "ENABLED" : "DISABLED")
      }

      monitor.start(queue: DispatchQueue.global())
    } else {
      result("DISABLED")
    }
  }
}
