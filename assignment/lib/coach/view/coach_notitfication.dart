import 'package:flutter/material.dart';
import '../feature/coach_notification_f.dart'; // Import the function file for notifications

class CoachNotification extends StatefulWidget {
  const CoachNotification({Key? key}) : super(key: key);

  @override
  _CoachNotificationState createState() => _CoachNotificationState();
}

class _CoachNotificationState extends State<CoachNotification> {
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
