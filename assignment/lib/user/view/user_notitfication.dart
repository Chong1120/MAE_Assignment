// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../feature/user_notification_f.dart'; // Import the function file for notifications

class UserNotification extends StatefulWidget {
  final String userId; 
  const UserNotification({super.key, required this.userId});

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  List notifications = []; // List to store notifications

  @override
  void initState() {
    super.initState();
    fetchNotifications(); // Fetch notifications when page loads
  }

  void fetchNotifications() async {
    final fetchedNotifications = await getNotifications();
    setState(() {
      notifications = fetchedNotifications;
    });
  }

  void showFullNotification(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(notification['title']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(notification['date_time']),
              const SizedBox(height: 10),
              Text(notification['content']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
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
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            child: ListTile(
              title: Text(notification['title']),
              subtitle: Text(
                '${notification['date_time']}\n${notification['content']}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => showFullNotification(notification), // Show full notification on tap
            ),
          );
        },
      ),
    );
  }
}
