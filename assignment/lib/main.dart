import 'package:assignment/admin/view/admin_announcement.dart';
import 'package:assignment/coach/view/coach_notitfication.dart';
import 'package:assignment/user/view/user_notitfication.dart';
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

        '/admin_announcement': (context) => const AdminAnnouncement(),
        '/admin_notification': (context) => const AdminNotification(), 


        '/coach_notification': (context) => const CoachNotification(),


        '/user_notification': (context) => const UserNotification(),

      },
    );
  }
}

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart'; // Required to initialize Firebase
// import 'package:flutter/material.dart'; // Required for Flutter widgets


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(MyApp()); // Start your app
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Your App Title',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // home: YourHomePage(), // Replace with your actual home page widget
//     );
//   }
// }

