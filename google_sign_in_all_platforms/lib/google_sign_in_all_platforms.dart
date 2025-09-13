import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in_all_platforms/src/auth_state_utils.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

class _GoogleSignInAuthState {
  _GoogleSignInAuthState._(this.controller);

  static final _GoogleSignInAuthState instance = _GoogleSignInAuthState._(
    StreamController<GoogleSignInCredentials?>.broadcast(),
  );

  final StreamController<GoogleSignInCredentials?> controller;
  GoogleSignInCredentials? lastEmittedCredentials;
}

///Use this class to perform all types of Google OAuth operations.
class GoogleSignIn {
  ///Use this class to perform all types of Google OAuth operations.
  GoogleSignIn({
    GoogleSignInParams params = const GoogleSignInParams(),
  })  : assert(
          (params.clientSecret != null && params.clientId != null) ||
              !isDesktop,
          'For Desktop, clientSecret and clientId cannot be null',
        ),
        _authState = _GoogleSignInAuthState.instance {
    GoogleSignInAllPlatformsInterface.instance.init(params);
  }

  final _GoogleSignInAuthState _authState;

  /// Stream that emits GoogleSignInCredentials when user signs in, and null
  /// when user signs out
  Stream<GoogleSignInCredentials?> get authenticationState {
    return _authState.controller.stream;
  }

  void _emitIfChanged(GoogleSignInCredentials? credentials) {
    if (AuthStateUtils.hasSameAccessToken(
      credentials,
      _authState.lastEmittedCredentials,
    )) {
      return;
    }

    _authState.controller.add(credentials);
    _authState.lastEmittedCredentials = credentials;
  }

  ///Executes [lightweightSignIn] first, and if unsuccessful, it executes
  ///[signInOnline].
  Future<GoogleSignInCredentials?> signIn() async {
    final credentials =
        await GoogleSignInAllPlatformsInterface.instance.signIn();
    _emitIfChanged(credentials);
    return credentials;
  }

  ///Performs Sign in using token stored in internal storage.
  ///Note:- For mobile devices, if it fails to sign in via stored token it will
  ///perform the online sign in process.
  Future<GoogleSignInCredentials?> lightweightSignIn() async {
    final credentials =
        await GoogleSignInAllPlatformsInterface.instance.lightweightSignIn();
    _emitIfChanged(credentials);
    return credentials;
  }

  /// Alias for [lightweightSignIn]
  @Deprecated('Use lightweightSignIn instead. signInOffline will be removed in a future version.')
  Future<GoogleSignInCredentials?> signInOffline() => lightweightSignIn();

  ///Performs Sign in using online flow, for all platforms.
  Future<GoogleSignInCredentials?> signInOnline() async {
    final credentials =
        await GoogleSignInAllPlatformsInterface.instance.signInOnline();
    _emitIfChanged(credentials);
    return credentials;
  }

  /// Returns a Sign-In Button for Web Platform only.
  Widget? signInButton({GSIAPButtonConfig? config}) {
    final wrappedConfig = GSIAPButtonConfig(
      uiConfig: config?.uiConfig,
      onSignIn: (credentials) {
        _emitIfChanged(credentials);
        config?.onSignIn?.call(credentials);
      },
      onSignOut: () {
        _emitIfChanged(null);
        config?.onSignOut?.call();
      },
    );

    return GoogleSignInAllPlatformsInterface.instance
        .signInButton(config: wrappedConfig);
  }

  ///Returns the authenticated http client. This should be called after the user
  ///is signed in.
  Future<http.Client?> get authenticatedClient {
    return GoogleSignInAllPlatformsInterface.instance.getAuthenticatedClient();
  }

  ///Performs the Sign Out operation and also deletes the stored token.
  Future<void> signOut() async {
    await GoogleSignInAllPlatformsInterface.instance.signOut();
    _emitIfChanged(null);
  }
}
