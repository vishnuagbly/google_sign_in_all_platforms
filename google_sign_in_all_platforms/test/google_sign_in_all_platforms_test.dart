import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGoogleSignInAllPlatformsPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GoogleSignInAllPlatformsPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatforms', () {
    late GoogleSignInAllPlatformsPlatform googleSignInAllPlatformsPlatform;

    setUp(() {
      googleSignInAllPlatformsPlatform = MockGoogleSignInAllPlatformsPlatform();
      GoogleSignInAllPlatformsPlatform.instance =
          googleSignInAllPlatformsPlatform;
    });

    group('getPlatformName', () {
      test(
        'returns correct name when platform implementation exists',
        () async {},
      );
    });
  });
}
