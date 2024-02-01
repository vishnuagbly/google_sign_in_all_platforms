import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_android/google_sign_in_all_platforms_android.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatformsAndroid', () {
    const kPlatformName = 'Android';
    late GoogleSignInAllPlatformsAndroid googleSignInAllPlatforms;
    late List<MethodCall> log;

    setUp(() async {
      googleSignInAllPlatforms = GoogleSignInAllPlatformsAndroid();

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
      GoogleSignInAllPlatformsAndroid.registerWith();
      expect(GoogleSignInAllPlatformsPlatform.instance, isA<GoogleSignInAllPlatformsAndroid>());
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
