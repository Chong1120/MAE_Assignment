// user_report.dart

// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import '../feature/coach_feedback_f.dart';

class CoachFeedback extends StatefulWidget {
  final String userId;
  const CoachFeedback({super.key, required this.userId});

  @override
  _CoachFeedbackState createState() => _CoachFeedbackState();
}

class _CoachFeedbackState extends State<CoachFeedback> {
  List<Map<String, dynamic>> feedbackList = [];

  @override
  void initState() {
    super.initState();
    fetchCoachFeedback();
  }

  Future<void> fetchCoachFeedback() async {
    List<Map<String, dynamic>> feedback = await getCoachFeedback(widget.userId);
    setState(() {
      feedbackList = feedback;
    });
  }

  Future<void> addFeedback(String title, String content) async {
    await addNewFeedback(widget.userId, title, content);
    fetchCoachFeedback(); // Refresh feedback list
  }

  void _showAddFeedbackDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                // maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                addFeedback(titleController.text, contentController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        title: const Text('Feedback'),
      ),
      body: ListView.builder(
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = feedbackList[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(feedback['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feedback['content']),
                  const SizedBox(height: 8.0),
                  Text(
                    feedback['reply']?.isEmpty ?? true
                        ? "Waiting for admin to reply"
                        : "Reply: ${feedback['reply']}",
                    style: TextStyle(
                      color: feedback['reply']?.isEmpty ?? true
                          ? Colors.red
                          : Colors.green,
                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFeedbackDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
