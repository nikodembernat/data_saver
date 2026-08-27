import Flutter
import UIKit
import XCTest

@testable import data_saver

// Low Data Mode cannot be toggled from a test, so `DataSaverPlugin` takes an
// injectable probe and these tests drive both states directly. The mapping
// direction is what matters: an inverted `isConstrained` would report Low Data
// Mode as off while it is on.

class RunnerTests: XCTestCase {

  func testReportsEnabledWhileTheNetworkPathIsConstrained() {
    XCTAssertEqual(checkMode(isConstrained: true), "ENABLED")
  }

  func testReportsDisabledWhileTheNetworkPathIsUnconstrained() {
    XCTAssertEqual(checkMode(isConstrained: false), "DISABLED")
  }

  /// A method channel reply may only be sent once - a second one raises
  /// "Reply already submitted", which used to happen on every path change.
  func testRepliesOnceEvenWhileTheNetworkPathKeepsChanging() {
    let plugin = DataSaverPlugin(isConstrained: { report in
      report(true)
      report(false)
      report(true)
    })

    var replies: [String] = []
    plugin.handle(FlutterMethodCall(methodName: "checkMode", arguments: nil)) { reply in
      replies.append(reply as? String ?? String(describing: reply))
    }

    XCTAssertEqual(replies, ["ENABLED"])
  }

  func testUnknownMethodIsNotImplemented() {
    let plugin = DataSaverPlugin(isConstrained: { $0(false) })

    var reply: Any?
    plugin.handle(FlutterMethodCall(methodName: "getPlatformVersion", arguments: nil)) {
      reply = $0
    }

    XCTAssertTrue((reply as? NSObject) === FlutterMethodNotImplemented)
  }

  /// Smoke test that the real `NWPathMonitor` wiring still reports at all.
  func testTheSystemProbeReportsTheCurrentPath() {
    let reported = expectation(description: "the system probe reports a path")
    reported.assertForOverFulfill = false

    DataSaverPlugin.systemProbe { _ in reported.fulfill() }

    wait(for: [reported], timeout: 10)
  }

  private func checkMode(isConstrained: Bool) -> String? {
    let plugin = DataSaverPlugin(isConstrained: { $0(isConstrained) })

    var reply: String?
    plugin.handle(FlutterMethodCall(methodName: "checkMode", arguments: nil)) {
      reply = $0 as? String
    }

    return reply
  }
}
