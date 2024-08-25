import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'google_sign_in_all_platforms_web_method_channel.dart';

abstract class GoogleSignInAllPlatformsWebPlatform extends PlatformInterface {
  /// Constructs a GoogleSignInAllPlatformsWebPlatform.
  GoogleSignInAllPlatformsWebPlatform() : super(token: _token);

  static final Object _token = Object();

  static GoogleSignInAllPlatformsWebPlatform _instance = MethodChannelGoogleSignInAllPlatformsWeb();

  /// The default instance of [GoogleSignInAllPlatformsWebPlatform] to use.
  ///
  /// Defaults to [MethodChannelGoogleSignInAllPlatformsWeb].
  static GoogleSignInAllPlatformsWebPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GoogleSignInAllPlatformsWebPlatform] when
  /// they register themselves.
  static set instance(GoogleSignInAllPlatformsWebPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
