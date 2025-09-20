import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_desktop/code_challenge.dart';
import 'package:google_sign_in_all_platforms_desktop/src/strategy.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../../google_sign_in_all_platforms_desktop.dart';

class PKCEStrategy extends SignInStrategy {
  PKCEStrategy(super.interface);

  CodeChallenge? codeChallenge;

  @override
  Map<String, dynamic>? genAuthRequestQueryParameters() {
    codeChallenge = CodeChallenge();
    return {
      'response_type': 'code',
      'access_type': 'offline',
      'prompt': 'consent',
      'code_challenge': codeChallenge!.codeChallenge,
      'code_challenge_method': 'S256',
    };
  }

  @override
  Future<Response> handleRedirectRoute(Request request) async {
    final code = request.requestedUri.queryParametersAll['code']?.first;
    await _getCredentialsFromAccessCode(code);

    return super.handleRedirectRoute(request);
  }

  Future<void> _getCredentialsFromAccessCode(String? code) async {
    if (code == null) return;
    if (clientId == null) {
      throw PlatformException(
        code: 'NULL_CLIENT_ID',
        message: 'Client Id is null',
      );
    }

    final res = await http.post(
      Uri.https('oauth2.googleapis.com', '/token', {
        'client_id': clientId,
        if (clientSecret != null) 'client_secret': clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
        'code_verifier': codeChallenge!.codeVerifier,
      }),
    );

    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      final credsMap = Map<String, dynamic>.from(body as Map);
      credsMap[SignInStrategy.kScopeCredsKey] =
          (credsMap[SignInStrategy.kScopeCredsKey]! as String).split(' ');
      completeSignIn(GoogleSignInCredentials.fromJson(credsMap));
    }

    completeSignInError(
      PlatformException(code: 'TOKEN_${res.statusCode}', message: body),
    );
  }
}
