import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:helpful_components/helpful_components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _kClientId =
      '1068367409273-7hqioe7d0j1tcokk4uk9satmfvcpj1bj.apps.'
      'googleusercontent.com';

  static const _kClientSecret = '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';

  late final GoogleSignIn _googleSignIn;

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
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => FutureDialog(
                    future: _googleSignIn.signInOnline(),
                  ),
                );
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => FutureDialog(
                    future: _googleSignIn.signOut(),
                  ),
                );
              },
              child: const Text('Sign Out'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
