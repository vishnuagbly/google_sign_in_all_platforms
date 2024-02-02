# google_sign_in_all_platforms

A Basic Google Sign In package for all platforms including for Desktop.

This package provides a main class as [GoogleSignIn], Currently we have mainly 4 methods:

- signInOnline
- signInOffline
- signOut
- authenticatedClient

Documentation for each method is provided with the package only (i.e with code itself above each
method using '///' comments).

## Usage

A simple usage example is as follows:

```dart
@override
void initState() {
  _googleSignIn = GoogleSignIn(
    params: const GoogleSignInParams(
      clientId: _kClientId,
      clientSecret: _kClientSecret,
      redirectPort: 3000,
    ),
  );
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Testing Application')),
    body: Center(
      child: Column(
        children: [
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final creds = await _googleSignIn.signInOnline();
              if (creds == null) {
                debugPrint('Could not Sign in');
              } else {
                debugPrint('Signed in Successfully');
              }
            },
            child: const Text('Sign In'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              try {
                await _googleSignIn.signOut();
                debugPrint('Signed Out Successfully');
              } catch (err) {
                debugPrint('Could not Sign Out');
              }
            },
            child: const Text('Sign Out'),
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}
```
