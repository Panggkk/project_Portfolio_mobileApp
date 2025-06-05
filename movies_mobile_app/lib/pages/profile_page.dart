import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // If no user is signed in, navigate to sign-in page
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/sign_in'));
      return const SizedBox(); // Placeholder
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurpleAccent,  // Modern color choice for app bar
      ),
      body: Center(  // Center the content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Vertically center the column content
            crossAxisAlignment: CrossAxisAlignment.center,  // Horizontally center the column content
            children: [
              // Profile Picture with border and dynamic image if available
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.deepPurpleAccent,  // Avatar background color
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null, // Display profile picture if available
                child: user.photoURL == null 
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )
                    : null,  // If there's a profile image, don't show default icon
              ),
              const SizedBox(height: 20),
              
              // Profile information with improved text style
              Text(
                'Email: ${user.email}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),  
              ),
              const SizedBox(height: 8),
              Text(
                'UID: ${user.uid}',
                style: const TextStyle(fontSize: 16, color: Colors.black54), 
              ),
              const SizedBox(height: 40),
              
              // Logout button with gradient background
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.red,  // Set the background color to red
                ),
                onPressed: () => _confirmLogout(context),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),  // Text color for button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel logout
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm logout
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushReplacementNamed(context, '/sign_in'); // Navigate to sign-in page
    }
  }
}
