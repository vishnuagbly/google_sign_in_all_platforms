# google_sign_in_all_platforms_interface

A common platform interface for the `google_sign_in_all_platforms` plugin.

This interface allows platform-specific implementations of the `google_sign_in_all_platforms`
plugin, as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `google_sign_in_all_platforms`,
extend `GoogleSignInAllPlatformsInterface` with an implementation that performs the
platform-specific behavior.

## For Platform Implementers Migration Guidelines

### ❌ Breaking Changes Required for v2.0.0

If you've created custom platform implementations, you must update to the new interface pattern:

```dart
// OLD: Direct method implementations
class MyCustomPlatform extends GoogleSignInAllPlatformsInterface {
  @override
  Future<GoogleSignInCredentials?> lightweightSignIn() {
    // Implementation here
  }
}

// NEW: Implementation pattern with *Impl methods
class MyCustomPlatform extends GoogleSignInAllPlatformsInterface {
  @override
  Future<GoogleSignInCredentials?> lightweightSignInImpl() {
    // Implementation here - state management handled by interface
  }
  
  @override
  Future<GoogleSignInCredentials?> signInOnlineImpl() { /* ... */ }
  
  @override
  Future<void> signOutImpl() { /* ... */ }
  
  @override
  Widget? signInButtonImpl({GSIAPButtonConfig? config}) { /* ... */ }
}
```

### Required Changes:
- Implement `lightweightSignInImpl()` instead of `lightweightSignIn()`
- Implement `signInOnlineImpl()` instead of `signInOnline()`  
- Implement `signOutImpl()` instead of `signOut()`
- Add `signInButtonImpl()` method (can return `null` for non-web platforms)

### Why the Change?

The new `*Impl` pattern allows the interface to handle:
- Automatic state management and broadcasting
- Consistent credential persistence across platforms  
- Error recovery and cleanup
- Reactive authentication state streams

Your platform implementation focuses purely on the authentication logic, while the interface handles all the cross-platform consistency and state management.

### Migration Checklist for Platform Implementers:
- [ ] Update to new `*Impl()` method pattern
- [ ] Test all authentication flows on your custom platform
- [ ] Update any custom error handling to work with new state management