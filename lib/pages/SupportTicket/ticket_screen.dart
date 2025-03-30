import 'package:flutter/material.dart';

void main() {
  runApp(SupportTicketApp());
}

class SupportTicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Support Ticket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      home: TicketListPage(),
    );
  }
}

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  List<Map<String, String>> tickets = [
    {'issueType': 'Sensor', 'description': 'Temperature sensor malfunction'},
    {'issueType': 'Connection', 'description': 'Network connectivity issue'},
  ];

  void addTicket(String issueType, String description) {
    setState(() {
      tickets.add({'issueType': issueType, 'description': description});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Tickets'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(ticket['issueType']!),
              subtitle: Text(ticket['description']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTicket = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSupportTicketPage()),
          );
          if (newTicket != null) {
            addTicket(newTicket['issueType'], newTicket['description']);
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Create New Ticket',
      ),
    );
  }
}

class CreateSupportTicketPage extends StatefulWidget {
  @override
  _CreateSupportTicketPageState createState() =>
      _CreateSupportTicketPageState();
}

class _CreateSupportTicketPageState extends State<CreateSupportTicketPage> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedIssueType;
  final List<String> _issueTypes = ['Sensor', 'Connection', 'Hardware', 'Other'];

  void _submitTicket() {
    final description = _descriptionController.text;
    final issueType = _selectedIssueType;

    if (description.isEmpty || issueType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.pop(context, {'issueType': issueType, 'description': description});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Support Ticket'),
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
