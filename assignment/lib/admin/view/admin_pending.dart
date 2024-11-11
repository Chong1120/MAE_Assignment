import 'package:flutter/material.dart';
import '../feature/admin_feedback_f.dart';

class AdminPendingPage extends StatefulWidget{
  const AdminPendingPage ({super.key});


  @override
  _AdminPendingPageState createState() => _AdminPendingPageState();
}

class _AdminPendingPageState extends State<AdminPendingPage> {
  List<Map<String, dynamic>> feedbackList = [];
  final Map<String, TextEditingController> _replyControllers = {}; // Map for controllers

  @override
  void initState() {
    super.initState();
    fetchUserFeedback();
  }

  @override
  void dispose() {
    // Dispose each TextEditingController to free up resources
    for (var controller in _replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> fetchUserFeedback() async {
    List<Map<String, dynamic>> feedback = await getUserFeedback();
    setState(() {
      feedbackList = feedback;
      // Initialize a TextEditingController for each feedback item
      for (var feedbackItem in feedback) {
        _replyControllers[feedbackItem['id']] = TextEditingController();
      }
    });
  }

  Future<void> updateFeedback(String feedbackId, String reply) async {
    await addNewFeedback(feedbackId, reply);
    fetchUserFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = feedbackList[index];
          final feedbackId = feedback['id'];
          final controller = _replyControllers[feedbackId]!; // Use the specific controller

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feedback['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text(feedback['content']),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: 'Reply'),
                    onSubmitted: (value) => updateFeedback(feedbackId, value),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Sent on: ${feedback['datetime']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
