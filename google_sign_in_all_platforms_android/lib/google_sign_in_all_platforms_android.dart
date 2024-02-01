import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

/// The Android implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsAndroid extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_android');

  /// Registers this class as the default instance of
  /// [GoogleSignInAllPlatformsInterface]
  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsAndroid();
  }

  GoogleSignIn? __googleSignIn;

  GoogleSignIn get _googleSignIn {
    assert(__googleSignIn != null, 'The GoogleSignIn is not initialized');
    return __googleSignIn!;
  }

  @override
  void init(GoogleSignInParams params) {
    __googleSignIn = GoogleSignIn(
      scopes: params.scopes,
      clientId: params.clientId,
    );
    super.init(params);
  }

  @override
  Future<http.Client?> signInOffline() async {
    await _googleSignIn.signIn();
    return _googleSignIn.authenticatedClient();
  }

  @override
  Future<http.Client?> signInOnline() => signInOffline();

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
