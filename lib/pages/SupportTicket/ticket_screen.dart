import 'package:flutter/material.dart';
import 'package:login_ui/pages/SupportTicket/create_ticket_screen.dart';
import 'package:login_ui/pages/notificaiton/notification_page.dart';
import 'package:login_ui/services/api_service.dart';
import 'package:login_ui/widgets/custom_drawer.dart';
import 'package:intl/intl.dart';

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final ApiService _apiService = ApiService();
  final DateFormat _dateFormat = DateFormat('MMM d, y • hh:mm a');
  
  List<Map<String, dynamic>> _tickets = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _apiService.getSupportTickets();
      
      if (response.statusCode == 200) {
        // Handle both response formats:
        // 1. Direct array response
        // 2. Object with 'data' array
        final List<dynamic> ticketData = response.data is Map && response.data.containsKey('data') 
            ? response.data['data'] 
            : response.data is List 
                ? response.data 
                : [];

        setState(() {
          _tickets = ticketData.map((ticket) {
            return {
              'id': ticket['_id'] ?? ticket['id'],
              'issueType': _formatIssueType(ticket['type']),
              'description': ticket['description'],
              'status': _mapStatus(ticket['status']),
              'date': _formatDate(ticket['createdAt'] ?? DateTime.now().toString()),
              'technician': ticket['technicianId'] ?? 'Unassigned',
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load tickets: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // Rest of your existing helper methods remain the same...
  String _formatIssueType(String type) {
    switch (type) {
      case 'SENSOR': return 'Sensor Issue';
      case 'HARDWARE': return 'Hardware Problem';
      case 'SOFTWARE': return 'Software Bug';
      case 'NETWORK': return 'Network Issue';
      default: return type;
    }
  }

  String _mapStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return 'Open';
      case 'IN_PROGRESS': return 'In Progress';
      case 'RESOLVED': return 'Resolved';
      default: return status;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return _dateFormat.format(date);
    } catch (e) {
      return 'Unknown date';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return Colors.orange;
      case 'IN_PROGRESS': return Colors.blue;
      case 'RESOLVED': return Colors.green;
      default: return Colors.grey;
    }
  }

  // Rest of your build methods remain exactly the same...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Support Tickets', 
               style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchTickets,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (context) => CreateSupportTicketPage()),
          );
          if (result != null) await _fetchTickets();
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchTickets,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.support_agent, size: 60, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text('No support tickets yet', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Create your first ticket using the + button',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchTickets,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final ticket = _tickets[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticket['issueType'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(ticket['status']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(ticket['status']),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          ticket['status'],
                          style: TextStyle(
                            color: _getStatusColor(ticket['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(ticket['description'],
                      style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.engineering, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 6),
                      Text(ticket['technician'].toString(),
                          style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}