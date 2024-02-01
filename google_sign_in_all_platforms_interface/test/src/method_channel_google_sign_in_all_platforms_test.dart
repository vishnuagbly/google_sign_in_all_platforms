import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_interface/src/method_channel_google_sign_in_all_platforms.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelGoogleSignInAllPlatforms', () {
    late MethodChannelGoogleSignInAllPlatforms
        methodChannelGoogleSignInAllPlatforms;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelGoogleSignInAllPlatforms =
          MethodChannelGoogleSignInAllPlatforms();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelGoogleSignInAllPlatforms.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName =
          await methodChannelGoogleSignInAllPlatforms.signInOffline();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
