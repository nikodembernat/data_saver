import 'package:data_saver/data_saver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// The mode the platform is expected to be in while this test runs.
///
/// Passed in with `--dart-define=expected_mode=<name>` so the assertion runs
/// against the real platform setting rather than a mock.
///
/// On Android CI drives all three states with `adb shell cmd netpolicy`.
///
/// Low Data Mode has no equivalent hook. It is a per-Wi-Fi-network setting
/// (macOS 13+) with no `networksetup` command and no MDM payload key, Ethernet
/// has no such toggle at all, and hosted macOS runners are VMs with no Wi-Fi
/// interface to set it on. A virtual Wi-Fi adapter is not a way around it
/// either: NetworkingDriverKit supports Ethernet only and Apple ships no Wi-Fi
/// driver framework, so one cannot be created. CI therefore asserts only the
/// unconstrained state on iOS and macOS - which still catches an inverted
/// mapping, but never the constrained one. To check that by hand:
///
/// 1. Turn Low Data Mode on (iOS: Settings -> Wi-Fi/Cellular -> the network ->
///    Low Data Mode; macOS: System Settings -> Network -> the interface ->
///    Details -> Low Data Mode).
/// 2. `flutter test integration_test --dart-define=expected_mode=enabled`
const expectedMode = String.fromEnvironment('expected_mode');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reports the mode the platform is currently set to', (_) async {
    expect(
      expectedMode,
      isNotEmpty,
      reason:
          'Run with --dart-define=expected_mode=<enabled|whitelisted|disabled>.',
    );

    const dataSaver = DataSaver();

    expect(
      await dataSaver.checkMode(),
      DataSaverMode.values.byName(expectedMode),
    );
  });
}
