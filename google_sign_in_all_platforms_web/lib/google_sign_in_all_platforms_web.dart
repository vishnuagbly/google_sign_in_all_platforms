
import 'google_sign_in_all_platforms_web_platform_interface.dart';

class GoogleSignInAllPlatformsWeb {
  Future<String?> getPlatformVersion() {
    return GoogleSignInAllPlatformsWebPlatform.instance.getPlatformVersion();
  }
}
