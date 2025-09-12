import 'package:example/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _signedIn = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    params: const GoogleSignInParams(
      clientId: kGoogleClientId,
      clientSecret: kGoogleClientSecret,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desktop Test')),
      body: Center(
        child: kIsWeb && !_signedIn
            ? _googleSignIn.signInButton(
                config: GSIAPButtonConfig(
                  onSignIn: _updateAuthState,
                  onSignOut: () => _updateAuthState(null),
                ),
              )
            : ElevatedButton(
                onPressed: () async {
                  GoogleSignInCredentials? creds;
                  if (!_signedIn) {
                    creds = await _googleSignIn.signIn();
                  } else {
                    await _googleSignIn.signOut();
                  }
                  _updateAuthState(creds);
                },
                child: Text(_signedIn ? 'Sign Out' : 'Sign in'),
              ),
      ),
    );
  }

  void _updateAuthState(GoogleSignInCredentials? creds) {
    setState(() {
      _signedIn = creds != null;
    });
  }
}
