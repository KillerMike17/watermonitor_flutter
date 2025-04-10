import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_ui/pages/profile/profile.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ApiService _apiService = ApiService();

  dynamic? uuid;
  dynamic? userData;
  dynamic user; // Define user variable to store user
  @override
  void initState() {
    super.initState();
    _loadUUID();
  }

  Future<void> _loadUUID() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      final decodedUser = json.decode(userJson) as Map<String, dynamic>;
      setState(() {
        userData = decodedUser;
        uuid =
            decodedUser['uuid']?.toString(); // Ensure uuid is treated as string
      });
      print('User UUID: $uuid');
      print('Full user data: $userData');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 10),
                if (uuid != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        uuid!,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: uuid!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                        child:
                            Icon(Icons.copy, size: 18, color: Colors.white70),
                      ),
                    ],
                  )
                else
                  const Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
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
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to about page
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              final response = await _apiService.logout();

              // Handle sign out
            },
          ),
        ],
      ),
    );
  }
}
