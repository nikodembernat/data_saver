import 'package:data_saver/src/data_saver_method_channel.dart';
import 'package:data_saver/src/data_saver_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelDataSaver();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// Makes the native side reply with [response] for the next `checkMode` call.
  void mockNativeResponse(String? response) {
    messenger.setMockMethodCallHandler(platform.methodChannel, (call) async {
      expect(call.method, 'checkMode');
      return response;
    });
  }

  tearDown(() => messenger.setMockMethodCallHandler(platform.methodChannel, null));

  test('maps every value the native implementations can return', () async {
    const cases = {
      'ENABLED': DataSaverMode.enabled,
      'WHITELISTED': DataSaverMode.whitelisted,
      'DISABLED': DataSaverMode.disabled,
    };

    for (final MapEntry(key: response, value: expected) in cases.entries) {
      mockNativeResponse(response);

      expect(await platform.checkMode(), expected);
    }
  });

  test('throws on a value no platform is supposed to send', () {
    mockNativeResponse('SOMETHING_ELSE');

    expect(platform.checkMode(), throwsUnsupportedError);
  });

  test('throws when the platform replies with null', () {
    mockNativeResponse(null);

    expect(platform.checkMode(), throwsUnsupportedError);
  });
}
