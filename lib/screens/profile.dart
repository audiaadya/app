import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onSignOut;

  const ProfileScreen({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: onSignOut,
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
        ),
      ),
    );
  }
}
