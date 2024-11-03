import 'package:flutter/material.dart';
import '../feature/admin_notification_f.dart'; 

class AdminNotification extends StatefulWidget 
{
  const AdminNotification({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminNotificationState createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> 
{
  List notifications = []; 

  @override
  void initState() 
  {
    super.initState();
    fetchNotifications(); 
  }

  void fetchNotifications() async 
  {
    final fetchedNotifications = await getNotifications();
    setState(() 
    {
      notifications = fetchedNotifications;
    });
  }

  void showFullNotification(Map<String, dynamic> notification) 
  {
    showDialog
    (
      context: context,
      builder: (context) 
      {
        return AlertDialog
        (
          title: Text(notification['title']),
          content: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: 
            [
              Text(notification['date_time']),
              const SizedBox(height: 10),
              Text(notification['content']),
            ],
          ),
          actions: 
          [
            TextButton
            (
              onPressed: () 
              {
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
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('Notifications'),
      ),
      body: ListView.builder
      (
        itemCount: notifications.length,
        itemBuilder: (context, index) 
        {
          final notification = notifications[index];
          return Card
          (
            child: ListTile
            (
              title: Text(notification['title']),
              subtitle: Text
              (
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
