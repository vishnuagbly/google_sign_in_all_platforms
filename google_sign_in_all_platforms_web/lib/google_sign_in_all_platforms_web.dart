import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_all_platforms_mobile/google_sign_in_all_platforms_mobile.dart';
import 'package:google_sign_in_all_platforms_web/utils/gsi_button_configuration.dart';
import 'package:google_sign_in_web/web_only.dart' as web_only;
import 'package:http/http.dart';

export 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';

/// The Web implementation of [GoogleSignInAllPlatformsInterface].
class GoogleSignInAllPlatformsWeb extends GoogleSignInAllPlatformsMobile {
  @visibleForTesting
  @override
  get methodChannel => const MethodChannel('google_sign_in_all_platforms_web');

  static void registerWith(Registrar registrar) {
    GoogleSignInAllPlatformsInterface.instance = GoogleSignInAllPlatformsWeb();
  }

  Future<void>? _initFuture;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;

  void Function(GoogleSignInCredentials)? onSignIn;
  void Function()? onSignOut;

  @override
  void init(GoogleSignInParams params) {
    // Web ignores serverClientId; use clientId only.
    _initFuture ??= googleSignIn.initialize(clientId: params.clientId);

    // Listen for sign-in/out events; this is how web reports auth changes.
    _authSub ??= googleSignIn.authenticationEvents.listen((evt) {
      if (evt is GoogleSignInAuthenticationEventSignIn) {
        genCreds(evt.user).then((creds) {
          if (creds != null) {
            onSignIn?.call(creds);
          }
        });
      } else {
        clientAuth = null;
        onSignOut?.call();
      }
    });

    super.initRaw(params);
  }

  /// Place this widget in your login UI on Web.
  /// This is the ONLY supported way to start GIS auth on web.
  /// Example: `child: platform.signInButton(configuration: web_only.GSIButtonConfiguration(...))`
  @override
  Widget signInButtonImpl({GSIAPButtonConfig? config}) {
    final uiConfig = config?.uiConfig;
    onSignIn = config?.onSignIn;
    onSignOut = config?.onSignOut;

    return web_only.renderButton(
      configuration:
          (uiConfig != null)
              ? GSIAPButtonConfigUtils.fromGSIAP(uiConfig)
              : null,
    );
  }

  @override
  Future<Client?> getAuthenticatedClient() {
    return super.interfaceGetAuthenticatedClient();
  }

  @override
  Future<GoogleSignInCredentials?> signIn() {
    throw UnimplementedError(
      'Use the signInButton() widget to trigger sign-in on web.',
    );
  }

  @override
  Future<GoogleSignInCredentials?> signInOnlineImpl() {
    throw UnimplementedError(
      'Use the signInButton() widget to trigger sign-in on web.',
    );
  }
}
