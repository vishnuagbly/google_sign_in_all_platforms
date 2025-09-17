## 2.0.0

### BREAKING CHANGES
- Updated interface to 0.2.0 with new platform implementation methods
- Deprecated `signInOffline()` in favor of `lightweightSignIn()`

### Added
- `authenticationState` broadcast stream for authentication state changes
- `silentSignIn()` method for credential restoration from storage
- `authenticatedClient` getter, returning Authenticated HTTP Client, after automatic token validation and refresh
- Enhanced `GoogleSignInCredentials` with `expiresIn` field and immutability
- Automatic credential persistence and state management
- Web sign-in button support via `signInButton()` method

### Changed
- `signIn()` now tries `lightweightSignIn()`, finally `signInOnline()` for all platforms.
- Example app demonstrates authentication state handling and googleapis integration.
- Updated to support `google_sign_in: 7.x.x`.

### Dependencies
- Added `googleapis: ^14.0.0` and `googleapis_auth: ^2.0.0` to interface.

## 1.2.1
Added Instructions to obtain Credentials in README.

## 1.2.0
Removed the assert no longer necessary assert, for client id to be "NOT null" in case of android platform.

## 1.1.1
Added Instructions to obtain Credentials in README.

## 1.1.0

Added a new customPostAuthPage parameter to GoogleSignInParams, to allow for a custom page to be
shown after the user has signed in.

## 1.0.2

Updated README to be include installation guide of "google_sign_in" and "url_launcher" as well.

## 1.0.1

Updated README to be more detailed.

## 1.0.0

Fixed issues with all platforms, now working with every platform (Except Linux), in example app.

## 0.0.4

Added asserts to [GoogleSignIn] class, for platform specific params requirements.

## 0.0.3

Added new method [signIn], which executes [signInOffline] first, then executes [signInOnline].

## 0.0.2

Removed [google_sign_in_all_platforms_macos] and instead
added [google_sign_in_all_platforms_desktop]

## 0.0.1+1

Updated README, added Configuration Instructions.

## 0.0.1

Added [GoogleSignIn] class.