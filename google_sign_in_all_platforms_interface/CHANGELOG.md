## 0.1.0

### BREAKING CHANGES
- Earlier `signIn` would only do `signInOffline` for mobile, since, both were same, for mobile, 
though now, added explicit check to call `signInOnline` in case of null from offline method.

### Enhancements
- **Web Platform Support**: Added comprehensive web platform support with Google Sign-In button integration
- **GSIAPButtonConfig**: Introduced new `GSIAPButtonConfig` class for configuring Google Sign-In buttons on web platforms
- **signInButton Method**: Added `signInButton()` method to the interface for web platform button rendering

## 0.0.6

Added [GoogleSignInParams.customPostAuthPage] to allow custom page after successful sign in.

## 0.0.5

Removed asserts from [GoogleSignInParams] and made it 'const' again.

## 0.0.4

[DON'T USE] Made the [GoogleSignInParams] non 'const', causing a breaking change.
Exposed new global getters [isDesktop] and [isMobile].
Added asserts in [GoogleSignInParams] for different platforms.

## 0.0.3

Added new method called [signIn], which will first try [signInOffline] then [signInOnline].

## 0.0.2

Updated default values of [GoogleSignInParams.scopes], removed drive scope.

## 0.0.1

Provides mainly 3 classes, [GoogleSignInAllPlatformsInterface], [GoogleSignInParams] and
[GoogleSignInCredentials].
