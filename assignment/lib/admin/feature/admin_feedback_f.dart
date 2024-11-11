import 'package:http/http.dart' as http;
import 'dart:convert';

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<List<Map<String, dynamic>>> getUserFeedback() async {
  final url = Uri.parse('$databaseURL/feedback.json');
  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("Failed to load data: ${response.statusCode}");
    return [];
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  List<Map<String, dynamic>> userFeedbackList = [];

  data.forEach((feedbackId, feedbackData) {
    if (feedbackData['reply'].isEmpty) {
      userFeedbackList.add({
        'id' : feedbackId,
        'title': feedbackData['title'] ?? 'No Title',
        'content': feedbackData['content'] ?? 'No Content',
        'reply': feedbackData['reply'] ?? '',
        'datetime': feedbackData['datetime'] ?? 'No Date',
      });
    }
  });

  // Sort the list by 'datetime' field in descending order (latest to oldest)
  userFeedbackList.sort((a, b) => DateTime.parse(a['datetime']).compareTo(DateTime.parse(b['datetime'])));

  return userFeedbackList;
}

Future<List<Map<String, dynamic>>> getRepliedUserFeedback() async {
  final url = Uri.parse('$databaseURL/feedback.json');
  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("Failed to load data: ${response.statusCode}");
    return [];
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  List<Map<String, dynamic>> userFeedbackList = [];

  data.forEach((feedbackId, feedbackData) {
    if (!feedbackData['reply'].isEmpty) {
      userFeedbackList.add({
        'id' : feedbackId,
        'title': feedbackData['title'] ?? 'No Title',
        'content': feedbackData['content'] ?? 'No Content',
        'reply': feedbackData['reply'] ?? '',
        'datetime': feedbackData['datetime'] ?? 'No Date',
      });
    }
  });

  // Sort the list by 'datetime' field in descending order (latest to oldest)
  userFeedbackList.sort((a, b) => DateTime.parse(b['datetime']).compareTo(DateTime.parse(a['datetime'])));

  return userFeedbackList;
}


Future<void> addNewFeedback(String feedbackId, String reply) async {
  final url = Uri.parse('$databaseURL/feedback/$feedbackId.json');

  final response = await http.patch(
    url,
    body: json.encode({'reply': reply}),
  );

  if (response.statusCode != 200) {
    print("Failed to add feedback: ${response.statusCode}");
  }
}
