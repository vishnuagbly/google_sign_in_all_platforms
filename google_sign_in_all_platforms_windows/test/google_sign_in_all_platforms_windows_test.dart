import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';
import 'package:google_sign_in_all_platforms_windows/google_sign_in_all_platforms_windows.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatformsWindows', () {
    const kPlatformName = 'Windows';
    late GoogleSignInAllPlatformsWindows googleSignInAllPlatforms;
    late List<MethodCall> log;

    setUp(() async {
      googleSignInAllPlatforms = GoogleSignInAllPlatformsWindows();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(googleSignInAllPlatforms.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      GoogleSignInAllPlatformsWindows.registerWith();
      expect(GoogleSignInAllPlatformsPlatform.instance, isA<GoogleSignInAllPlatformsWindows>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await googleSignInAllPlatforms.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
