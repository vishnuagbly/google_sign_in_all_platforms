## 0.2.0

### Added
- Added support for `google_sign_in: 7.x.x` package.
- Mobile-optimized `getAuthenticatedClient()` implementation using `extension_google_sign_in_as_googleapis_auth`
- Implementation of interface 0.2.0 abstract methods:
  - `lightweightSignInImpl()` uses `GoogleSignIn.attemptLightweightAuthentication()` - official recommended method for previously signed-in users on mobile
  - `signInOnlineImpl()` uses `GoogleSignIn.authenticate()` with scope hints  
  - `signOutImpl()` uses `GoogleSignIn.signOut()`

### Changed
- Updated dependency `google_sign_in_all_platforms_interface` to `^0.2.0`
- Inherited authentication state management and credential persistence from interface 0.2.0

## 0.1.0

### Added
- Support for google_sign_in 7.x.x versions
- Updated to use `GoogleSignIn.authenticate()` method (replaces deprecated `signIn()`)

## 0.0.2

### Added  
- Added google_sign_in_all_platforms_mobile_web.dart file

## 0.0.1

### Added
- Initial release with GoogleSignInAllMobile class
