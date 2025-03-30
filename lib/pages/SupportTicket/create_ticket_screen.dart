import 'package:flutter/material.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';

class CreateSupportTicketPage extends StatefulWidget {
  // const CreateSupportTicketPage({super.key});

  @override
  _CreateSupportTicketPageState createState() => _CreateSupportTicketPageState();
}

class _CreateSupportTicketPageState extends State<CreateSupportTicketPage> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedIssueType;
  final List<String> _issueTypes = [
    'Sensor',
    'Connection',
    'Hardware',
    'Other'
  ];

  void _submitTicket() {
    final description = _descriptionController.text;
    final issueType = _selectedIssueType;

    if (description.isEmpty || issueType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.pop(
        context, {'issueType': issueType, 'description': description});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Support Ticket'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter a detailed description...',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedIssueType,
              hint: const Text('Choose an issue type'),
              items: _issueTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIssueType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitTicket,
              icon: const Icon(Icons.send),
              label: const Text('Submit Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}