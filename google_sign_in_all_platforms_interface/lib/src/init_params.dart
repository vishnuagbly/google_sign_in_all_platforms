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
    this.customPostAuthPage,
  });

  static const _kTokenKey = 'token';

  ///Only used in case of Desktop, where we perform OAuth2.0 by
  ///opening the Google OAuth2.0 link in the default browser, this is the
  ///total time till we wait for the user to login, after this, the temporary
  ///server is closed, and user might have restart the whole process.
  final Duration timeout;

  ///Used for after receiving the token, we want to save the token in the local
  ///storage / cache.
  final Future<void> Function(String) saveAccessToken;

  ///Used for, when signing in offline, we need to retrieve the already stored
  ///access token from the internal storage.
  final Future<String?> Function() retrieveAccessToken;

  ///Used for, when signing out, we need to remove the already stored access
  ///token from the internal storage.
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

  ///Custom HTML page to display during the authentication process.
  ///
  ///**Desktop platforms only** - This parameter is ignored on mobile and web.
  ///
  ///When provided, this HTML content will be used instead of the default 
  ///authentication page. The plugin will inject a JavaScript script into your 
  ///HTML that is required for Google's Implicit Authentication to handle OAuth2 
  ///responses from both implicit flow (fragments) and authorization code flow 
  ///(query parameters).
  ///
  ///**Requirements:**
  ///- Must be valid HTML with proper DOCTYPE declaration or HTML tags
  ///- Should include `<head>`, `<body>`, and basic HTML structure
  ///- The authentication script will be automatically injected before `</body>` or `</html>`
  ///
  ///**Injected Script Handles:**
  ///- OAuth2 response parsing (fragments and query parameters)
  ///- Token submission to `/token` endpoint
  ///- Error handling and user feedback via custom events
  ///
  ///**Highly Recommended:** Use the exposed custom events to handle UI state 
  ///changes in your HTML page. The injected script dispatches the following events:
  ///- `google-auth-success`: When authentication succeeds
  ///- `google-auth-error`: When authentication fails  
  ///- `google-auth-token-processing`: When token processing begins
  ///
  ///**Example:**
  ///```dart
  ///GoogleSignInParams(
  ///  clientId: 'your-client-id',
  ///  clientSecret: 'your-client-secret',
  ///  customPostAuthPage: '''
  ///<!DOCTYPE html>
  ///<html>
  ///  <head>
  ///    <title>My App - Authentication</title>
  ///    <style>
  ///      body { font-family: Arial; text-align: center; }
  ///      .container { max-width: 400px; margin: 50px auto; }
  ///    </style>
  ///  </head>
  ///  <body>
  ///    <div class="container">
  ///      <h1>🔐 MyApp</h1>
  ///      <p id="status">Processing authentication...</p>
  ///    </div>
  ///    <script>
  ///      document.addEventListener('google-auth-success', function(event) {
  ///        document.getElementById('status').textContent = 
  ///          '✅ Success! You can close this window.';
  ///      });
  ///    </script>
  ///  </body>
  ///</html>''',
  ///);
  ///```
  ///
  ///If `null` (default), the built-in authentication page will be used.
  final String? customPostAuthPage;

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
