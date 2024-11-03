import 'admin/view/admin_announcement.dart';
import 'coach/view/coach_notitfication.dart';
import 'user/view/user_notitfication.dart';
import 'general/view/forget_password.dart';
import 'general/view/reset_success.dart';
import 'package:flutter/material.dart';
import 'general/view/login.dart';
import 'admin/view/admin_notitfication.dart'; 


void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Your App Title',
      theme: ThemeData
      (
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: 
      {
        '/': (context) => const LoginPage(), 

        '/login': (context) => const LoginPage(),
        '/forget_password': (context) => const ForgetPasswordPage(),
        '/reset_success': (context) => const ResetSuccessPage(),

        '/admin_announcement': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminAnnouncement(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },

        '/admin_notification': (context) => const AdminNotification(), 


        '/coach_notification': (context) => const CoachNotification(),


        '/user_notification': (context) => const UserNotification(),

      },
    );
  }
}