import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:google_sign_in_all_platforms_interface/src/credentials.dart';
import 'package:http/src/client.dart';

/// An implementation of [GoogleSignInAllPlatformsInterface] that uses method channels.
class MethodChannelGoogleSignInAllPlatforms extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.dart.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms');


  @override
  Future<GoogleSignInCredentials?> signInOffline() {
    // TODO(vishnuagbly): implement signInOffline
    throw UnimplementedError();
  }

  @override
  Future<GoogleSignInCredentials?> signInOnline() {
    // TODO(vishnuagbly): implement signInOnline
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO(vishnuagbly): implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Client?> getAuthenticatedClient() {
    // TODO(vishnuagbly): implement getAuthenticatedClient
    throw UnimplementedError();
  }
}
