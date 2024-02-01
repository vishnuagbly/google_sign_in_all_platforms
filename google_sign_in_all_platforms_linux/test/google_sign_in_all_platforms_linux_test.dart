import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_linux/google_sign_in_all_platforms_linux.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatformsLinux', () {
    const kPlatformName = 'Linux';
    late GoogleSignInAllPlatformsLinux googleSignInAllPlatforms;
    late List<MethodCall> log;

    setUp(() async {
      googleSignInAllPlatforms = GoogleSignInAllPlatformsLinux();

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
      GoogleSignInAllPlatformsLinux.registerWith();
      expect(GoogleSignInAllPlatformsPlatform.instance, isA<GoogleSignInAllPlatformsLinux>());
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
