import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms_macos/google_sign_in_all_platforms_macos.dart';

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
      const GoogleSignInParams(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Windows Example')),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _signedIn = true;
              },
              child: Text(_signedIn ? 'Sign Out' : 'Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
