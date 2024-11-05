// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CoachFeedback extends StatefulWidget {
  final String userId; 
  const CoachFeedback({super.key, required this.userId});

  @override
  _CoachFeedbackState createState() => _CoachFeedbackState();
}

class _CoachFeedbackState extends State<CoachFeedback> {
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
            Text("Here is coach feedback"),
          ],
        ),
      ),
    );
  }
}
