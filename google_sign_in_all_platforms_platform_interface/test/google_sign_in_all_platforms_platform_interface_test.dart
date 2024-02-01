import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';
import 'package:http/src/client.dart';

class GoogleSignInAllPlatformsMock extends GoogleSignInAllPlatformsPlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<Client?> signInOffline() {
    // TODO(vishnuagbly): implement signInOffline
    throw UnimplementedError();
  }

  @override
  Future<Client?> signInOnline() {
    // TODO(vishnuagbly): implement signInOnline
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO(vishnuagbly): implement signOut
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GoogleSignInAllPlatformsPlatformInterface', () {
    late GoogleSignInAllPlatformsPlatform googleSignInAllPlatformsPlatform;

    setUp(() {
      googleSignInAllPlatformsPlatform = GoogleSignInAllPlatformsMock();
      GoogleSignInAllPlatformsPlatform.instance =
          googleSignInAllPlatformsPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await GoogleSignInAllPlatformsPlatform.instance.signInOnline(),
          equals(GoogleSignInAllPlatformsMock.mockPlatformName),
        );
      });
    });
  });
}
