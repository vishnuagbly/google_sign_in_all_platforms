import 'package:example/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:googleapis/people/v1.dart' as people;
import 'components/profile_card.dart';

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
      // Using basic scopes that don't require Google app verification
      scopes: ['openid', 'profile', 'email'],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Profile Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               ProfileCard(
                 isSignedIn: _signedIn,
                 fetchPerson: _signedIn ? _fetchPerson : null,
               ),
              const SizedBox(height: 20),
              if (_signedIn)
                _buildSignOutButton()
              else
                _buildSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    if (kIsWeb) {
      return _googleSignIn.signInButton(
        config: GSIAPButtonConfig(
          onSignIn: _updateAuthState,
          onSignOut: () => _updateAuthState(null),
        ),
      ) ?? const SizedBox.shrink();
    } else {
      return ElevatedButton(
        onPressed: () async {
          final creds = await _googleSignIn.signIn();
          _updateAuthState(creds);
        },
        child: const Text('Sign In'),
      );
    }
  }

  Widget _buildSignOutButton() {
    return ElevatedButton(
      onPressed: _signOut,
      child: const Text('Sign Out'),
    );
  }

  Future<people.Person> _fetchPerson() async {
    // Get authenticated HTTP client from GoogleSignIn
    final authClient = await _googleSignIn.authenticatedClient;
    
    if (authClient == null) {
      throw Exception('Failed to get authenticated client');
    }

    // Create People API client
    final peopleApi = people.PeopleServiceApi(authClient);

    // Fetch user profile data
    final person = await peopleApi.people.get(
      'people/me',
      personFields: 'names,emailAddresses,photos',
    );

    return person;
  }

  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    _updateAuthState(null);
  }

  void _updateAuthState(GoogleSignInCredentials? creds) {
    setState(() {
      _signedIn = creds != null;
    });
  }
}
