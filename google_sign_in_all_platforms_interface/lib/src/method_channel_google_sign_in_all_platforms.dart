import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:http/http.dart';

/// An implementation of [GoogleSignInAllPlatformsInterface] that uses method
/// channels.
class MethodChannelGoogleSignInAllPlatforms
    extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.dart.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms');

  @override
  Future<GoogleSignInCredentials?> lightweightSignInImpl() {
    // TODO(vishnuagbly): implement lightweightSignIn
    throw UnimplementedError();
  }

  @override
  Future<GoogleSignInCredentials?> signInOnlineImpl() {
    // TODO(vishnuagbly): implement signInOnline
    throw UnimplementedError();
  }

  @override
  Future<void> signOutImpl() {
    // TODO(vishnuagbly): implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Client?> getAuthenticatedClient() {
    // TODO(vishnuagbly): implement getAuthenticatedClient
    throw UnimplementedError();
  }

  @override
  Widget? signInButtonImpl({GSIAPButtonConfig? config}) {
    // TODO: implement signInButton
    throw UnimplementedError();
  }
}
