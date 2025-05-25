import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';
import 'package:login_ui/services/api_service.dart';
import 'package:login_ui/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();

  dynamic? name;
  dynamic? address;
  dynamic? email;
  dynamic? userData; // Define user variable to store user
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
        name = ((decodedUser['firstName']?.toString() ?? '') +
            (decodedUser['lastName']?.toString() ??
                '')); // Ensure uuid is treated as string
        email = (decodedUser['email']?.toString() ?? '');
        address = (decodedUser['address']?.toString() ?? '');
      });
      print('Full user data: $userData');
    }
  }

  void _editName() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController =
            TextEditingController(text: name);
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Handle logout logic here
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action
                Navigator.of(context).pop();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // White background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(address),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    // Removed onTap to make it non-editable
                  ),
                  const ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    subtitle: Text('English'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}