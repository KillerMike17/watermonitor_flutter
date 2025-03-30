// File: lib/pages/hamburger/hamburger.dart
import 'package:flutter/material.dart';
import 'package:login_ui/pages/profile/profile.dart'; // Import the ProfilePage

class Hamburger extends StatelessWidget {
  const Hamburger({Key? key}) : super(key: key);

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Menu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the menu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to privacy policy
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                // Handle sign out
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to about page
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => _showMenu(context),
    );
  }
}