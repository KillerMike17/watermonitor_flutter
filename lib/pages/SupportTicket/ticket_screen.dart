import 'package:flutter/material.dart';
import 'package:login_ui/pages/SupportTicket/create_ticket_screen.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';
import 'package:login_ui/widgets/custom_drawer.dart';

class TicketListPage extends StatefulWidget {
  // const TicketListPage({super.key});

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
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Support Tickets'),
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
            MaterialPageRoute(
              builder: (context) =>  CreateSupportTicketPage(),
            ),
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