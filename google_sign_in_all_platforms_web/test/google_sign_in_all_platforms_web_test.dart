import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';
import 'package:google_sign_in_all_platforms_web/google_sign_in_all_platforms_web.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatformsWeb', () {
    const kPlatformName = 'Web';
    late GoogleSignInAllPlatformsWeb googleSignInAllPlatforms;

    setUp(() async {
      googleSignInAllPlatforms = GoogleSignInAllPlatformsWeb();
    });

    test('can be registered', () {
      GoogleSignInAllPlatformsWeb.registerWith();
      expect(GoogleSignInAllPlatformsPlatform.instance, isA<GoogleSignInAllPlatformsWeb>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await googleSignInAllPlatforms.getPlatformName();
      expect(name, equals(kPlatformName));
    });
  });
}
