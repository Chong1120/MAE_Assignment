import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<List<Map<String, dynamic>>> getPosts(String status, bool report) async {
  final url = Uri.parse('${databaseURL}post.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Create a list of Futures for each post
    List<Future<Map<String, dynamic>>> postFutures = data.entries
        .where((entry) => entry.value['approval'] == status && entry.value['reported'] == report)
        .map((entry) async {
      final post = entry.value;
      final userId = post['name'];
      final url = Uri.parse('${databaseURL}user/coach/$userId.json');
      final response = await http.get(url);
      String gender = '';
      String username = '';

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        gender = userData['gender'] ?? 'unknown'; // Default if gender is null
        username = userData['username'] ?? 'unknown'; // Default if username is null
      } else {
        throw Exception('Failed to load user data');
      }
      return {
        'id': entry.key,
        'name': post['name'] ?? 'Unknown',
        'title': post['title'],
        'content': post['content'],
        'reported': post['reported'],
        'datetime': post['datetime'],
        'approval': post['approval'],
        'gender': gender,
        'username': username,
        'likes': post['likes'] ?? 0, // Default to 0 if likes doesn't exist
      };
    }).toList();

    // Wait for all Futures to complete
    List<Map<String, dynamic>> posts = await Future.wait(postFutures);

    // Sort posts by datetime in descending order
    posts.sort((a, b) => b['datetime'].compareTo(a['datetime']));

    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<void> updatePost(String postId, bool report, String status) async {
  final url = Uri.parse('${databaseURL}post/$postId.json');
  await http.patch(
    url,
    body: json.encode({'reported': report, 'approval': status}),
  );
}
