import 'package:flutter/material.dart';
import 'package:login_ui/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/widgets/custom_drawer.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ApiService _apiService = ApiService();
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _apiService.getNotifications();
      
      if (response.statusCode == 200) {
        final List<dynamic> notificationData = response.data is Map && response.data.containsKey('data') 
            ? response.data['data'] 
            : response.data is List 
                ? response.data 
                : [];

        setState(() {
          _notifications = notificationData.map((notification) {
            return NotificationItem(
              title: notification['title'] ?? 'No Title',
              body: notification['body'] ?? 'No content',
              type: notification['type'] ?? 'General',
              recipient: notification['to'] ?? 'Unknown recipient',
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load notifications: ${response.statusCode}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchNotifications,
          ),
        ],
      ),
      body: _buildBody(),
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
              onPressed: _fetchNotifications,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 60, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text('No notifications yet', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNotifications,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(notification.title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Chip(
                        label: Text(notification.type),
                        visualDensity: VisualDensity.compact,
                      ),
                      SizedBox(width: 8),
                      if (notification.recipient.isNotEmpty)
                        Text('To: ${notification.recipient}',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              onTap: () => _showNotificationDetail(context, notification),
            ),
          );
        },
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.body),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(notification.type),
                  ),
                  if (notification.recipient.isNotEmpty)
                    Chip(
                      label: Text('To: ${notification.recipient}'),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String body;
  final String type;
  final String recipient;

  NotificationItem({
    required this.title,
    required this.body,
    required this.type,
    required this.recipient,
  });
}