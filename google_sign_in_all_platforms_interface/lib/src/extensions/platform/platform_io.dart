import 'dart:io' show Platform;

/// Whether the app is running on the web.
bool get isWeb => false;

/// Whether the app is running on a desktop platform.
bool get isDesktop =>
    Platform.isMacOS || Platform.isLinux || Platform.isWindows;

/// Whether the app is running on a mobile platform.
bool get isMobile => Platform.isAndroid || Platform.isIOS;

/// Whether the web app is running on a desktop platform.
bool get isDesktopWeb => false;

/// Whether the web app is running on a mobile platform.
bool get isMobileWeb => false;
