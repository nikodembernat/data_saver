import 'package:data_saver/data_saver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// The mode the harness set on the device before starting this test.
///
/// Passed in with `--dart-define=expected_mode=<name>` so the assertion runs
/// against the real platform setting rather than a mock.
const expectedMode = String.fromEnvironment('expected_mode');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reports the mode the platform is currently set to', (_) async {
    expect(
      expectedMode,
      isNotEmpty,
      reason: 'Run with --dart-define=expected_mode=<enabled|whitelisted|disabled>.',
    );

    const dataSaver = DataSaver();

    expect(
      await dataSaver.checkMode(),
      DataSaverMode.values.byName(expectedMode),
    );
  });
}
