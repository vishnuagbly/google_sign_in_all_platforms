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

  @protected
  GoogleSignIn get googleSignIn => GoogleSignIn.instance;
  Future<void>? _initializationFuture;

  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsMobile();
  }

  @protected
  GoogleSignInClientAuthorization? clientAuth;

  @protected
  void initRaw(GoogleSignInParams params) => super.init(params);

  @override
  void init(GoogleSignInParams params) {
    super.init(params);
    // initialise once; do not await here
    _initializationFuture ??=
        googleSignIn.initialize(serverClientId: params.clientId);
  }

  @override
  Future<GoogleSignInCredentials?> lightweightSignInImpl() async {
    final user = await googleSignIn.attemptLightweightAuthentication();
    if (user == null) return null;
    return genCreds(user);
  }

  @override
  Future<GoogleSignInCredentials?> signInOnlineImpl() async {
    if (_initializationFuture != null) await _initializationFuture;

    try {
      final GoogleSignInAccount user = await googleSignIn.authenticate(
        scopeHint: params.scopes,
      );
      return genCreds(user);
    } catch (e) {
      // User cancelled the sign-in flow
      return null;
    }
  }

  @protected
  Future<GoogleSignInCredentials?> genCreds(GoogleSignInAccount user) async {
    clientAuth = await _ensureAuthorization(user, params.scopes);
    final accessToken = clientAuth?.accessToken;
    final idToken = user.authentication.idToken; // auth has only idToken in v7

    if (accessToken == null) return null;

    final creds = GoogleSignInCredentials(
      accessToken: accessToken,
      scopes: params.scopes,
      tokenType: 'Bearer',
      idToken: idToken,
    );

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

    // If not authorized yet, this may show a popup; ensure you call
    // this from a user gesture (e.g., the same tap that exposed the button).
    return await user.authorizationClient.authorizeScopes(scopes);
  }

  /// For mobile, there is no need to await, hence can also be called like this:
  /// ```dart
  /// final authClient = unawaited(getAuthenticatedClient());
  /// ```
  @override
  Future<http.Client?> getAuthenticatedClient() async {
    // Return an authenticated HTTP client if we have authorisation
    final auth = clientAuth;
    if (auth != null) {
      // authClient comes from the extension_google_sign_in_as_googleapis_auth package
      return auth.authClient(scopes: params.scopes);
    }

    return super.getAuthenticatedClient();
  }

  @protected
  Future<http.Client?> interfaceGetAuthenticatedClient() async {
    return super.getAuthenticatedClient();
  }

  @override
  Future<void> signOutImpl() async {
    await googleSignIn.signOut();
    clientAuth = null;
  }
}
