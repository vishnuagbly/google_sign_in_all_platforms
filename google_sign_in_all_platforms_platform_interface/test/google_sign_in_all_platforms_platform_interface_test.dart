import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

class GoogleSignInAllPlatformsMock extends GoogleSignInAllPlatformsPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GoogleSignInAllPlatformsPlatformInterface', () {
    late GoogleSignInAllPlatformsPlatform googleSignInAllPlatformsPlatform;

    setUp(() {
      googleSignInAllPlatformsPlatform = GoogleSignInAllPlatformsMock();
      GoogleSignInAllPlatformsPlatform.instance = googleSignInAllPlatformsPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await GoogleSignInAllPlatformsPlatform.instance.getPlatformName(),
          equals(GoogleSignInAllPlatformsMock.mockPlatformName),
        );
      });
    });
  });
}
