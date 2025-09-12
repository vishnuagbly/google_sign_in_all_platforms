import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// Utility functions for authentication state management
class AuthStateUtils {
  AuthStateUtils._(); // Private constructor to prevent instantiation

  /// Checks if two credentials have the same access token.
  /// This is NOT a full equality check - only compares access tokens.
  /// Useful for detecting when credentials have actually changed.
  ///
  /// Returns true if both credentials have the same access token,
  /// false otherwise (including when one or both are null).
  static bool hasSameAccessToken(
    GoogleSignInCredentials? first,
    GoogleSignInCredentials? second,
  ) {
    if (first == null || second == null) return false;
    return first.accessToken == second.accessToken;
  }
}
