import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/src/client.dart';

class GoogleSignInAllPlatformsMock extends GoogleSignInAllPlatformsInterface {
  static const mockPlatformName = 'Mock';

  @override
  Future<void> signOut() {
    // TODO(vishnuagbly): implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Client?> getAuthenticatedClient() {
    // TODO(vishnuagbly): implement getAuthenticatedClient
    throw UnimplementedError();
  }

  @override
  Future<GoogleSignInCredentials?> lightweightSignInImpl() {
    // TODO(vishnuagbly): implement lightweightSignIn
    throw UnimplementedError();
  }

  @override
  Future<GoogleSignInCredentials?> signInOnlineImpl() {
    // TODO(vishnuagbly): implement signInOnline
    throw UnimplementedError();
  }

  @override
  Widget? signInButtonImpl({GSIAPButtonConfig? config}) {
    // TODO: implement signInButton
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GoogleSignInAllPlatformsPlatformInterface', () {
    late GoogleSignInAllPlatformsInterface googleSignInAllPlatformsPlatform;

    setUp(() {
      googleSignInAllPlatformsPlatform = GoogleSignInAllPlatformsMock();
      GoogleSignInAllPlatformsInterface.instance =
          googleSignInAllPlatformsPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await GoogleSignInAllPlatformsInterface.instance.signInOnlineImpl(),
          equals(GoogleSignInAllPlatformsMock.mockPlatformName),
        );
      });
    });
  });
}
