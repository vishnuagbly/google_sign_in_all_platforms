import 'package:flutter/material.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:googleapis/people/v1.dart' as people;

// Data model for user profile
class UserProfile {
  final String? name;
  final String? email;
  final String? photoUrl;

  UserProfile({
    this.name,
    this.email,
    this.photoUrl,
  });
}

class ProfileCard extends StatefulWidget {
  final GoogleSignIn googleSignIn;
  final bool isSignedIn;
  final GoogleSignInCredentials? credentials;

  const ProfileCard({
    super.key,
    required this.googleSignIn,
    required this.isSignedIn,
    this.credentials,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  UserProfile? _userProfile;
  bool _isLoadingProfile = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.isSignedIn && widget.credentials != null) {
      _fetchUserProfile();
    }
  }

  @override
  void didUpdateWidget(ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch profile when signing in
    if (!oldWidget.isSignedIn && widget.isSignedIn && widget.credentials != null) {
      _fetchUserProfile();
    }
    // Clear profile when signing out
    if (oldWidget.isSignedIn && !widget.isSignedIn) {
      setState(() {
        _userProfile = null;
        _isLoadingProfile = false;
        _errorMessage = null;
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoadingProfile = true;
      _errorMessage = null;
    });

    try {
      // Get authenticated HTTP client from GoogleSignIn
      final authClient = await widget.googleSignIn.authenticatedClient;
      
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

      // Extract profile information
      final profile = UserProfile(
        name: person.names?.isNotEmpty == true 
            ? person.names!.first.displayName
            : null,
        email: person.emailAddresses?.isNotEmpty == true
            ? person.emailAddresses!.first.value
            : null,
        photoUrl: person.photos?.isNotEmpty == true
            ? person.photos!.first.url
            : null,
      );

      setState(() {
        _userProfile = profile;
        _isLoadingProfile = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProfile = false;
        _errorMessage = 'Failed to load profile: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // Maximum width for better landscape display
        ),
        child: _buildCardContent(),
      ),
    );
  }

  Widget _buildCardContent() {
    // Show sign-in message when user is not signed in
    if (!widget.isSignedIn) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sign in to view your profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (_isLoadingProfile) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading profile data...'),
              ],
            ),
          ),
        ),
      );
    }
    
    if (_errorMessage != null) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchUserProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    if (_userProfile == null) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Text('No profile data available'),
          ),
        ),
      );
    }
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Photo with error handling
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: _userProfile!.photoUrl != null
                  ? ClipOval(
                      child: Image.network(
                        _userProfile!.photoUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Show fallback icon when image fails to load
                          return const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          // Show loading indicator
                          return const SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Profile Information
            _buildProfileItem(
              icon: Icons.person,
              label: 'Name',
              value: _userProfile!.name ?? 'Not available',
            ),
            const SizedBox(height: 12),
            
            _buildProfileItem(
              icon: Icons.email,
              label: 'Email',
              value: _userProfile!.email ?? 'Not available',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
