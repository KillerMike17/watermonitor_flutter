import 'package:flutter/material.dart';
import 'package:login_ui/pages/SupportTicket/create_ticket_screen.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';
import 'package:login_ui/widgets/custom_drawer.dart';

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  List<Map<String, String>> tickets = [
    {
      'issueType': 'Sensor Issue',
      'description': 'Temperature sensor showing incorrect readings',
      'status': 'Open',
      'date': 'Today, 10:30 AM'
    },
    {
      'issueType': 'Connection Problem',
      'description': 'Device frequently disconnecting from network',
      'status': 'In Progress',
      'date': 'Yesterday, 2:15 PM'
    },
    {
      'issueType': 'Hardware Fault',
      'description': 'Button not responding to touch',
      'status': 'Resolved',
      'date': 'May 15, 2023'
    },
  ];

  void addTicket(String issueType, String description) {
    setState(() {
      tickets.insert(0, {
        'issueType': issueType,
        'description': description,
        'status': 'Open',
        'date': 'Just now'
      });
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          'Support Tickets',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: tickets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.support_agent, size: 60, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No support tickets yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to create your first ticket',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(16),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Add navigation to ticket details if needed
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ticket['issueType']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(ticket['status']!)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getStatusColor(ticket['status']!),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  ticket['status']!,
                                  style: TextStyle(
                                    color: _getStatusColor(ticket['status']!),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            ticket['description']!,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4),
                              Text(
                                ticket['date']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTicket = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSupportTicketPage(),
            ),
          );
          if (newTicket != null) {
            addTicket(newTicket['issueType'], newTicket['description']);
          }
        },
        child: Icon(Icons.add, size: 28),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        tooltip: 'Create New Ticket',
      ),
    );
  }
}