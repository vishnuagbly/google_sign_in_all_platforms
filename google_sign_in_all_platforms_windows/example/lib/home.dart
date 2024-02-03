import 'package:example/secrets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms_windows/google_sign_in_all_platforms_windows.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _googleSignIn = GoogleSignInAllPlatformsMacOS();
  var _signedIn = false;

  @override
  void initState() {
    _googleSignIn.init(
      const GoogleSignInParams(
          clientId: kGoogleClientId,
          clientSecret: kGoogleClientSecret,
          redirectPort: kGoogleRedirectUriPort,
          scopes: kGoogleSignInScopes),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Windows Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (!_signedIn) {
              final creds = await _googleSignIn.signInOnline();
              if (creds == null) return;
            } else {
              await _googleSignIn.signOut();
            }
            setState(() {
              _signedIn = !_signedIn;
            });
          },
          child: Text(_signedIn ? 'Sign Out' : 'Sign In'),
        ),
      ),
    );
  }
}
