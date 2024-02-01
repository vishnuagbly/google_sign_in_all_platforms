import 'package:google_sign_in_all_platforms_platform_interface/src/method_channel_google_sign_in_all_platforms.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of google_sign_in_all_platforms must
/// implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `GoogleSignInAllPlatforms`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added
///  [GoogleSignInAllPlatformsPlatform] methods.
abstract class GoogleSignInAllPlatformsPlatform extends PlatformInterface {
  /// Constructs a GoogleSignInAllPlatformsPlatform.
  GoogleSignInAllPlatformsPlatform() : super(token: _token);

  static final Object _token = Object();

  static GoogleSignInAllPlatformsPlatform _instance =
      MethodChannelGoogleSignInAllPlatforms();

  /// The default instance of [GoogleSignInAllPlatformsPlatform] to use.
  ///
  /// Defaults to [MethodChannelGoogleSignInAllPlatforms].
  static GoogleSignInAllPlatformsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [GoogleSignInAllPlatformsPlatform] when they register
  /// themselves.
  static set instance(GoogleSignInAllPlatformsPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();
}
