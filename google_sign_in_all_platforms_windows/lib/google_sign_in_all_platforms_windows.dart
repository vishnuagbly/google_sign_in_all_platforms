import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

/// The Windows implementation of [GoogleSignInAllPlatformsPlatform].
class GoogleSignInAllPlatformsWindows extends GoogleSignInAllPlatformsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms_windows');

  /// Registers this class as the default instance of [GoogleSignInAllPlatformsPlatform]
  static void registerWith() {
    GoogleSignInAllPlatformsPlatform.instance = GoogleSignInAllPlatformsWindows();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
