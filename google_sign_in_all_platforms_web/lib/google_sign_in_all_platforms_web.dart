import 'package:google_sign_in_all_platforms_platform_interface/google_sign_in_all_platforms_platform_interface.dart';

/// The Web implementation of [GoogleSignInAllPlatformsPlatform].
class GoogleSignInAllPlatformsWeb extends GoogleSignInAllPlatformsPlatform {
  /// Registers this class as the default instance of [GoogleSignInAllPlatformsPlatform]
  static void registerWith([Object? registrar]) {
    GoogleSignInAllPlatformsPlatform.instance = GoogleSignInAllPlatformsWeb();
  }

  @override
  Future<String?> getPlatformName() async => 'Web';
}
