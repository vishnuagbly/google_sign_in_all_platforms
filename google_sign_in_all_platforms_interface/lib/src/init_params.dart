import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

///This class contains all the parameters that might be needed for performing
///the google sign in operation
class GoogleSignInParams {
  ///This class contains all the parameters that might be needed for performing
  ///the google sign in operation.
  const GoogleSignInParams({
    this.timeout = const Duration(minutes: 1),
    this.saveAccessToken = _defaultSaveAccessToken,
    this.retrieveAccessToken = _defaultRetrieveAccessToken,
    this.deleteAccessToken = _defaultDeleteAccessToken,
    this.scopes = const [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
    ],
    this.redirectPort = 8000,
    this.clientId,
    this.clientSecret,
  });

  static const _kTokenKey = 'token';

  ///Only used in case of Desktop, where we perform OAuth2.0 by
  ///opening the Google OAuth2.0 link in the default browser, this is the
  ///total time till we wait for the user to login, after this, the temporary
  ///server is closed, and user might have restart the whole process.
  final Duration timeout;

  ///Only used in case of Desktop, where after receiving the token,
  ///we want to save the token locally.
  final Future<void> Function(String) saveAccessToken;

  ///Only used in case of Desktop, where on signing in online, we need
  ///to retrieve the already stored access token from the internal storage.
  final Future<String?> Function() retrieveAccessToken;

  ///Only used in case of Desktop, where on signing out, we need to remove the
  ///already stored access token from the internal storage.
  final Future<void> Function() deleteAccessToken;

  ///Passed on to Google OAuth2.0 scopes parameter.
  final List<String> scopes;

  ///Only used in case of Desktop, where on signing in, we need to provide a
  ///redirect localhost port, where the access code and more will be received.
  final int redirectPort;

  ///Required and Only used in case of Desktop.
  ///
  ///Google Project Client Id, it should be of "web" type.
  final String? clientId;

  ///Required and Only used in case of Desktop
  ///
  ///Google Project Client Secret, it should of "web' type.
  final String? clientSecret;

  static Future<void> _defaultSaveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final res = await prefs.setString(_kTokenKey, token);
    assert(res == true, 'Insertion of Token Unsuccessful');
  }

  static Future<String?> _defaultRetrieveAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTokenKey);
  }

  static Future<void> _defaultDeleteAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final res = await prefs.remove(_kTokenKey);
    assert(res == true, 'Deletion of Token Unsuccessful');
  }
}
