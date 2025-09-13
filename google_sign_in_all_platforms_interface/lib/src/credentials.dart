import 'package:flutter/material.dart';

abstract class _Constants {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  /* Here we are using 'scope' instead of 'scopes', because the json response
  returned from the Google OAuth2.0 API, also use the keyword 'scope'
  instead of 'scopes'. */
  static const _kScopes = 'scope';
  static const _kTokenType = 'token_type';
  static const _kIdToken = 'id_token';
  static const _kExpiresIn = 'expires_in';
}

///Object to store all necessary values regarding Google OAuth2.0 Credentials.
@immutable
class GoogleSignInCredentials {
  ///Object to store all necessary values regarding Google OAuth2.0 Credentials.
  ///
  ///You need to provide [refreshToken] in case you are not on a mobile device.
  const GoogleSignInCredentials({
    required this.accessToken,
    this.refreshToken,
    this.scopes = const [],
    this.tokenType,
    this.idToken,
    this.expiresIn,
  });

  ///Can be used to convert a json [Map] to this object.
  GoogleSignInCredentials.fromJson(Map<String, dynamic> json)
      : accessToken = json[_Constants._kAccessToken] as String,
        refreshToken = json[_Constants._kRefreshToken] as String?,
        scopes = List<String>.from(json[_Constants._kScopes] as List),
        tokenType = json[_Constants._kTokenType] as String?,
        idToken = json[_Constants._kIdToken] as String?,
        expiresIn =
            _dateTimeFromJsonValue(json[_Constants._kExpiresIn]?.toString());

  static DateTime? _dateTimeFromJsonValue(String? value) {
    if (value == null) return null;
    final seconds = int.tryParse(value);
    if (seconds != null) {
      return DateTime.now().add(Duration(seconds: seconds)).toUtc();
    }

    return DateTime.tryParse(value);
  }

  ///Google OAuth2.0 Access Token, this is required to create an authenticated
  ///http client, which can be further used to call the Google APIs.
  final String accessToken;

  ///Google OAuth2.0 Refresh Token, this is used to get a new [accessToken] in
  ///case of the access token getting expired.
  final String? refreshToken;

  ///Google OAuth2.0 scopes, are used to determine the types of services from
  ///that our [accessToken] can access from the GoogleAPIs.
  final List<String> scopes;

  ///Google OAuth2.0 token type. The most common token type is 'Bearer'.
  final String? tokenType;

  ///Google OAuth2.0 id token.
  final String? idToken;

  ///The date and time when the access token expires.
  final DateTime? expiresIn;

  ///Convert the object to a json [Map].
  Map<String, dynamic> toJson() => <String, dynamic>{
        _Constants._kAccessToken: accessToken,
        _Constants._kRefreshToken: refreshToken,
        _Constants._kScopes: scopes,
        _Constants._kTokenType: tokenType,
        _Constants._kIdToken: idToken,
        _Constants._kExpiresIn: expiresIn?.toIso8601String(),
      };

  @override
  bool operator ==(Object other) {
    if (other is! GoogleSignInCredentials) return false;
    return accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        scopes.length == other.scopes.length &&
        scopes.every((scope) => other.scopes.contains(scope)) &&
        tokenType == other.tokenType &&
        idToken == other.idToken &&
        expiresIn == other.expiresIn;
  }

  @override
  int get hashCode => Object.hash(
        accessToken,
        refreshToken,
        Object.hashAll(scopes),
        tokenType,
        idToken,
        expiresIn,
      );

  GoogleSignInCredentials copyWith({
    String? accessToken,
    String? refreshToken,
    List<String>? scopes,
    String? tokenType,
    String? idToken,
    DateTime? expiresIn,
  }) {
    return GoogleSignInCredentials(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      scopes: scopes ?? this.scopes,
      tokenType: tokenType ?? this.tokenType,
      idToken: idToken ?? this.idToken,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }
}
