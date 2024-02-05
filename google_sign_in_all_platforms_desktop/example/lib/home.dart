import 'package:example/secrets.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms_desktop/google_sign_in_all_platforms_desktop.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _signedIn = false;
  final GoogleSignInAllPlatformsDesktop _googleSignIn =
      GoogleSignInAllPlatformsDesktop();

  @override
  void initState() {
    _googleSignIn.init(const GoogleSignInParams(
      clientId: kGoogleClientId,
      clientSecret: kGoogleClientSecret,
      scopes: kGoogleSignInScopes,
      redirectPort: kGoogleRedirectUriPort,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desktop Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            GoogleSignInCredentials? creds;
            if (!_signedIn) {
              creds = await _googleSignIn.signInOffline();
              creds ??= await _googleSignIn.signInOnline();
            } else {
              await _googleSignIn.signOut();
            }
            final signedIn = creds != null;
            setState(() {
              _signedIn = signedIn;
            });
          },
          child: Text(_signedIn ? 'Sign Out' : 'Sign in'),
        ),
      ),
    );
  }
}
