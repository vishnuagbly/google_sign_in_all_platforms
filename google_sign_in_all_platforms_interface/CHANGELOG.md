## 0.2.1

### Added
- Platform Implementers Migration guidelines in README with comprehensive implementation guidance
- Detailed migration checklist for custom platform implementations
- Code examples showing old vs new implementation patterns

## 0.2.0

### BREAKING CHANGES
- **For Platform Implementers**: New abstract methods that must be implemented
  - `lightweightSignInImpl()` - Platform-specific lightweight authentication implementation
  - `signInOnlineImpl()` - Platform-specific online authentication implementation
  - `signInButtonImpl()` - Platform-specific sign-in button implementation
  - `signOutImpl()` - Platform-specific sign-out implementation
- **For End Users**: `signInOffline()` deprecated in favor of `lightweightSignIn()`
  - `lightweightSignIn` will use official recommended method for signing-in previously signed-in 
  user

### Added
- `authenticationState` broadcast stream - Emits `GoogleSignInCredentials?` on auth state changes (RECOMMENDED - for tracking auth state)
- `silentSignIn()` method - Restores authentication from stored credentials. Though works 
on all platforms, NOT officially recommended for mobile and web.
- Enhanced `GoogleSignInCredentials` class:
  - Added `expiresIn` field for token expiration tracking
  - Made class `@immutable` with equality operators
  - Added `copyWith()` method
- Updated `getAuthenticatedClient()` implementation:
  - Automatic token validation via Google OAuth2 API
  - Token refresh when refresh tokens available
  - Auto sign-out on authentication failures
- Automatic credential persistence to local storage, i.e will always automatically use 
`saveAccessToken`, `retrieveAccessToken` and `deleteAccessToken` methods.

### Changed
- `signIn()` now tries `lightweightSignIn()` first, falls back to `signInOnline()`, for 
all platforms.
- All authentication methods now automatically update authentication state
- Refactored to implementation pattern (`@nonVirtual` public methods, `@protected` impl methods)

### New Dependencies
- Added `googleapis: ^14.0.0`
- Added `googleapis_auth: ^2.0.0`

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
