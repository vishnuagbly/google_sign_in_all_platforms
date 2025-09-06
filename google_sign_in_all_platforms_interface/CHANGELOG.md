## 0.1.0
Updated signIn method to try signInOnline in case of mobile platforms as well.
This is because with the latest update in google_sign_in package, we only get signInOnline option,
while signInOffline is handled on the app level.

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