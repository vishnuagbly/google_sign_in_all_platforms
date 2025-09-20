import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_desktop/src/strategy.dart';
import 'package:shelf/shelf.dart';

import '../../google_sign_in_all_platforms_desktop.dart';

class ImplicitStrategy extends SignInStrategy {
  ImplicitStrategy(super.interface) {
    router.post('/token', _handleTokenRequest);
  }

  Future<Response> _handleTokenRequest(Request request) async {
    final payload = await request.readAsString();
    final body = jsonDecode(payload) as Map<String, dynamic>;

    if (body['error'] != null) {
      completeSignInError(PlatformException(
        code: 'ERR_TOKEN',
        message: body['error'],
      ));
      return Response.internalServerError(body: body);
    }

    _ensureScopes(body);
    completeSignIn(GoogleSignInCredentials.fromJson(body));
    return Response.ok(
      jsonEncode({'status': 'ok'}),
      headers: {'content-type': 'application/json'},
      encoding: utf8,
    );
  }

  void _ensureScopes(Map<String, dynamic> body) {
    final scopes = body[SignInStrategy.kScopeCredsKey];
    if (scopes is String) {
      body[SignInStrategy.kScopeCredsKey] =
          scopes.split(SignInStrategy.kScopesSeparator);
    }
    if (scopes == null) {
      body[SignInStrategy.kScopeCredsKey] = interface.params.scopes;
    }
  }

  @override
  Map<String, dynamic>? genAuthRequestQueryParameters() {
    return {
      'response_type': 'token',
      'prompt': 'consent',
    };
  }
}
