// coach_add_f.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<bool> addPostToDatabase(String userId, String title, String content) async {
  final DateTime now = DateTime.now();
  final String currentDateTime = now.toIso8601String(); // Get current datetime

  try {
    final response = await http.post(
      Uri.parse('$databaseURL/post.json'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'approval': 'approved',
        'content': content,
        'datetime': currentDateTime,
        'name': userId,
        'reported': false,
        'title': title,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added the post
      return true;
    } else {
      // Failed to add the post
      return false;
    }
  } catch (error) {
    print('Error adding post: $error');
    return false;
  }
}
