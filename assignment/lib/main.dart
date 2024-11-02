import 'package:flutter/material.dart';
import 'admin/view/admin_announcement.dart'; // Import your announcement page
// import 'view/admin_notification.dart'; // Ensure you import other pages you may use
// import 'view/admin_profile.dart';
// import 'view/admin_home.dart';
// import 'view/admin_activity.dart';
// import 'view/admin_manage.dart';
// import 'view/admin_feedback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AdminAnnouncement(), // Set AdminAnnouncement as the home page
        // '/admin_notification': (context) => AdminNotification(), // Replace with your actual notification page
        // '/admin_profile': (context) => AdminProfile(), // Replace with your actual profile page
        // '/admin_home': (context) => AdminHome(), // Replace with your actual home page
        // '/admin_activity': (context) => AdminActivity(), // Replace with your actual activity page
        // '/admin_manage': (context) => AdminManage(), // Replace with your actual manage page
        // '/admin_feedback': (context) => AdminFeedback(), // Replace with your actual feedback page
      },
    );
  }
}
