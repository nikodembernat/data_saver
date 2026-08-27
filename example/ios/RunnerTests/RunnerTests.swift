import Flutter
import UIKit
import XCTest

// If your plugin has been explicitly set to "type: .dynamic" in the Package.swift,
// you will need to add your plugin as a dependency of RunnerTests within Xcode.

@testable import data_saver

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testCheckModeRepliesOnce() {
    let plugin = DataSaverPlugin()

    let call = FlutterMethodCall(methodName: "checkMode", arguments: nil)

    let resultExpectation = expectation(description: "result block must be called exactly once.")
    plugin.handle(call) { result in
      XCTAssertTrue(["ENABLED", "DISABLED"].contains(result as? String ?? ""))
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 5)
  }

  func testUnknownMethodIsNotImplemented() {
    let plugin = DataSaverPlugin()

    let call = FlutterMethodCall(methodName: "getPlatformVersion", arguments: nil)

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertTrue((result as? NSObject) === FlutterMethodNotImplemented)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}
