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

/// The MacOS implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsMacOS extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_macos');

  /// Registers this class as the default instance of
  /// [GoogleSignInAllPlatformsInterface]
  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsMacOS();
  }

  HttpServer? _server;
  http.Client? _authenticatedClient;
  Completer<http.Client?>? _completer;

  static const String _kAccessTokenCredsKey = 'access_token';
  static const String _kScopeCredsKey = 'scope';
  static const String _kScopesSeparator = ' ';
  static const String _kLogName = 'GoogleSignInAllPlatformsMacOS';

  String get _redirectUri => 'http://localhost:${params.redirectPort}';

  void _setAuthenticatedClient(http.Client? client) {
    _authenticatedClient = client;
    _completer?.complete(_authenticatedClient);
  }

  Future<Response> _handleAccessCodeRoute(Request request) async {
    log('uri: ${request.url}', name: _kLogName);
    final code = request.requestedUri.queryParametersAll['code']?.first;
    await _getCredentialsFromAccessCode(code);
    return Response.ok(
      'Successfully Authenticated, You may now close this tab',
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
      final creds = Map<String, dynamic>.from(jsonDecode(res.body) as Map);
      await params.saveAccessToken.call(creds[_kAccessTokenCredsKey] as String);

      log('from server creds: $creds', name: _kLogName);
      _getAuthenticatedClient(creds);
    }
  }

  @override
  Future<http.Client?> signInOffline() async {
    final token = await params.retrieveAccessToken.call();
    if (token == null) return null;

    final creds = <String, dynamic>{
      _kAccessTokenCredsKey: token,
      _kScopeCredsKey: params.scopes.join(_kScopesSeparator),
    };

    log('in storage creds: $creds', name: _kLogName);
    return _getAuthenticatedClient(creds);
  }

  http.Client _getAuthenticatedClient(Map<String, dynamic> creds) {
    _setAuthenticatedClient(__getAuthenticatedClient(creds));
    return _authenticatedClient!;
  }

  static http.Client __getAuthenticatedClient(Map<String, dynamic> creds) {
    final accessToken = creds[_kAccessTokenCredsKey];
    final scopes = (creds[_kScopeCredsKey]! as String).split(' ');
    final accessCreds = gapis.AccessCredentials(
      gapis.AccessToken(
        (creds['token_type'] ?? 'Bearer') as String,
        accessToken as String,
        DateTime.now().toUtc().add(const Duration(days: 365)),
      ),
      null,
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
    log('Server Started!', name: _kLogName);
  }

  Future<void> _closeServer() async {
    try {
      await _server?.close();
      _server = null;
      log('Server Closed!', name: _kLogName);
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

  Future<http.Client?> _waitForClient() async {
    _completer = Completer<http.Client?>();
    _completeOnTimeout();
    final client = await _completer?.future;
    _completer = null;
    return client;
  }

  @override
  Future<http.Client?> signInOnline() async {
    final app = _initializeRouter();
    await _startServer(app);
    _launchUrl();

    final client = await _waitForClient();
    if (client != null) return client;

    await _closeServer();

    return null;
  }

  @override
  Future<void> signOut() async {
    await params.deleteAccessToken();
    _authenticatedClient = null;
  }
}
