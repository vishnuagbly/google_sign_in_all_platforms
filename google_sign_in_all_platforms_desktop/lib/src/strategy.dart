import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_desktop/google_sign_in_all_platforms_desktop.dart';
import 'package:google_sign_in_all_platforms_desktop/src/strategies/implicit_strategy.dart';
import 'package:google_sign_in_all_platforms_desktop/src/strategies/pkce_strategy.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:url_launcher/url_launcher.dart';

abstract class SignInStrategy {
  final GoogleSignInAllPlatformsDesktop interface;
  @protected
  final shelf_router.Router router;
  HttpServer? _server;
  @protected
  Completer<GoogleSignInCredentials?>? _completer;

  static const String kDefaultPostAuthPagePath =
      'packages/google_sign_in_all_platforms_desktop/assets/post_auth_page.html';

  static const String kScopesSeparator = ' ';
  static const String kScopeCredsKey = 'scope';

  @protected
  String get redirectUri => 'http://localhost:${interface.params.redirectPort}';

  SignInStrategy(this.interface) : router = shelf_router.Router() {
    router.get('/', handleRedirectRoute);
  }

  static SignInStrategy from(GoogleSignInAllPlatformsDesktop interface) {
    if (_getClientSecret(interface) == null) {
      return ImplicitStrategy(interface);
    }
    return PKCEStrategy(interface);
  }

  String? get clientId => interface.params.clientId;

  String? get clientSecret => _getClientSecret(interface);

  static _getClientSecret(GoogleSignInAllPlatformsDesktop interface) {
    return interface.params.clientSecret;
  }

  @protected
  Future<Response> handleRedirectRoute(Request request) async {
    return createHTMLResponse(await customAuthPageHtmlContent);
  }

  @protected
  Future<String> get customAuthPageHtmlContent async =>
      interface.params.customPostAuthPage ??
      await rootBundle.loadString(SignInStrategy.kDefaultPostAuthPagePath);

  @protected
  Response createHTMLResponse(String htmlContent) => Response.ok(
        htmlContent,
        headers: {'content-type': 'text/html'},
        encoding: utf8,
      );

  @protected
  void completeSignIn(FutureOr<GoogleSignInCredentials?>? credentials) {
    _completer?.complete(credentials);
  }

  @protected
  void completeSignInError(Object error) {
    _completer?.completeError(error);
  }

  Future<void> _startServer(shelf_router.Router app) async {
    if (_server != null) return;
    _server = await io.serve(
      app.call,
      'localhost',
      interface.params.redirectPort,
    );
  }

  Future<void> _closeServer() async {
    try {
      await _server?.close();
      _server = null;
    } catch (err) {
      rethrow;
    }
  }

  @protected
  Map<String, dynamic>? genAuthRequestQueryParameters();

  void _launchUrl() {
    final clientId = this.clientId;
    if (clientId == null) {
      throw PlatformException(
        code: 'NULL CLIENT_ID',
        message: 'Client is null',
      );
    }

    final queryParameters = genAuthRequestQueryParameters() ?? {};
    launchUrl(
      Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        ...queryParameters,
        if (!queryParameters.containsKey('client_id')) 'client_id': clientId,
        if (!queryParameters.containsKey('redirect_uri'))
          'redirect_uri': redirectUri,
        if (!queryParameters.containsKey('scope'))
          'scope':
              interface.params.scopes.join(SignInStrategy.kScopesSeparator),
      }),
    );
  }

  void _completeOnTimeout() {
    Future<void>.delayed(interface.params.timeout)
        .then((_) => _completer?.complete(null));
  }

  Future<GoogleSignInCredentials?> _waitForClient() async {
    _completer = Completer<GoogleSignInCredentials?>();
    _completeOnTimeout();
    try {
      final creds = await _completer?.future;
      return creds;
    } catch (err) {
      rethrow;
    } finally {
      _completer = null;
    }
  }

  Future<GoogleSignInCredentials?> signInOnline() async {
    await _startServer(router);
    _launchUrl();
    final creds = await _waitForClient();
    await _closeServer();
    return creds;
  }
}
