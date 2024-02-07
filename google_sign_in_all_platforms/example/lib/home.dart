import 'package:example/secrets.dart';
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
