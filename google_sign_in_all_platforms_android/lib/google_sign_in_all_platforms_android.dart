import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

/// The Android implementation of [GoogleSignInAllPlatformsPlatform].
class GoogleSignInAllPlatformsAndroid extends GoogleSignInAllPlatformsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms_android');

  /// Registers this class as the default instance of [GoogleSignInAllPlatformsPlatform]
  static void registerWith() {
    GoogleSignInAllPlatformsPlatform.instance = GoogleSignInAllPlatformsAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
