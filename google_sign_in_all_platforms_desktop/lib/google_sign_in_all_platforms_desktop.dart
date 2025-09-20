import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_desktop/src/strategy.dart';
import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// The Desktop implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsDesktop
    extends GoogleSignInAllPlatformsInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('google_sign_in_all_platforms_desktop');

  /// Registers this class as the default instance of
  /// [GoogleSignInAllPlatformsInterface]
  static void registerWith() {
    GoogleSignInAllPlatformsInterface.instance =
        GoogleSignInAllPlatformsDesktop();
  }

  @override
  Future<GoogleSignInCredentials?> lightweightSignInImpl() async {
    final creds = await silentSignIn();
    if (creds == null) return null;

    return credentials!;
  }

  @override
  Future<GoogleSignInCredentials?> signInOnlineImpl() {
    return SignInStrategy.from(this).signInOnline();
  }
}
