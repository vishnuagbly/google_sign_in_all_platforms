## 0.1.0

### Changed
- **BREAKING**: Refactored web plugin architecture to extend `GoogleSignInAllPlatformsMobile` instead of `GoogleSignInAllPlatformsInterface`

### Added
- Implementation of `getAuthenticatedClient()` method that uses interface method, instead of direct parent's method.
- Integration with mobile platform implementation for code reuse

## 0.0.2
Refactored code based on latest dart formatter and updated CHANGELOG.md

## 0.0.1

First Implementation of GoogleSignInAllPlatformsWeb, for using google_sign_in 7.x.x version.
