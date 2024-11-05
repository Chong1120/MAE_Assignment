// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class UserFeedback extends StatefulWidget {
  final String userId; 
  const UserFeedback({super.key, required this.userId});

  @override
  _UserFeedbackState createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Here is user feedback"),
          ],
        ),
      ),
    );
  }
}
