import 'admin/view/admin_announcement.dart';
import 'coach/view/coach_notitfication.dart';
import 'user/view/user_notitfication.dart';
import 'general/view/forget_password.dart';
import 'general/view/reset_success.dart';
import 'package:flutter/material.dart';
import 'general/view/login.dart';
import 'admin/view/admin_notitfication.dart'; 
import 'admin/view/admin_home.dart';
import 'admin/view/admin_activity.dart';
import 'admin/view/admin_feedback.dart';
import 'admin/view/admin_manage.dart';
import 'admin/view/admin_profile.dart';
import 'coach/view/coach_add.dart';
import 'coach/view/coach_home.dart';
import 'coach/view/coach_report.dart';
import 'coach/view/coach_feedback.dart';
import 'coach/view/coach_profile.dart';
import 'coach/view/coach_search.dart';

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
        '/admin_home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminHome(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/admin_activity': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminActivity(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/admin_manage': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminManage(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/admin_feedback': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminFeedback(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/admin_notification': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminNotification(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        }, 
        '/admin_profile': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return AdminProfile(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        }, 


        '/coach_notification': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachNotification(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/coach_home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachHome(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/coach_feedback': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachFeedback(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/coach_add': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachAdd(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/coach_profile': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachProfile(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/coach_report': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachReport(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },
        '/coach_search': (context) {
          final args = ModalRoute.of(context)?.settings.arguments; 
          if (args is Map<String, dynamic>) { 
            return CoachSearch(userId: args['userId']); 
          } else {
            return const LoginPage(); 
          }
        },

        '/user_notification': (context) => const UserNotification(),

      },
    );
  }
}