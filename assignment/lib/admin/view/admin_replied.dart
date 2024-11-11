import 'package:flutter/material.dart';
import '../feature/admin_feedback_f.dart';

class AdminRepliedPage extends StatefulWidget{
  const AdminRepliedPage ({super.key});


  @override
  _AdminRepliedPageState createState() => _AdminRepliedPageState();
}

class _AdminRepliedPageState extends State<AdminRepliedPage> {
  List<Map<String, dynamic>> feedbackList = [];

  @override
  void initState() {
    super.initState();
    fetchUserFeedback();
  }

  Future<void> fetchUserFeedback() async {
    List<Map<String, dynamic>> feedback = await getRepliedUserFeedback();
    setState(() {
      feedbackList = feedback;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}