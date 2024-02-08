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