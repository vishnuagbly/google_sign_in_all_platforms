import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGoogleSignInAllPlatformsInterface extends Mock
    with MockPlatformInterfaceMixin
    implements GoogleSignInAllPlatformsInterface {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoogleSignInAllPlatforms', () {
    late GoogleSignInAllPlatformsInterface googleSignInAllPlatformsInterface;

    setUp(() {
      googleSignInAllPlatformsInterface =
          MockGoogleSignInAllPlatformsInterface();
      GoogleSignInAllPlatformsInterface.instance =
          googleSignInAllPlatformsInterface;
    });

    group('getPlatformName', () {
      test(
        'returns correct name when platform implementation exists',
        () async {},
      );
    });
  });
}
