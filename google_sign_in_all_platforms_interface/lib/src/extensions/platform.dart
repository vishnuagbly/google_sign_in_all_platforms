import 'dart:io';

///Whether the current [Platform] is a desktop or not.
bool get isDesktop =>
    Platform.isMacOS || Platform.isLinux || Platform.isWindows;

///Whether the current [Platform] is a mobile or not.
bool get isMobile => Platform.isIOS || Platform.isWindows;
