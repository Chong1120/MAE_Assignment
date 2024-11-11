// user_report_f.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<List<Map<String, dynamic>>> getCoachFeedback(String userId) async {
  final url = Uri.parse('$databaseURL/feedback.json');
  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("Failed to load data: ${response.statusCode}");
    return [];
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  List<Map<String, dynamic>> CoachFeedbackList = [];

  data.forEach((feedbackId, feedbackData) {
    if (feedbackData['sendby'] == userId) {
      CoachFeedbackList.add({
        'title': feedbackData['title'] ?? 'No Title',
        'content': feedbackData['content'] ?? 'No Content',
        'reply': feedbackData['reply'] ?? '',
        'datetime': feedbackData['datetime'] ?? 'No Date',
      });
    }
  });

  // Sort the list by 'datetime' field in descending order (latest to oldest)
  CoachFeedbackList.sort((a, b) => DateTime.parse(b['datetime']).compareTo(DateTime.parse(a['datetime'])));

  return CoachFeedbackList;
}


Future<void> addNewFeedback(String userId, String title, String content) async {
  final url = Uri.parse('$databaseURL/feedback.json');
  final feedbackData = {
    'title': title,
    'content': content,
    'reply': '',
    'sendby': userId,
    'datetime': DateTime.now().toIso8601String(),
  };

  final response = await http.post(
    url,
    body: json.encode(feedbackData),
  );

  if (response.statusCode != 200) {
    print("Failed to add feedback: ${response.statusCode}");
  }
}
