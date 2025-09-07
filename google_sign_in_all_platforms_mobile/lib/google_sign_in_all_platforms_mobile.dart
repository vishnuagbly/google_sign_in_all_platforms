import 'dart:convert';
import 'dart:developer';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// The Android implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsMobile extends GoogleSignInAllPlatformsInterface {
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_mobile');

  // Hold the singleton and its initialization future
  GoogleSignIn get _signIn => GoogleSignIn.instance;
  Future<void>? _initializationFuture;

  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsMobile();
  }

  GoogleSignInClientAuthorization? _clientAuth;

  @override
  void init(GoogleSignInParams params) {
    super.init(params);
    // initialise once; do not await here
    _initializationFuture ??=
        _signIn.initialize(serverClientId: params.clientId);
  }

  @override
  Future<GoogleSignInCredentials?> signInOffline() async {
    final credsJsonString = await params.retrieveAccessToken.call();
    if (credsJsonString != null) {
      try {
        final credsJson =
            Map<String, dynamic>.from(jsonDecode(credsJsonString) as Map);
        return GoogleSignInCredentials.fromJson(credsJson);
      } catch (err) {
        log('$err', name: 'signInOffline');
      }
    }
    return null;
  }

  @override
  Future<GoogleSignInCredentials?> signInOnline() async {
    if (_initializationFuture != null) await _initializationFuture;

    late final GoogleSignInAccount user;

    try {
      final lastUser = await _signIn.attemptLightweightAuthentication();
      if (lastUser != null) {
        user = lastUser;
      } else {
        throw PlatformException(
            code: 'NO_PREVIOUS_SIGN_IN',
            message:
                'No previous sign-in found for lightweight authentication');
      }
    } catch (err) {
      user = await _signIn.authenticate(scopeHint: params.scopes);
    }

    // Try to get authorisation silently; if not authorised, prompt the user
    _clientAuth =
        await user.authorizationClient.authorizationForScopes(params.scopes);
    _clientAuth ??=
        await user.authorizationClient.authorizeScopes(params.scopes);

    final accessToken = _clientAuth?.accessToken;
    final idToken = user.authentication.idToken;
    if (accessToken == null) {
      return null; // no access token available
    }

    final creds = GoogleSignInCredentials(
      accessToken: accessToken,
      scopes: params.scopes,
      tokenType: 'Bearer',
      idToken: idToken,
    );

    await params.saveAccessToken.call(jsonEncode(creds.toJson()));

    return creds;
  }

  @override

  /// For mobile, there is no need to await, hence can also be called like this:
  /// ```dart
  /// final authClient = unawaited(getAuthenticatedClient());
  /// ```
  Future<http.Client?> getAuthenticatedClient() async {
    // Return an authenticated HTTP client if we have authorisation
    final auth = _clientAuth;
    if (auth != null) {
      // authClient comes from the extension_google_sign_in_as_googleapis_auth package
      return auth.authClient(scopes: params.scopes);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await params.deleteAccessToken();
    await _signIn.signOut();
    _clientAuth = null;
  }

  @override
  Widget? signInButton({GSIAPButtonConfig? config}) {
    throw UnimplementedError("signInButton is not available on Mobile");
  }
}
