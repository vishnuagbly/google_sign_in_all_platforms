import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:url_launcher/url_launcher.dart';

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// The Desktop implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsDesktop
    extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_desktop');

  /// Registers this class as the default instance of
  /// [GoogleSignInAllPlatformsInterface]
  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsDesktop();
  }

  HttpServer? _server;
  Completer<GoogleSignInCredentials?>? _completer;
  GoogleSignInCredentials? __credentials;

  static const String _kAccessTokenCredsKey = 'access_token';
  static const String _kRefreshTokenCredsKey = 'refresh_token';
  static const String _kTokenTypeCredsKey = 'token_type';
  static const String _kScopeCredsKey = 'scope';
  static const String _kScopesSeparator = ' ';
  static const String _kLogName = 'GoogleSignInAllPlatformsMacOS';
  static const String _kDefaultPostAuthPagePath =
      'packages/google_sign_in_all_platforms_desktop/assets/post_auth_page.html';

  String get _redirectUri => 'http://localhost:${params.redirectPort}';

  void _setCredentials(GoogleSignInCredentials credentials) {
    __credentials = credentials;
    _completer?.complete(credentials);
  }

  GoogleSignInCredentials? get _credentials => __credentials;

  Future<Response> _handleAccessCodeRoute(Request request) async {
    final code = request.requestedUri.queryParametersAll['code']?.first;
    await _getCredentialsFromAccessCode(code);
    final htmlContent = params.customPostAuthPage ??
        await rootBundle.loadString(_kDefaultPostAuthPagePath);

    return Response.ok(
      htmlContent,
      headers: {'content-type': 'text/html'},
      encoding: utf8,
    );
  }

  Future<void> _getCredentialsFromAccessCode(String? code) async {
    if (code == null) return;
    final res = await http.post(
      Uri.https('oauth2.googleapis.com', '/token', {
        'client_id': params.clientId,
        'client_secret': params.clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': _redirectUri,
      }),
    );

    if (res.statusCode == 200) {
      final credsMap = Map<String, dynamic>.from(jsonDecode(res.body) as Map);
      credsMap[_kScopeCredsKey] =
          (credsMap[_kScopeCredsKey]! as String).split(' ');
      final creds = GoogleSignInCredentials.fromJson(credsMap);
      await params.saveAccessToken.call(jsonEncode(creds.toJson()));
      _setCredentials(creds);
    }
  }

  @override
  Future<GoogleSignInCredentials?> signInOffline() async {
    final credsJsonString = await params.retrieveAccessToken.call();
    if (credsJsonString == null) return null;

    try {
      final credsJson =
          Map<String, dynamic>.from(jsonDecode(credsJsonString) as Map);
      _setCredentials(GoogleSignInCredentials.fromJson(credsJson));
      return _credentials!;
    } catch (err) {
      log('$err', name: _kLogName);
      return null;
    }
  }

  @override
  Future<http.Client?> getAuthenticatedClient() async {
    final credentials = _credentials;
    if (credentials == null) return null;

    final creds = <String, dynamic>{
      _kAccessTokenCredsKey: credentials.accessToken,
      _kScopeCredsKey:
          (credentials.scopes.isEmpty ? params.scopes : credentials.scopes)
              .join(_kScopesSeparator),
      _kRefreshTokenCredsKey: credentials.refreshToken,
      _kTokenTypeCredsKey: credentials.tokenType,
    };

    return __getAuthenticatedClient(creds);
  }

  static http.Client __getAuthenticatedClient(Map<String, dynamic> creds) {
    final accessToken = creds[_kAccessTokenCredsKey];
    final refreshToken = creds[_kRefreshTokenCredsKey];
    final scopes = (creds[_kScopeCredsKey]! as String).split(' ');
    final accessCreds = gapis.AccessCredentials(
      gapis.AccessToken(
        (creds[_kTokenTypeCredsKey] ?? 'Bearer') as String,
        accessToken as String,
        DateTime.now().toUtc().add(const Duration(days: 365)),
      ),
      refreshToken as String?,
      scopes,
    );
    return gapis.authenticatedClient(http.Client(), accessCreds);
  }

  shelf_router.Router _initializeRouter() {
    return shelf_router.Router()..get('/', _handleAccessCodeRoute);
  }

  Future<void> _startServer(shelf_router.Router app) async {
    if (_server != null) return;
    _server = await io.serve(app.call, 'localhost', params.redirectPort);
  }

  Future<void> _closeServer() async {
    try {
      await _server?.close();
      _server = null;
    } catch (err) {
      rethrow;
    }
  }

  void _launchUrl() {
    launchUrl(
      Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        if (params.clientId != null) 'client_id': params.clientId,
        'response_type': 'code',
        'redirect_uri': _redirectUri,
        'scope': params.scopes.join(_kScopesSeparator),
        'access_type': 'offline',
      }),
    );
  }

  void _completeOnTimeout() {
    Future<void>.delayed(params.timeout)
        .then((_) => _completer?.complete(null));
  }

  Future<GoogleSignInCredentials?> _waitForClient() async {
    _completer = Completer<GoogleSignInCredentials?>();
    _completeOnTimeout();
    final creds = await _completer?.future;
    _completer = null;
    return creds;
  }

  @override
  Future<GoogleSignInCredentials?> signInOnline() async {
    final app = _initializeRouter();
    await _startServer(app);
    _launchUrl();

    final creds = await _waitForClient();
    if (creds != null) return creds;

    await _closeServer();

    return null;
  }

  @override
  Future<void> signOut() async {
    await params.deleteAccessToken();
    __credentials = null;
  }
}
