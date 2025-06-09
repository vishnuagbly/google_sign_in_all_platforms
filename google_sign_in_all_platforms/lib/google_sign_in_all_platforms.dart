import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

///Use this class to perform all types of Google OAuth operations.
class GoogleSignIn {
  ///Use this class to perform all types of Google OAuth operations.
  GoogleSignIn({GoogleSignInParams params = const GoogleSignInParams()})
      : assert(
          (params.clientSecret != null && params.clientId != null) ||
              !isDesktop,
          'For Desktop, clientSecret and clientId cannot be null',
        ) {
    GoogleSignInAllPlatformsInterface.instance.init(params);
  }

  ///Executes [signInOffline] first, and if unsuccessful, it executes
  ///[signInOnline].
  Future<GoogleSignInCredentials?> signIn() {
    return GoogleSignInAllPlatformsInterface.instance.signIn();
  }

  ///Performs Sign in using token stored in internal storage.
  ///Note:- For mobile devices, if it fails to sign in via stored token it will
  ///perform the online sign in process.
  Future<GoogleSignInCredentials?> signInOffline() {
    return GoogleSignInAllPlatformsInterface.instance.signInOffline();
  }

  ///Performs Sign in using online flow, for all platforms.
  Future<GoogleSignInCredentials?> signInOnline() {
    return GoogleSignInAllPlatformsInterface.instance.signInOnline();
  }

  ///Returns the authenticated http client. This should be called after the user
  ///is signed in.
  Future<http.Client?> get authenticatedClient {
    return GoogleSignInAllPlatformsInterface.instance.getAuthenticatedClient();
  }

  ///Performs the Sign Out operation and also deletes the stored token.
  Future<void> signOut() {
    return GoogleSignInAllPlatformsInterface.instance.signOut();
  }
}
