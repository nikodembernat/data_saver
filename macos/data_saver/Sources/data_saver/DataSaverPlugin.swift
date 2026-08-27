import Cocoa
import FlutterMacOS
import Network

public class DataSaverPlugin: NSObject, FlutterPlugin {
  /// Reports whether the current network path is constrained (Low Data Mode).
  ///
  /// `NWPath` has no public initialiser and Low Data Mode cannot be toggled
  /// from a test, so the probe is injected to let tests drive both states.
  typealias ConstrainedProbe = (@escaping (Bool) -> Void) -> Void

  private let isConstrained: ConstrainedProbe

  init(isConstrained: @escaping ConstrainedProbe = DataSaverPlugin.systemProbe) {
    self.isConstrained = isConstrained
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "data_saver", binaryMessenger: registrar.messenger)
    let instance = DataSaverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkMode":
      var hasReplied = false

      isConstrained { constrained in
        // The path is reported on *every* change, but a method channel reply
        // may only be sent once - a second one raises "Reply already submitted".
        guard !hasReplied else { return }
        hasReplied = true

        result(constrained ? "ENABLED" : "DISABLED")
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Serial queue that `NWPathMonitor` updates are delivered on.
  static let monitorQueue = DispatchQueue(label: "com.nikodembernat.data_saver.monitor")

  /// Watches the real network path and reports every update until cancelled.
  static func systemProbe(_ report: @escaping (Bool) -> Void) {
    let monitor = NWPathMonitor()

    monitor.pathUpdateHandler = { path in
      report(path.isConstrained)

      // Dropping the handler releases the monitor. It happens asynchronously so
      // the handler is not deallocated while it is still running.
      monitorQueue.async {
        monitor.pathUpdateHandler = nil
        monitor.cancel()
      }
    }

    monitor.start(queue: monitorQueue)
  }
}
