import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Whether the app is running on the web.
bool get isWeb => true;

/// Whether the app is running on a desktop platform.
bool get isDesktop => false;

/// Whether the app is running on a mobile platform.
bool get isMobile => false;

/// Whether the web app is running on a desktop platform.
bool get isDesktopWeb =>
    kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows);

/// Whether the web app is running on a mobile platform.
bool get isMobileWeb =>
    kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
