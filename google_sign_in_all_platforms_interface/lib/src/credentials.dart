abstract class _Constants {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  /* Here we are using 'scope' instead of 'scopes', because the json response
  returned from the Google OAuth2.0 API, also use the keyword 'scope'
  instead of 'scopes'. */
  static const _kScopes = 'scope';
  static const _kTokenType = 'token_type';
  static const _kIdToken = 'id_token';
}

///Object to store all necessary values regarding Google OAuth2.0 Credentials.
class GoogleSignInCredentials {
  ///Object to store all necessary values regarding Google OAuth2.0 Credentials.
  ///
  ///You need to provide [refreshToken] in case you are not on a mobile device.
  GoogleSignInCredentials({
    required this.accessToken,
    this.refreshToken,
    this.scopes = const [],
    this.tokenType,
    this.idToken,
  });

  ///Can be used to convert a json [Map] to this object.
  GoogleSignInCredentials.fromJson(Map<String, dynamic> json)
      : accessToken = json[_Constants._kAccessToken] as String,
        refreshToken = json[_Constants._kRefreshToken] as String?,
        scopes = List<String>.from(json[_Constants._kScopes] as List),
        tokenType = json[_Constants._kTokenType] as String?,
        idToken = json[_Constants._kIdToken] as String?;

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

  ///Convert the object to a json [Map].
  Map<String, dynamic> toJson() => <String, dynamic>{
        _Constants._kAccessToken: accessToken,
        _Constants._kRefreshToken: refreshToken,
        _Constants._kScopes: scopes,
        _Constants._kTokenType: tokenType,
        _Constants._kIdToken: idToken,
      };
}
