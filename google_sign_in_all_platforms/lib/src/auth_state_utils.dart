import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// Utility functions for authentication state management
class AuthStateUtils {
  AuthStateUtils._(); // Private constructor to prevent instantiation

  /// Checks if two credentials have the same access token.
  static bool hasSameAccessToken(
    GoogleSignInCredentials? first,
    GoogleSignInCredentials? second,
  ) {
    return first?.accessToken == second?.accessToken;
  }
}
