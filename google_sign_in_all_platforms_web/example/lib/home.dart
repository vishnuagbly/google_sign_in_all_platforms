import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms_web/google_sign_in_all_platforms_web.dart';

import 'secrets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _signedIn = false;
  final GoogleSignInAllPlatformsWeb _googleSignIn =
      GoogleSignInAllPlatformsWeb();
  late final _alreadySignedInFuture = _googleSignIn.signInOffline().then(
    (creds) => WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _signedIn = creds != null),
    ),
  );

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
        child: FutureBuilder(
          future: _alreadySignedInFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!_signedIn) {
              return _googleSignIn.signInButton(
                config: GSIAPButtonConfig(
                  onSignIn: (creds) => setState(() => _signedIn = true),
                  onSignOut: () => setState(() => _signedIn = false),
                ),
              );
            }

            return ElevatedButton(
              onPressed: () async {
                await _googleSignIn.signOut();
                setState(() {
                  _signedIn = false;
                });
              },
              child: const Text('Sign Out'),
            );
          },
        ),
      ),
    );
  }
}
