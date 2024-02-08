import 'package:google_sign_in_all_platforms_interface/src/credentials.dart';
import 'package:google_sign_in_all_platforms_interface/src/extensions/platform.dart'
    as g_platform;
import 'package:google_sign_in_all_platforms_interface/src/init_params.dart';
import 'package:google_sign_in_all_platforms_interface/src/method_channel_google_sign_in_all_platforms.dart';
import 'package:http/http.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/credentials.dart';
export 'src/extensions/platform.dart';
export 'src/init_params.dart';

/// The interface that implementations of google_sign_in_all_platforms must
/// implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `GoogleSignInAllPlatforms`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform.dart implementations that
/// `implements` this interface will be broken by newly added
///  [GoogleSignInAllPlatformsInterface] methods.
abstract class GoogleSignInAllPlatformsInterface extends PlatformInterface {
  /// Constructs a GoogleSignInAllPlatformsPlatform.
  GoogleSignInAllPlatformsInterface() : super(token: _token);

  static final Object _token = Object();

  static GoogleSignInAllPlatformsInterface _instance =
      MethodChannelGoogleSignInAllPlatforms();

  /// The default instance of [GoogleSignInAllPlatformsInterface] to use.
  ///
  /// Defaults to [MethodChannelGoogleSignInAllPlatforms].
  static GoogleSignInAllPlatformsInterface get instance => _instance;

  /// Platform-specific plugins should set this with their own platform
  /// dart-specific class that extends [GoogleSignInAllPlatformsInterface] when
  /// they register themselves.
  static set instance(GoogleSignInAllPlatformsInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  GoogleSignInParams? _params;

  void _setParams(GoogleSignInParams params) {
    assert(_params == null, '__params is already not null');
    _params = params;
  }

  ///Getter for [GoogleSignInParams], required by each platform.dart interfaces.
  GoogleSignInParams get params {
    assert(_params != null, '__params is null');
    return _params!;
  }

  ///Initialize the parameters required for the plugin.
  void init(GoogleSignInParams params) => _setParams(params);

  ///This method first tries executing [signInOffline] method, if
  ///unsuccessful, then executes [signInOnline] method.
  Future<GoogleSignInCredentials?> signIn() async {
    var creds = await signInOffline();
    if (creds == null && g_platform.isDesktop) creds = await signInOnline();
    return creds;
  }

  ///Use this to sign in using the access_token from the cache or internal
  ///storage. Therefore, can also be used to check if th user is already logged
  ///in or not.
  ///
  ///For Mobile and Web devices, this is the same as signInOnline, while it
  ///firsts check for an already existing token, and if not exists then perform
  ///the sign in online.
  Future<GoogleSignInCredentials?> signInOffline();

  ///Use this to sign in using the online method, by retrieving new token from
  ///the api.
  Future<GoogleSignInCredentials?> signInOnline();

  ///Returns the authenticated http client. It should be called after the user
  ///has signed in.
  Future<Client?> getAuthenticatedClient();

  ///Use this to sign out the user, this will also remove the token stored in
  ///the local storage.
  Future<void> signOut();
}
