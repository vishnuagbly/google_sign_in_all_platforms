import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

/// The MacOS implementation of [GoogleSignInAllPlatformsPlatform].
class GoogleSignInAllPlatformsMacOS extends GoogleSignInAllPlatformsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms_macos');

  /// Registers this class as the default instance of [GoogleSignInAllPlatformsPlatform]
  static void registerWith() {
    GoogleSignInAllPlatformsPlatform.instance = GoogleSignInAllPlatformsMacOS();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
