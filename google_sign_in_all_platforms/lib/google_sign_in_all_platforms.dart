import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

///Use this class to perform all types of Google OAuth operations.
class GoogleSignIn {
  ///Use this class to perform all types of Google OAuth operations.
  GoogleSignIn({
    GoogleSignInParams params = const GoogleSignInParams(),
  }) : assert(
          (params.clientSecret != null && params.clientId != null) ||
              !isDesktop,
          'For Desktop, clientSecret and clientId cannot be null',
        ) {
    GoogleSignInAllPlatformsInterface.instance.init(params);
  }

  /// Stream that emits GoogleSignInCredentials when user signs in, and null
  /// when user signs out
  Stream<GoogleSignInCredentials?> get authenticationState {
    return GoogleSignInAllPlatformsInterface.instance.authenticationState;
  }

  ///Executes [lightweightSignIn] first, and if unsuccessful, it executes
  ///[signInOnline].
  Future<GoogleSignInCredentials?> signIn() {
    return GoogleSignInAllPlatformsInterface.instance.signIn();
  }

  /// Performs Sign in for already last logged in user.
  Future<GoogleSignInCredentials?> lightweightSignIn() {
    return GoogleSignInAllPlatformsInterface.instance.lightweightSignIn();
  }

  /// Performs Silent Sign in. Recommended only for Desktop.
  /// Not "Officially" Recommended for other platforms, though it works.
  Future<GoogleSignInCredentials?> silentSignIn() {
    return GoogleSignInAllPlatformsInterface.instance.silentSignIn();
  }

  /// Alias for [lightweightSignIn]
  @Deprecated(
      'Use lightweightSignIn instead. signInOffline will be removed in a '
      'future version.')
  Future<GoogleSignInCredentials?> signInOffline() => lightweightSignIn();

  ///Performs Sign in using online flow, for all platforms.
  Future<GoogleSignInCredentials?> signInOnline() {
    return GoogleSignInAllPlatformsInterface.instance.signInOnline();
  }

  /// Returns a Sign-In Button for Web Platform only.
  Widget? signInButton({GSIAPButtonConfig? config}) {
    return GoogleSignInAllPlatformsInterface.instance.signInButton(
      config: config,
    );
  }

  ///Returns the authenticated http client. This should be called after the user
  ///is signed in.
  Future<http.Client?> get authenticatedClient {
    return GoogleSignInAllPlatformsInterface.instance.getAuthenticatedClient();
  }

  ///Performs the Sign Out operation and also deletes the stored token.
  Future<void> signOut() async {
    await GoogleSignInAllPlatformsInterface.instance.signOut();
  }
}
