import Flutter
import Network
import UIKit

public class DataSaverPlugin: NSObject, FlutterPlugin {
  /// Serial queue that `NWPathMonitor` updates are delivered on.
  private static let monitorQueue = DispatchQueue(label: "com.nikodembernat.data_saver.monitor")

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "data_saver", binaryMessenger: registrar.messenger())
    let instance = DataSaverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkMode":
      checkMode(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Reports whether the current network path is constrained (Low Data Mode).
  ///
  /// `NWPathMonitor` reports *every* path change, but a method channel reply
  /// may only be sent once - a second one raises "Reply already submitted".
  /// Only the first update is answered and the monitor is torn down right
  /// after, so it neither fires again nor outlives the call.
  private func checkMode(result: @escaping FlutterResult) {
    let monitor = NWPathMonitor()
    var hasReplied = false

    monitor.pathUpdateHandler = { path in
      guard !hasReplied else { return }
      hasReplied = true

      result(path.isConstrained ? "ENABLED" : "DISABLED")

      // Dropping the handler breaks the monitor's reference cycle. It happens
      // asynchronously so the handler is not released while it is running.
      Self.monitorQueue.async {
        monitor.pathUpdateHandler = nil
        monitor.cancel()
      }
    }

    monitor.start(queue: Self.monitorQueue)
  }
}
