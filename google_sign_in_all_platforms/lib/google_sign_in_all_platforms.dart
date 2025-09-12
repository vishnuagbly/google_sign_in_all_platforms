import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in_all_platforms/src/auth_state_utils.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

///Use this class to perform all types of Google OAuth operations.
class GoogleSignIn {
  ///Use this class to perform all types of Google OAuth operations.
  GoogleSignIn({GoogleSignInParams params = const GoogleSignInParams()})
      : assert(
          (params.clientSecret != null && params.clientId != null) ||
              !isDesktop,
          'For Desktop, clientSecret and clientId cannot be null',
        ) {
    GoogleSignInAllPlatformsInterface.instance.init(params);
  }

  StreamController<GoogleSignInCredentials?>? _authStreamController;
  GoogleSignInCredentials? _lastEmittedCredentials;

  /// Stream that emits GoogleSignInCredentials when user signs in, and null
  /// when user signs out
  Stream<GoogleSignInCredentials?> get authenticationState {
    _authStreamController ??=
        StreamController<GoogleSignInCredentials?>.broadcast();
    return _authStreamController!.stream;
  }

  void _emitIfChanged(GoogleSignInCredentials? credentials) {
    var shouldEmit = false;

    if (credentials == null && _lastEmittedCredentials != null) {
      shouldEmit = true;
    } else if (credentials != null && _lastEmittedCredentials == null) {
      shouldEmit = true;
    } else if (credentials != null && _lastEmittedCredentials != null) {
      shouldEmit = !AuthStateUtils.hasSameAccessToken(
        credentials,
        _lastEmittedCredentials,
      );
    }

    if (shouldEmit) {
      _authStreamController?.add(credentials);
      _lastEmittedCredentials = credentials;
    }
  }

  ///Executes [signInOffline] first, and if unsuccessful, it executes
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
  Future<GoogleSignInCredentials?> signInOffline() async {
    final credentials =
        await GoogleSignInAllPlatformsInterface.instance.signInOffline();
    _emitIfChanged(credentials);
    return credentials;
  }

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

  /// Dispose resources when GoogleSignIn instance is no longer needed
  void dispose() {
    _authStreamController?.close();
    _authStreamController = null;
    _lastEmittedCredentials = null;
  }
}
