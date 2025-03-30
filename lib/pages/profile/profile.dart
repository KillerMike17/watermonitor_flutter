import 'package:flutter/material.dart';

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
  String name = 'Mike Y';
  String address = 'Address';

  void _editName() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController(text: name);
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editAddress() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController addressController = TextEditingController(text: address);
        return AlertDialog(
          title: Text('Edit Address'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  address = addressController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
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
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action
                Navigator.of(context).pop();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue, // Blue title bar
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editName,
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
            SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '+2519292085135',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(address),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: _editAddress,
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    subtitle: Text('English'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}