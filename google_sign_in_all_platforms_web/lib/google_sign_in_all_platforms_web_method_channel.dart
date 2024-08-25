import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'google_sign_in_all_platforms_web_platform_interface.dart';

/// An implementation of [GoogleSignInAllPlatformsWebPlatform] that uses method channels.
class MethodChannelGoogleSignInAllPlatformsWeb extends GoogleSignInAllPlatformsWebPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('google_sign_in_all_platforms_web');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
