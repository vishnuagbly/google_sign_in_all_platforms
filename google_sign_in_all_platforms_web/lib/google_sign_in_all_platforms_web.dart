import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:google_sign_in_all_platforms_web/utils/gsi_button_configuration.dart';
import 'package:google_sign_in_web/web_only.dart' as web_only;
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// The Web implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsWeb extends GoogleSignInAllPlatformsInterface {
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms_web');

  static void registerWith(Registrar registrar) {
    GoogleSignInAllPlatformsInterface.instance = GoogleSignInAllPlatformsWeb();
  }

  GoogleSignIn get _signIn => GoogleSignIn.instance;

  Future<void>? _initFuture;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;

  GoogleSignInAccount? _user;
  GoogleSignInClientAuthorization? _clientAuth;

  void Function(GoogleSignInCredentials)? onSignIn;
  void Function()? onSignOut;

  @override
  void init(GoogleSignInParams params) {
    // Web ignores serverClientId; use clientId only.
    _initFuture ??= _signIn.initialize(clientId: params.clientId);

    // Listen for sign-in/out events; this is how web reports auth changes.
    _authSub ??= _signIn.authenticationEvents.listen((evt) {
      if (evt is GoogleSignInAuthenticationEventSignIn) {
        _user = evt.user;
        _genCreds(evt.user).then((creds) {
          if (creds != null) {
            onSignIn?.call(creds);
          }
        });
      } else {
        _user = null;
        _clientAuth = null;
        onSignOut?.call();
      }
    });

    super.init(params);
  }

  /// Place this widget in your login UI on Web.
  /// This is the ONLY supported way to start GIS auth on web.
  /// Example: `child: platform.signInButton(configuration: web_only.GSIButtonConfiguration(...))`
  @override
  Widget signInButton({GSIAPButtonConfig? config}) {
    final uiConfig = config?.uiConfig;
    onSignIn = config?.onSignIn;
    onSignOut = config?.onSignOut;

    return web_only.renderButton(
      configuration:
          (uiConfig != null)
              ? GSIAPButtonConfigUtils.fromGSIAP(uiConfig)
              : null,
    );
  }

  Future<GoogleSignInCredentials?> _genCreds(GoogleSignInAccount user) async {
    _clientAuth = await _ensureAuthorization(user, params.scopes);
    final accessToken = _clientAuth?.accessToken;
    final idToken = user.authentication.idToken; // auth has only idToken in v7

    if (accessToken == null) return null;

    final creds = GoogleSignInCredentials(
      accessToken: accessToken,
      scopes: params.scopes,
      tokenType: 'Bearer',
      idToken: idToken,
    );

    await params.saveAccessToken.call(jsonEncode(creds.toJson()));
    return creds;
  }

  Future<GoogleSignInClientAuthorization?> _ensureAuthorization(
    GoogleSignInAccount user,
    List<String> scopes,
  ) async {
    // Try cached token without UI
    final silent = await user.authorizationClient.authorizationForScopes(
      scopes,
    );
    if (silent != null) return silent;

    // If not authorized yet, this may show a browser popup; ensure you call
    // this from a user gesture (e.g., the same tap that exposed the button).
    return await user.authorizationClient.authorizeScopes(scopes);
  }

  @override
  Future<GoogleSignInCredentials?> signInOffline() async {
    final credsJsonString = await params.retrieveAccessToken.call();
    if (credsJsonString != null) {
      try {
        final credsJson = Map<String, dynamic>.from(
          jsonDecode(credsJsonString) as Map,
        );
        return GoogleSignInCredentials.fromJson(credsJson);
      } catch (err) {
        log('$err', name: 'signInOffline');
      }
    }
    return null;
  }

  @override
  Future<GoogleSignInCredentials?> signIn() {
    throw UnimplementedError(
      'Use the signInButton() widget to trigger sign-in on web.',
    );
  }

  @override
  Future<GoogleSignInCredentials?> signInOnline() {
    throw UnimplementedError(
      'Use the signInButton() widget to trigger sign-in on web.',
    );
  }

  @override
  Future<http.Client?> getAuthenticatedClient() async {
    final auth = _clientAuth;
    if (auth == null) return null;
    return auth.authClient(scopes: params.scopes);
  }

  @override
  Future<void> signOut() async {
    await params.deleteAccessToken.call();
    await _signIn.signOut();
    _user = null;
    _clientAuth = null;
  }
}
