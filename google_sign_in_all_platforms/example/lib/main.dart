import 'package:flutter/material.dart';
import 'package:example/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:googleapis/people/v1.dart' as people;

import 'components/profile_card.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      ),
    );

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    params: const GoogleSignInParams(
      clientId: kGoogleClientId,
      clientSecret: kGoogleClientSecret,
      scopes: ['openid', 'profile', 'email'],
    ),
  );

  @override
  void initState() {
    /* Recommended to call lightweightSignIn to follow the officially recommended flow.
    We can also do something like this:
    ```dart
    (await _googleSignIn.silentSignIn()) ?? await _googleSignIn.lightweightSignIn();
    ``` 
    
    This will ensure in case the saved token is expired, it goes through the official 
    recommended flow, for refreshing the token.
    */
    _googleSignIn.silentSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Profile Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Recommended to subscribe to authenticatedState to check sign-in state
          child: StreamBuilder<GoogleSignInCredentials?>(
            stream: _googleSignIn.authenticationState,
            builder: (context, snapshot) {
              final isSignedIn = snapshot.data != null;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // A simple custom card widget to display the user profile.
                  ProfileCard(
                    isSignedIn: isSignedIn,
                    fetchPerson: _fetchPerson,
                  ),
                  const SizedBox(height: 20),

                  // Main sign in/out button implementation, example.
                  if (isSignedIn)
                    ElevatedButton(
                      onPressed: _googleSignIn.signOut,
                      child: const Text('Sign Out'),
                    )
                  else if (kIsWeb)
                    _googleSignIn.signInButton() ?? const SizedBox.shrink()
                  else
                    ElevatedButton(
                      onPressed: _googleSignIn.signIn,
                      child: const Text('Sign In'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// An example for how to use googleapis with the plugin.
  Future<people.Person> _fetchPerson() async {
    final authClient = await _googleSignIn.authenticatedClient;

    if (authClient == null) {
      throw Exception('Failed to get authenticated client');
    }

    final peopleApi = people.PeopleServiceApi(authClient);

    final person = await peopleApi.people.get(
      'people/me',
      personFields: 'names,emailAddresses,photos',
    );

    return person;
  }
}
