// notification_page.dart
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(title: 'Water Leak Detected', detail: 'A leak has been detected in Zone A.'),
    NotificationItem(title: 'pH Level Alert', detail: 'pH level is above the normal range.'),
    NotificationItem(title: 'Maintenance Required', detail: 'Scheduled maintenance for the Turbidity Sensor.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index].title),
            onTap: () {
              _showNotificationDetail(context, notifications[index]);
            },
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
          content: Text(notification.detail),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String detail;

  NotificationItem({required this.title, required this.detail});
}
