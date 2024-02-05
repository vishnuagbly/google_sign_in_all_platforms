import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// The Android implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsMobile extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_mobile');

  /// Registers this class as the default instance of
  /// [GoogleSignInAllPlatformsInterface]
  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsMobile();
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

  Future<GoogleSignInCredentials?> get _creds async {
    final auth = await _googleSignIn.currentUser?.authentication;
    final accessToken = auth?.accessToken;
    if (accessToken == null) return null;

    return GoogleSignInCredentials(
      accessToken: accessToken,
      scopes: params.scopes,
      tokenType: 'Bearer',
      idToken: auth?.idToken,
    );
  }

  @override
  Future<GoogleSignInCredentials?> signInOffline() async {
    await _googleSignIn.signIn();
    return _creds;
  }

  @override
  Future<GoogleSignInCredentials?> signInOnline() => signInOffline();

  @override
  Future<http.Client?> getAuthenticatedClient() {
    return _googleSignIn.authenticatedClient();
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
