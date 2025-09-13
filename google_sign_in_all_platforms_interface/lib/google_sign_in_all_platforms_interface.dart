import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in_all_platforms_interface/src/credentials.dart';
import 'package:google_sign_in_all_platforms_interface/src/gsiap_button_config.dart';
import 'package:google_sign_in_all_platforms_interface/src/init_params.dart';
import 'package:google_sign_in_all_platforms_interface/src/method_channel_google_sign_in_all_platforms.dart';
import 'package:googleapis/oauth2/v2.dart' as oauth2;
import 'package:googleapis_auth/googleapis_auth.dart' as gapis;
import 'package:http/http.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/credentials.dart';
export 'src/extensions/platform/platform.dart';
export 'src/gsiap_button_config.dart';
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
  GoogleSignInAllPlatformsInterface()
      : _credsController =
            StreamController<GoogleSignInCredentials?>.broadcast(),
        super(token: _token);

  static final Object _token = Object();
  static const String _kAccessTokenCredsKey = 'access_token';
  static const String _kRefreshTokenCredsKey = 'refresh_token';
  static const String _kTokenTypeCredsKey = 'token_type';
  static const String _kScopeCredsKey = 'scope';
  static const String _kScopesSeparator = ' ';
  static const _kLogName = 'GoogleSignInAllPlatformsInterface';

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
  final StreamController<GoogleSignInCredentials?> _credsController;

  /// Holds the credentials of the currently signed in user.
  @protected
  GoogleSignInCredentials? credentials;

  /// A broadcast stream of the current [GoogleSignInCredentials], which emits
  /// the current credentials whenever they change.
  Stream<GoogleSignInCredentials?> get authenticationState =>
      _credsController.stream;

  void _updateCreds(GoogleSignInCredentials? credentials) {
    if (credentials != null) {
      params.saveAccessToken.call(jsonEncode(credentials.toJson()));
    } else {
      params.deleteAccessToken.call();
    }

    if (credentials == this.credentials) {
      return;
    }

    this.credentials = credentials;
    _credsController.add(credentials);
  }

  /// Silent Sign-In, Recommended only for Desktop
  Future<GoogleSignInCredentials?> silentSignIn() async {
    final credsJsonString = await params.retrieveAccessToken.call();
    if (credsJsonString == null) return null;

    try {
      final credsJson =
          Map<String, dynamic>.from(jsonDecode(credsJsonString) as Map);
      _updateCreds(GoogleSignInCredentials.fromJson(credsJson));
      return credentials!;
    } catch (err) {
      log('$err', name: _kLogName);
      return null;
    }
  }

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

  ///This method first tries executing [lightweightSignInImpl] method, if
  ///unsuccessful, then executes [signInOnlineImpl] method.
  Future<GoogleSignInCredentials?> signIn() async {
    return (await lightweightSignIn()) ?? await signInOnline();
  }

  /// Use this to get the sign in button widget, only for Web platform.
  @nonVirtual
  Widget? signInButton({GSIAPButtonConfig? config}) {
    final updatedConfig = GSIAPButtonConfig(
      uiConfig: config?.uiConfig,
      onSignIn: (creds) {
        _updateCreds(creds);
        config?.onSignIn?.call(creds);
      },
      onSignOut: () {
        _updateCreds(null);
        config?.onSignOut?.call();
      },
    );

    return signInButtonImpl(config: updatedConfig);
  }

  /// Implementation of [signInButton], platform specific.
  @protected
  Widget? signInButtonImpl({GSIAPButtonConfig? config}) {
    throw UnimplementedError(
      'signInButton is not implemented on this platform',
    );
  }

  ///Use this to sign in using the access_token from the cache or internal
  ///storage. Therefore, can also be used to check if th user is already logged
  ///in or not.
  ///
  ///For Mobile and Web devices, this uses the official
  ///attemptLightweightAuthentication method.
  @nonVirtual
  Future<GoogleSignInCredentials?> lightweightSignIn() async {
    final credentials = await lightweightSignInImpl();
    _updateCreds(credentials);
    return credentials;
  }

  /// Implementation of [lightweightSignIn], platform specific.
  @protected
  Future<GoogleSignInCredentials?> lightweightSignInImpl();

  ///Alias for [lightweightSignInImpl]
  @Deprecated(
      'Use lightweightSignIn instead. signInOffline will be removed in a '
      'future version.')
  @nonVirtual
  Future<GoogleSignInCredentials?> signInOffline() => lightweightSignIn();

  ///Use this to sign in using the online method, by retrieving new token from
  ///the api
  @nonVirtual
  Future<GoogleSignInCredentials?> signInOnline() async {
    final credentials = await signInOnlineImpl();
    _updateCreds(credentials);
    return credentials;
  }

  /// Implementation of [signInOnline], platform specific.
  @protected
  Future<GoogleSignInCredentials?> signInOnlineImpl();

  ///Returns the authenticated http client. It should be called after the user
  ///has signed in.
  Future<Client?> getAuthenticatedClient() async {
    final client = await _getAuthenticatedClient();
    if (client == null) {
      await signOut();
    }
    return client;
  }

  Future<Client?> _getAuthenticatedClient() async {
    final credentials = this.credentials;
    if (credentials == null) return null;

    final accessToken = credentials.accessToken;
    final expiresIn = credentials.expiresIn;
    final scopes =
        credentials.scopes.isEmpty ? params.scopes : credentials.scopes;
    final refreshToken = credentials.refreshToken;

    final accessCreds = gapis.AccessCredentials(
      gapis.AccessToken(
        credentials.tokenType ?? 'Bearer',
        accessToken,
        expiresIn ?? DateTime.now().toUtc(),
      ),
      refreshToken,
      scopes,
    );

    if (refreshToken == null) {
      final client = gapis.authenticatedClient(Client(), accessCreds);
      if (expiresIn != null) {
        if (expiresIn
            .isAfter(DateTime.now().add(const Duration(minutes: 1)).toUtc())) {
          return client;
        }
        return null;
      }

      try {
        final api = oauth2.Oauth2Api(client);
        final tokenInfo = await api.tokeninfo(
          accessToken: accessToken,
        );

        if (tokenInfo.expiresIn != null && tokenInfo.expiresIn! >= 60) {
          final updatedExpiresIn = DateTime.now()
              .add(Duration(seconds: tokenInfo.expiresIn!))
              .toUtc();
          _updateCreds(credentials.copyWith(expiresIn: updatedExpiresIn));
          return client;
        }
        return null;
      } catch (err) {
        log(
          'Error while fetching token info: $err',
          name: 'getAuthenticatedClient',
        );
        return null;
      }
    }

    if (params.clientId == null) {
      log('Client Id Should not be null', name: 'getAuthenticatedClient');
      return null;
    }

    return gapis.autoRefreshingClient(
      gapis.ClientId(params.clientId!, params.clientSecret),
      accessCreds,
      Client(),
    );
  }

  ///Use this to sign out the user, this will also remove the token stored in
  ///the local storage.
  @nonVirtual
  Future<void> signOut() async {
    await signOutImpl();
    _updateCreds(null);
  }

  /// Implementation of [signOut], platform specific.
  @protected
  Future<void> signOutImpl() async {}
}
