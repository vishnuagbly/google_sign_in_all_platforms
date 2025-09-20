import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_desktop/src/strategy.dart';
import 'package:shelf/shelf.dart';

import '../../google_sign_in_all_platforms_desktop.dart';
import '../../html_script_injector.dart';

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

    body[SignInStrategy.kScopeCredsKey] ??= interface.params.scopes;
    completeSignIn(GoogleSignInCredentials.fromJson(body));
    return Response.ok(
      jsonEncode({'status': 'ok'}),
      headers: {'content-type': 'application/json'},
      encoding: utf8,
    );
  }

  @override
  Future<Response> handleRedirectRoute(Request request) async {
    final htmlContent = await HtmlScriptInjector.injectAuthScript(
      interface.params.customPostAuthPage ??
          await rootBundle.loadString(SignInStrategy.kDefaultPostAuthPagePath),
    );

    return createHTMLResponse(htmlContent);
  }

  @override
  Map<String, dynamic>? genAuthRequestQueryParameters() {
    return {
      'response_type': 'token',
      'prompt': 'consent',
    };
  }
}
