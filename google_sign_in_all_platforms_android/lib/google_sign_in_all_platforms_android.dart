import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';
import 'package:http/http.dart' as http;

/// The Android implementation of [GoogleSignInAllPlatformsPlatform].
class GoogleSignInAllPlatformsAndroid extends GoogleSignInAllPlatformsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_android');

  /// Registers this class as the default instance of
  /// [GoogleSignInAllPlatformsPlatform]
  static void registerWith() {
    GoogleSignInAllPlatformsPlatform.instance =
        GoogleSignInAllPlatformsAndroid();
  }

  GoogleSignIn? __googleSignIn;

  GoogleSignIn get _googleSignIn {
    assert(__googleSignIn != null, 'The GoogleSignIn is not initialized');
    return __googleSignIn!;
  }

  @override
  void init(InitParams params) {
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
