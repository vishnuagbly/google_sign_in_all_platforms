# Google Sign In All Platforms

[![pub package](https://img.shields.io/pub/v/google_sign_in_all_platforms.svg)](https://pub.dev/packages/google_sign_in_all_platforms)

A Flutter plugin for Google Sign-In across all platforms including Mobile, Web, and Desktop. This package leverages the [google_sign_in](https://pub.dev/packages/google_sign_in) package for Mobile and Web Platforms, and [url_launcher](https://pub.dev/packages/url_launcher) for all platforms.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [GoogleSignInParams](#googlesigninparams)
- [GoogleSignIn](#googlesignin)
- [Feedback](#feedback)

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  google_sign_in_all_platforms: ^1.0.0
  google_sign_in: ^5.0.7
  url_launcher: ^6.0.20
```

Then run:

```sh
flutter pub get
```

## Usage

A simple usage example is as follows:

```dart
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInDemo(),
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      params: GoogleSignInParams(
        clientId: 'YOUR_CLIENT_ID',
        clientSecret: 'YOUR_CLIENT_SECRET',
        redirectPort: 3000,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign-In Demo')),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final credentials = await _googleSignIn.signIn();
                if (credentials != null) {
                  print('Signed in successfully: ${credentials.accessToken}');
                } else {
                  print('Sign in failed');
                }
              },
              child: const Text('Sign In'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
```

## GoogleSignInParams

This class contains all the parameters that might be needed for performing the Google sign-in operation.

### Parameters

- `timeout`: The total time to wait for the user to log in on Desktop platforms. Default is 1 minute.
- `saveAccessToken`: A function to save the access token locally on Desktop platforms.
- `retrieveAccessToken`: A function to retrieve the stored access token on Desktop platforms.
- `deleteAccessToken`: A function to delete the stored access token on Desktop platforms.
- `scopes`: A list of OAuth2.0 scopes. Default includes `userinfo.profile` and `userinfo.email`.
- `redirectPort`: The localhost port for receiving the access code on Desktop platforms. Default is 8000.
- `clientId`: The Google Project Client ID, required for Desktop platforms.
- `clientSecret`: The Google Project Client Secret, required for Desktop platforms.

### Example

```dart
GoogleSignInParams params = GoogleSignInParams(
  timeout: Duration(minutes: 2),
  saveAccessToken: (token) async {
    // Custom save logic
  },
  retrieveAccessToken: () async {
    // Custom retrieve logic
    return 'stored_token';
  },
  deleteAccessToken: () async {
    // Custom delete logic
  },
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

## GoogleSignIn

This class is used to perform all types of Google OAuth operations.

### Constructor

- `GoogleSignIn({GoogleSignInParams params = const GoogleSignInParams()})`: Initializes the GoogleSignIn instance with the provided parameters.

### Methods

- `Future<GoogleSignInCredentials?> signIn()`: Executes `signInOffline` first, and if unsuccessful, executes `signInOnline`.
- `Future<GoogleSignInCredentials?> signInOffline()`: Performs sign-in using the token stored in internal storage. Falls back to online sign-in on mobile devices if offline sign-in fails.
- `Future<GoogleSignInCredentials?> signInOnline()`: Performs online sign-in for all platforms.
- `Future<http.Client?> get authenticatedClient`: Returns the authenticated HTTP client. Should be called after the user is signed in.
- `Future<void> signOut()`: Performs the sign-out operation and deletes the stored token.

### Example

```dart
GoogleSignIn googleSignIn = GoogleSignIn(
  params: GoogleSignInParams(
    clientId: 'YOUR_CLIENT_ID',
    clientSecret: 'YOUR_CLIENT_SECRET',
    redirectPort: 3000,
  ),
);

Future<void> performSignIn() async {
  final credentials = await googleSignIn.signIn();
  if (credentials != null) {
    print('Signed in successfully: ${credentials.accessToken}');
  } else {
    print('Sign in failed');
  }
}

Future<void> performSignOut() async {
  await googleSignIn.signOut();
  print('Signed out successfully');
}
```

## Feedback

We welcome feedback and contributions to this project. You can provide feedback in the following ways:

- **GitHub Issues**: Report issues or suggest features on our [GitHub Issues page](https://github.com/vishnuworld/google_sign_in_all_platforms/issues).
- **Email**: Send your feedback or queries to [vishnuagbly@gmail.com](mailto:vishnuagbly@gmail.com).

Thank you for using Google Sign In All Platforms!