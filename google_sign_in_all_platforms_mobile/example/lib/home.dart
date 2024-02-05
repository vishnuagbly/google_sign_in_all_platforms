import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms_mobile/google_sign_in_all_platforms_mobile.dart';
import 'package:google_sign_in_all_platforms_mobile_example/secrets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _signedIn = false;
  final GoogleSignInAllPlatformsMobile _googleSignIn =
      GoogleSignInAllPlatformsMobile();

  @override
  void initState() {
    _googleSignIn.init(const GoogleSignInParams(clientId: kGoogleClientId));
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
