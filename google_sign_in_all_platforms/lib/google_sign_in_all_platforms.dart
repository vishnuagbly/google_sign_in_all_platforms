import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';
import 'package:http/http.dart' as http;

export 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

///Use this class to perform all types of Google OAuth operations.
class GoogleSignIn {
  ///Use this class to perform all types of Google OAuth operations.
  GoogleSignIn({GoogleSignInParams params = const GoogleSignInParams()}) {
    GoogleSignInAllPlatformsPlatform.instance.init(params);
  }

  ///Performs Sign in using token stored in internal storage.
  ///Note:- For mobile devices, if it fails to sign in via stored token it will
  ///perform the online sign in process.
  Future<http.Client?> signInOffline() {
    return GoogleSignInAllPlatformsPlatform.instance.signInOffline();
  }

  ///Performs Sign in using online flow, for all platforms.
  Future<http.Client?> signInOnline() {
    return GoogleSignInAllPlatformsPlatform.instance.signInOnline();
  }

  ///Performs the Sign Out operation and also deletes the stored token.
  Future<void> signOut() {
    return GoogleSignInAllPlatformsPlatform.instance.signOut();
  }
}
