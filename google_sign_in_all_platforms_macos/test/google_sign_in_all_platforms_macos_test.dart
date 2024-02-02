import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:google_sign_in_all_platforms_macos/google_sign_in_all_platforms_macos.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatformsMacOS', () {
    const kPlatformName = 'MacOS';
    late GoogleSignInAllPlatformsMacOS googleSignInAllPlatforms;
    late List<MethodCall> log;

    setUp(() async {
      googleSignInAllPlatforms = GoogleSignInAllPlatformsMacOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(googleSignInAllPlatforms.methodChannel,
              (methodCall) async {
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
      GoogleSignInAllPlatformsMacOS.registerWith();
      expect(
        GoogleSignInAllPlatformsInterface.instance,
        isA<GoogleSignInAllPlatformsMacOS>(),
      );
    });

    test('getPlatformName returns correct name', () async {
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
    });
  });
}
