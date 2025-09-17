# Google Sign-In All Platforms

**The only Flutter Google Sign-In solution that works on ALL platforms (including Windows/Linux) while preserving your users' existing browser sessions.**

On Windows and Linux, this package leverages your users' default browser with their already signed-in Google accounts - providing the smoothest authentication experience possible. On other platforms (Android, iOS, Web, macOS), it uses the official google_sign_in package.

[![pub package](https://img.shields.io/pub/v/google_sign_in_all_platforms.svg)](https://pub.dev/packages/google_sign_in_all_platforms)
[![pub points](https://img.shields.io/pub/points/google_sign_in_all_platforms)](https://pub.dev/packages/google_sign_in_all_platforms/score)
[![Platform Support](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-blue.svg)](https://pub.dev/packages/google_sign_in_all_platforms)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Cross-Platform Demo

<table>
<tr>
<td align="center"><strong>Windows Desktop</strong><br/>Native browser integration</td>
<td align="center"><strong>Android Mobile</strong><br/>Official google_sign_in package</td>
</tr>
<tr>
<td align="center">
<img src="https://raw.githubusercontent.com/vishnuagbly/google_sign_in_all_platforms/main/Windows-Example-small_10s.webp" width="500" alt="Windows Desktop Demo"/>
</td>
<td align="center">
<img src="https://raw.githubusercontent.com/vishnuagbly/google_sign_in_all_platforms/main/Android-Example_10s.webp" width="126" alt="Android Mobile Demo"/>
</td>
</tr>
</table>

*Same Google Sign-In experience across all platforms - with your existing browser sessions preserved on desktop!*

> **📢 Upgrading from v1.x.x?** Jump directly to the **[Migration Guide](#migration-guide)** for upgrade instructions and breaking changes.

## Table of Contents

- [Cross-Platform Demo](#cross-platform-demo)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
  - [Platform Setup](#platform-setup)
  - [How to Get Google OAuth Credentials](#how-to-get-google-oauth-credentials)
  - [Client Secret Requirements](#client-secret-requirements)
  - [Authentication Methods](#authentication-methods)
    - [signIn() - Primary Method](#signin---primary-method)
    - [silentSignIn() - Seamless Authentication](#silentsignin---seamless-authentication)
    - [lightweightSignIn() - Minimal Interaction](#lightweightsignin---minimal-interaction)
    - [signInOnline() - Full Authentication Flow](#signinonline---full-authentication-flow)
  - [Authentication State Management](#authentication-state-management)
    - [Reactive State Streams](#reactive-state-streams)
    - [Automatic Credential Persistence](#automatic-credential-persistence)
    - [StreamBuilder Integration](#streambuilder-integration)
  - [Platform-Specific Behavior](#platform-specific-behavior)
    - [Desktop Platforms (Windows/Linux)](#desktop-platforms-windowslinux)
    - [Mobile Platforms (Android/iOS)](#mobile-platforms-androidios)
    - [Web Platform](#web-platform)
  - [Advanced Features](#advanced-features)
    - [Authenticated HTTP Client](#authenticated-http-client)
    - [Token Management](#token-management)
    - [Error Recovery](#error-recovery)
    - [Web Sign-In Button](#web-sign-in-button)
  - [Best Practices](#best-practices)
    - [Recommended Authentication Flows](#recommended-authentication-flows)
    - [UX Considerations](#ux-considerations)
    - [Error Handling Strategies](#error-handling-strategies)
  - [API Reference](#api-reference)
    - [GoogleSignInParams](#googlesigninparams)
    - [GoogleSignIn](#googlesignin)
    - [GoogleSignInCredentials](#googlesignincredentials)
  - [Migration Guide](#migration-guide)
    - [Migrating from v1.x.x to v2.0.0](#migrating-from-v1xx-to-v200)
    - [For Existing App Developers](#for-existing-app-developers)
    - [For Web Developers](#for-web-developers)
    - [Adopt New Features (Optional)](#adopt-new-features-optional)
    - [For Platform Implementers (Advanced)](#for-platform-implementers-advanced)
    - [Migration Timeline](#migration-timeline)
    - [Quick Migration Checklist](#quick-migration-checklist)
- [Feedback](#feedback)

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  google_sign_in_all_platforms: ^2.0.0
```

Then run:

```sh
flutter pub get
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

class SignInDemo extends StatelessWidget {
  final googleSignIn = GoogleSignIn(
    // See 'How to Get Google OAuth Credentials' section below
    params: const GoogleSignInParams(
      clientId: 'your-client-id.apps.googleusercontent.com',
      clientSecret: 'your-client-secret', // Don't worry - not truly a secret! See 'Client Secret Requirements'
      scopes: ['openid', 'profile', 'email'],
    ),
  );

  @override
  void initState() {
    googleSignIn.silentSignIn(); // OPTIONAL
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In Demo')),
      body: Center(
        // Reactive authentication state
        child: StreamBuilder<GoogleSignInCredentials?>(
          stream: googleSignIn.authenticationState,
          builder: (context, snapshot) {
            final credentials = snapshot.data;
            final isSignedIn = credentials != null;

            return Center(
              child: ElevatedButton(
                onPressed: isSignedIn ? googleSignIn.signOut : googleSignIn.signIn,
                child: Text(isSignedIn ? 'Sign Out' : 'Sign In'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## Documentation

### Platform Setup

For platform-specific configuration (Android, iOS, Web, macOS), this package uses the official `google_sign_in` package under the hood. Please refer to the **[google_sign_in platform setup documentation](https://pub.dev/packages/google_sign_in#platform-integration)** for detailed setup instructions.

For desktop platforms (Windows/Linux), you only need to ensure your Google OAuth credentials include the correct redirect URI as described in the [How to Get Google OAuth Credentials](#how-to-get-google-oauth-credentials) section.

### How to Get Google OAuth Credentials

To use Google OAuth in your application, you need to create OAuth 2.0 credentials (Client ID and
Client Secret) from the Google Cloud Console. Follow these steps:

1. **Go to the Google Cloud Console**
   Open [https://console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials)
   and sign in with your Google account.

2. **Set up the OAuth Consent Screen**
   Before creating credentials, you must configure the OAuth consent screen:

- Select your project (or create a new one, if not already created for your app).
- Navigate to **"OAuth consent screen"** in the sidebar.
- Choose **"External"** for user type (recommended for most cases).
- Fill in the required information (App name, user support email, etc.).
- Save and continue through the steps until the setup is complete.

3. **Create OAuth 2.0 Credentials**

- Go to **"Credentials"** in the sidebar.
- Click **"Create Credentials"** → **"OAuth client ID"**.
- Choose **"Web application"** as the application type.
- You can leave **"Authorized JavaScript origins"** empty.
- Under **"Authorized redirect URIs"**, add:

  ```
  http://localhost:<redirectPort>
  ```

  By default, `<redirectPort>` is `8000`, so the URI would typically be:

  ```
  http://localhost:8000
  ```

4. **Copy the Client ID and Client Secret**
   After creation, you'll receive your **Client ID** and **Client Secret**. Use these in your
   application's configuration as required.

### Client Secret Requirements

> **⚠️ Important:** Client secrets are **ONLY required for desktop applications** (Windows, Linux, macOS) and are **optional** for mobile (Android/iOS) and web platforms. If included on any platform, they should be treated as public information.

#### Platform-Specific Requirements

| Platform | Client Secret Required | Recommendation |
|----------|----------------------|----------------|
| **Desktop** (Windows/Linux/macOS) | ✅ **Required** | Include directly, but treat as public |
| **Mobile** (Android/iOS) | ❌ **Optional** | Can be excluded (not truly secret anyway) |
| **Web** | ❌ **Optional** | Can be excluded (not truly secret anyway) |

#### Why This Matters

**The Core Issue:**
Many developers assume client secrets must be kept confidential, but for public applications (mobile/desktop apps distributed to users), this is impossible and unnecessary.

**Google's Official Position:**
> "We don't expect those secrets to stay secret—so far we're including them mostly so it's convenient to use with libraries today, and expect to stop requiring them at some point in the future."  
> *— Andrew (Google OAuth2 Team)* | [Source](https://groups.google.com/g/oauth2-dev/c/HnFJJOvMfmA)

#### Recommendations by Platform

##### ✅ Desktop Applications (Windows/Linux/macOS)
**What to do:**
- Include the client secret directly in your application
- Understand that users can inspect and discover this secret
- This is acceptable and expected for public desktop applications

**Security reality:**
- Client secrets in desktop apps are essentially "public"
- They serve mainly for identification, not true authentication
- [RFC 8252 Section 8.5](https://datatracker.ietf.org/doc/html/rfc8252#section-8.5) confirms this approach

##### ❌ Mobile & Web Applications (Android/iOS/Web)
**What to do:**
- Client secrets can be chosen to **NOT be included** in mobile APKs/bundles or web applications
- Both platforms officially support Google Sign-In without client secrets
- If you do include them, understand they are not considered actual secrets (as per Google's position above)

#### Alternative Secure Approaches

If you need enhanced security for production applications:

- Store client secrets in secure environment variables
- Use encrypted configuration files
- Implement runtime secret injection
- Use cloud secret management services (AWS Secrets Manager, etc.)

**Benefits:**
- Secrets not hardcoded in source control
- Different secrets per environment (dev/staging/prod)
- Audit trails for secret access

#### Quick Decision Guide

**"Should I include a client secret?"**

- 🖥️ **Desktop app?** → Yes, include it (required, but users can see it anyway)
- 📱 **Mobile app?** → Optional, can exclude it (not truly secret & not required)
- 🌐 **Web app?** → Optional, can exclude it (not truly secret & not required)
- 🔒 **Need maximum security?** → Consider server-side proxy

---

*Special thanks to [@allComputableThings](https://github.com/vishnuagbly/google_sign_in_all_platforms/issues/12) for raising this important question, and [@tnc1997](https://github.com/vishnuagbly/google_sign_in_all_platforms/issues/12#issuecomment-2571699134) for providing detailed research and technical insights that informed this clarification.*

*Technical References: [RFC 8252](https://datatracker.ietf.org/doc/html/rfc8252#section-8.5) | [Google OAuth2 Discussion](https://groups.google.com/g/oauth2-dev/c/HnFJJOvMfmA) | [Flutter Google Sign-In Desktop](https://github.com/tnc1997/flutter-google-sign-in-desktop)*

### Authentication Methods

This package provides four different authentication methods, each designed for specific use cases and user experiences. Understanding when to use each method is crucial for implementing the optimal authentication flow for your application.

#### signIn() - Primary Method

The `signIn()` method is the **recommended starting point** for most applications. It implements an intelligent fallback strategy that provides the best user experience across all platforms.

```dart
final credentials = await googleSignIn.signIn();
if (credentials != null) {
  // User successfully signed in
  print('Welcome ${credentials.accessToken}');
}
```

**How it works:**
1. First attempts `lightweightSignIn()` (minimal user interaction)
2. If that fails, falls back to `signInOnline()` (full authentication flow)

**When to use:**
- ✅ **First-time implementation** - Great default choice
- ✅ **General purpose apps** - Handles most scenarios automatically  
- ✅ **Backward compatibility** - Same API as v1.x.x

#### silentSignIn() - Seamless Authentication

The `silentSignIn()` method provides **zero-interaction authentication** by using stored credentials from previous sign-ins.

```dart
@override
void initState() {
  // Recommended: Try silent sign-in on app startup
  googleSignIn.silentSignIn();
  super.initState();
}
```

**How it works:**
- Retrieves and validates previously stored credentials
- No user interaction required
- Works on all platforms

**When to use:**
- ✅ **App startup** - Restore user sessions automatically
- ✅ **Desktop applications** - Persistent authentication across app restarts
- ✅ **Seamless UX** - No popups or user interruption

**Example from the demo app:**
```dart
// From example/lib/main.dart - line 43
_googleSignIn.silentSignIn(); // Called in initState()
```

#### lightweightSignIn() - Minimal Interaction

The `lightweightSignIn()` method uses the **official Google recommended approach** for quick re-authentication with minimal user interaction.

```dart
final credentials = await googleSignIn.lightweightSignIn();
```

**Platform behavior:**
- **Mobile/Web**: Shows 1-2 tap popup using `attemptLightweightAuthentication()`
- **Desktop**: Falls back to `silentSignIn()` (no official lightweight method exists)

**When to use:**
- ✅ **Re-authentication** - When tokens expire but user was recently signed in
- ✅ **Minimal disruption** - Quick popups instead of full OAuth flows
- ✅ **Official compliance** - Uses Google's officially recommended methods

#### signInOnline() - Full Authentication Flow

The `signInOnline()` method performs the **complete OAuth authentication flow**, suitable for new users or when other methods fail.

```dart
final credentials = await googleSignIn.signInOnline();
```

**How it works:**
- Full OAuth 2.0 flow with complete Google consent screens
- Works reliably for new users
- Handles complex permission scenarios

**When to use:**
- ✅ **New users** - First-time authentication
- ✅ **Permission changes** - When app requires new scopes
- ✅ **Fallback method** - When lightweight methods fail

### Authentication State Management

v2.0.0 introduces **reactive authentication state management** that automatically keeps your UI synchronized with the current authentication status.

#### Reactive State Streams

The `authenticationState` stream broadcasts credential changes in real-time:

```dart
Stream<GoogleSignInCredentials?> get authenticationState
```

**Usage with StreamBuilder:**
```dart
StreamBuilder<GoogleSignInCredentials?>(
  stream: googleSignIn.authenticationState,
  builder: (context, snapshot) {
    final isSignedIn = snapshot.data != null;
    
    if (isSignedIn) {
      return AuthenticatedView();
    }
    return SignInView();
  },
)
```

### Platform-Specific Behavior

Each platform has unique characteristics and optimal authentication patterns. Understanding these differences helps you implement platform-appropriate user experiences.

#### Platform Behavior Matrix

| Method | Desktop (Windows/Linux/MacOS) | Mobile (Android/iOS) | Web | UX Pattern |
|--------|------------------------|----------------------|-----|------------|
| `silentSignIn()` | ✅ **Recommended** - Token refresh from storage | ✅ Cache restore | ✅ Cache restore | Zero interaction |
| `lightweightSignIn()` | ⚠️ Falls back to `silentSignIn()` | ✅ **Official** - 1-2 tap popup | ✅ **Official** - 1-2 tap popup | Minimal interaction |
| `signInOnline()` | ✅ Full OAuth flow in browser | ✅ Full authentication | ❌ **Not available** - Use `signInButton()` | Full interaction |
| `signIn()` | ✅ `lightweightSignIn()` → `signInOnline()` | ✅ `lightweightSignIn()` → `signInOnline()` | ❌ **Not available** - Use `signInButton()` | Intelligent fallback |
| `signInButton()` | ❌ Returns `null` | ❌ Returns `null` | ✅ **Required** - Only way to authenticate | Native Google UI |

**Legend:**
- ✅ **Fully supported and recommended**
- ⚠️ **Supported with platform adaptations** 
- ❌ **Not available on this platform**

#### Desktop Platforms (Windows/Linux)

Desktop platforms use **custom OAuth 2.0 flows** through the default browser, providing the smoothest experience by leveraging existing browser sessions.

**Unique characteristics:**
- ✅ **Browser integration**: Uses your default browser with existing Google sessions
- ✅ **Persistent sessions**: `silentSignIn()` works reliably across app restarts
- ✅ **No additional setup**: No platform-specific configuration required

**Authentication method behavior:**
- `lightweightSignIn()` → Falls back to `silentSignIn()` (no lightweight equivalent)
- `silentSignIn()` → **Recommended primary method** for desktop
- `signInOnline()` → Full OAuth flow in browser

**Example desktop-optimized flow:**
```dart
// Recommended pattern for desktop apps
final credentials = await googleSignIn.silentSignIn() ?? 
                   await googleSignIn.signInOnline();
```

#### Mobile Platforms (Android/iOS)

Mobile platforms use the **official google_sign_in package v7.x.x** with Google's latest authentication APIs.

**Unique characteristics:**
- ✅ **Official integration**: Uses `attemptLightweightAuthentication()` and `authenticate()`
- ✅ **System integration**: Leverages device Google accounts
- ✅ **Optimized performance**: Mobile-specific credential handling

**Authentication method behavior:**
- `lightweightSignIn()` → Shows 1-2 tap popup (`attemptLightweightAuthentication()`)
- `silentSignIn()` → Restores from cache (works but not officially recommended)
- `signInOnline()` → Full authentication with system accounts

#### Web Platform

Web platform provides **native Google Sign-In button integration** and requires a different approach than other platforms.

**Critical difference:**
- ❌ **Cannot call `signIn()` directly** - Must use `signInButton()` widget
- ✅ **Native Google buttons** - Official Google Sign-In UI components
- ✅ **Event-driven authentication** - Listens to authentication events

**Required usage pattern:**
```dart
// ❌ Will throw UnimplementedError on web
await googleSignIn.signIn();

// ✅ Correct web approach
if (kIsWeb) {
  // Use the sign-in button widget
  googleSignIn.signInButton()
} else {
  // Use programmatic sign-in on other platforms
  ElevatedButton(
    onPressed: googleSignIn.signIn,
    child: Text('Sign In'),
  )
}
```

**From the example app:**
```dart
// example/lib/main.dart - lines 75-81
if (kIsWeb)
  _googleSignIn.signInButton() ?? const SizedBox.shrink()
else
  ElevatedButton(
    onPressed: _googleSignIn.signIn,
    child: const Text('Sign In'),
  ),
```

### Advanced Features

#### Authenticated HTTP Client

The `authenticatedClient` getter provides a **ready-to-use HTTP client** for Google APIs with automatic token management.

```dart
// Property-style access (not a method call)
final client = await googleSignIn.authenticatedClient;

if (client != null) {
  // Use with any Google API
  final peopleApi = PeopleServiceApi(client);
  final person = await peopleApi.people.get('people/me');
}
```

**Automatic features:**
- ✅ **Token validation**: Checks expiration before each use
- ✅ **Auto-refresh**: Uses refresh tokens when available
- ✅ **Error recovery**: Auto sign-out on unrecoverable failures

**Example from the demo app:**
```dart
// example/lib/main.dart - lines 92-106
Future<people.Person> _fetchPerson() async {
  final authClient = await _googleSignIn.authenticatedClient;
  
  if (authClient == null) {
    throw Exception('Failed to get authenticated client');
  }
  
  final peopleApi = people.PeopleServiceApi(authClient);
  return await peopleApi.people.get('people/me');
}
```

#### Token Management

v2.0.0 includes **enterprise-grade token management** with automatic validation, expiration handling, and refresh capabilities.

**Enhanced credentials with expiration tracking:**
```dart
class GoogleSignInCredentials {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresIn; // ← NEW in v2.0.0
  
  // Immutable updates
  GoogleSignInCredentials copyWith({DateTime? expiresIn}) { /* ... */ }
}
```

#### Error Recovery

The package implements **graceful error recovery** that prevents authentication failures from breaking your app.

**Automatic cleanup strategy:**
```dart
Future<Client?> getAuthenticatedClient() async {
  final client = await _getAuthenticatedClient();
  if (client == null) {
    await signOut(); // ← Automatic cleanup on failure
  }
  return client;
}
```

#### Web Sign-In Button

The web platform provides native Google Sign-In button integration with full customization support.

**Basic usage:**
```dart
// Returns null on non-web platforms
final button = googleSignIn.signInButton();
```

### Best Practices

#### Recommended Authentication Flows

**For Simple Apps (Recommended Default):**
```dart
// Use the intelligent fallback strategy
final credentials = await googleSignIn.signIn();
```

**For Advanced Apps (Maximum UX):**
```dart
Future<GoogleSignInCredentials?> seamlessAuthentication() async {
  // 1. Try silent first (no user interaction)
  final silentCreds = await googleSignIn.silentSignIn();
  if (silentCreds != null) return silentCreds;
  
  // 2. Try lightweight (minimal interaction)
  final lightCreds = await googleSignIn.lightweightSignIn();  
  if (lightCreds != null) return lightCreds;
  
  // 3. Fallback to full flow (complete OAuth)
  return await googleSignIn.signInOnline();
}
```

**For App Startup (Restore Sessions):**
```dart
@override
void initState() {
  // Restore user sessions without interruption
  googleSignIn.silentSignIn();
  super.initState();
}
```

#### UX Considerations
**Platform-Specific UI Patterns:**
```dart
Widget buildSignInButton() {
  if (kIsWeb) {
    // Web requires the sign-in button widget
    return googleSignIn.signInButton() ?? SizedBox.shrink();
  }
  
  // Other platforms can use custom buttons
  return ElevatedButton(
    onPressed: googleSignIn.signIn,
    child: Text('Sign In with Google'),
  );
}
```

#### Error Handling Strategies

**Reactive Error Handling:**
```dart
StreamBuilder<GoogleSignInCredentials?>(
  stream: googleSignIn.authenticationState,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return ErrorView(error: snapshot.error);
    }
    
    final isSignedIn = snapshot.data != null;
    return isSignedIn ? AuthenticatedView() : SignInView();
  },
)
```

### API Reference

#### GoogleSignInParams

This class contains all the parameters that might be needed for performing the Google sign-in operation.

**Parameters:**

- `timeout`: The total time to wait for the user to log in on Desktop platforms. Default is 1 minute.
- `saveAccessToken`: A function to save the access token locally on Desktop platforms.
- `retrieveAccessToken`: A function to retrieve the stored access token on Desktop platforms.
- `deleteAccessToken`: A function to delete the stored access token on Desktop platforms.
- `scopes`: A list of OAuth2.0 scopes. Default includes `userinfo.profile` and `userinfo.email`.
- `redirectPort`: The localhost port for receiving the access code on Desktop platforms. Default is 8000.
- `clientId`: The Google Project Client ID, required for Desktop platforms.
- `clientSecret`: The Google Project Client Secret, required for Desktop platforms.

**Example:**
```dart
GoogleSignInParams params = GoogleSignInParams(
  timeout: Duration(minutes: 2),
  scopes: [
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/drive',
  ],
  redirectPort: 3000,
  clientId: 'YOUR_CLIENT_ID',
  clientSecret: 'YOUR_CLIENT_SECRET',
);
```

#### GoogleSignIn

This class is used to perform all types of Google OAuth operations.

**Constructor:**
- `GoogleSignIn({GoogleSignInParams params = const GoogleSignInParams()})`: Initializes the GoogleSignIn instance with the provided parameters.

**Properties:**
- `Stream<GoogleSignInCredentials?> get authenticationState`: Stream that emits GoogleSignInCredentials when user signs in, and null when user signs out.
- `Future<http.Client?> get authenticatedClient`: Returns the authenticated HTTP client. Should be called after the user is signed in.

**Methods:**
- `Future<GoogleSignInCredentials?> signIn()`: Executes `lightweightSignIn` first, and if unsuccessful, executes `signInOnline`.
- `Future<GoogleSignInCredentials?> silentSignIn()`: Performs silent sign-in. Recommended for desktop platforms.
- `Future<GoogleSignInCredentials?> lightweightSignIn()`: Performs sign-in using minimal user interaction (official Google method).
- `Future<GoogleSignInCredentials?> signInOnline()`: Performs online sign-in for all platforms.
- `Widget? signInButton({GSIAPButtonConfig? config})`: Returns a Sign-In Button for Web Platform only.
- `Future<void> signOut()`: Performs the sign-out operation and also deletes the stored token.

#### GoogleSignInCredentials

Object to store all necessary values regarding Google OAuth2.0 Credentials.

**Properties:**
- `String accessToken`: Google OAuth2.0 Access Token, required to create an authenticated HTTP client.
- `String? refreshToken`: Google OAuth2.0 Refresh Token, used to get a new access token when it expires.
- `List<String> scopes`: Google OAuth2.0 scopes, determine the types of services the access token can access.
- `String? tokenType`: Google OAuth2.0 token type. The most common token type is 'Bearer'.
- `String? idToken`: Google OAuth2.0 id token.
- `DateTime? expiresIn`: The date and time when the access token expires (NEW in v2.0.0).

**Methods:**
- `GoogleSignInCredentials.fromJson(Map<String, dynamic> json)`: Creates credentials from JSON.
- `Map<String, dynamic> toJson()`: Converts the credentials to JSON format.
- `GoogleSignInCredentials copyWith({...})`: Creates a copy with updated fields.

### Migration Guide

#### Migrating from v1.x.x to v2.0.0

v2.0.0 introduces powerful new features while maintaining backward compatibility where possible. The changes required depend on your specific use case.

#### For Existing App Developers

**✅ No Breaking Changes for Existing Functionality**

Your current mobile and desktop authentication code will continue to work exactly as before:

```dart
// ✅ This works the same in v2.0.0
final googleSignIn = GoogleSignIn(
  params: GoogleSignInParams(
    clientId: 'your-client-id',
    clientSecret: 'your-client-secret',
  ),
);

final credentials = await googleSignIn.signIn(); // ✅ Still works
```

**⚠️ Optional: Update Deprecated Methods**

While not required immediately, consider updating deprecated methods:

```dart
// ❌ Deprecated (still works, but will show warnings)
final credentials = await googleSignIn.signInOffline();

// ✅ Preferred new method
final credentials = await googleSignIn.lightweightSignIn();
```


#### For Web Developers

If you're adding web support to your app, note that web requires a different approach:

```dart
// ❌ Not available on web
await googleSignIn.signIn();

// ✅ Required for web
if (kIsWeb) {
  googleSignIn.signInButton() // Must use sign-in button
} else {
  ElevatedButton(
    onPressed: googleSignIn.signIn,
    child: Text('Sign In'),
  )
}
```

#### Adopt New Features (Optional)

Both app and web developers can gradually adopt these new v2.0.0 features:

```dart
// NEW: Reactive authentication state
StreamBuilder<GoogleSignInCredentials?>(
  stream: googleSignIn.authenticationState,
  builder: (context, snapshot) => /* ... */,
)

// NEW: Silent authentication on app startup
@override
void initState() {
  googleSignIn.silentSignIn(); // Restore previous sessions
  super.initState();
}
```

#### For Platform Implementers (Advanced)

**❌ Breaking Changes Required**

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

**Required changes:**
- Implement `lightweightSignInImpl()` instead of `lightweightSignIn()`
- Implement `signInOnlineImpl()` instead of `signInOnline()`  
- Implement `signOutImpl()` instead of `signOut()`
- Add `signInButtonImpl()` method (can return `null` for non-web platforms)

#### Migration Timeline

**Immediate (v2.0.0+):**
- ✅ **All existing code continues to work**
- ⚠️ **Deprecation warnings** appear for `signInOffline()`

**Recommended (within 6 months):**
- 🔄 **Update deprecated methods** to remove warnings
- 🎯 **Consider adopting** new reactive state management

**Future versions:**
- ❌ **Deprecated methods will be removed** in future major version
- 📱 **New features** will build on v2.0.0 architecture

#### Quick Migration Checklist

**For existing mobile/desktop apps:**
- [ ] Update to `google_sign_in_all_platforms: ^2.0.0`
- [ ] Run your existing code (should work without changes)
- [ ] Optionally replace `signInOffline()` with `lightweightSignIn()`
- [ ] Consider adopting `authenticationState` stream for reactive UIs

**For adding web support:**
- [ ] Use `signInButton()` widget instead of calling `signIn()` directly
- [ ] Add platform check: `if (kIsWeb) { /* use button */ }`
- [ ] Test authentication flow on web platform

**For platform implementers:**
- [ ] Update to new `*Impl()` method pattern
- [ ] Test all authentication flows on your custom platform
- [ ] Update any custom error handling to work with new state management

The migration path is designed to be **gradual and non-disruptive** - you can upgrade immediately and adopt new features at your own pace!

## Feedback

We welcome feedback and contributions to this project. You can provide feedback in the following
ways:

- **GitHub Issues**: Report issues or suggest features on
  our [GitHub Issues page](https://github.com/vishnuagbly/google_sign_in_all_platforms/issues).
- **Email**: Send your feedback or queries to [vishnuagbly@gmail.com](mailto:vishnuagbly@gmail.com).

Thank you for using Google Sign In All Platforms!
