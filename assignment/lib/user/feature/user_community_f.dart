import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

/// Fetches posts with `approval` set to 'approved'.
Future<List<Map<String, dynamic>>> getApprovedPosts() async {
  final url = Uri.parse('${databaseURL}post.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Create a list of Futures for each post
    List<Future<Map<String, dynamic>>> postFutures = data.entries
        .where((entry) => entry.value['approval'] == 'approved')
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

/// Fetches the likes for a specific post.
Future<List<String>> fetchLikes(String postId) async {
  final url = Uri.parse('${databaseURL}post/$postId/likes.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data == null) return []; // Return an empty list if no likes exist
    return List<String>.from(data.values.map((like) => like['name']));
  } else {
    throw Exception('Failed to load likes');
  }
}


/// Toggles the like status for a user on a specific post.
Future<void> toggleLike(String postId, String userId, bool isLiked) async {
  final url = Uri.parse('${databaseURL}post/$postId/likes/$userId.json');
  if (isLiked) {
    await http.delete(url); // Remove like
  } else {
    await http.put(url, body: json.encode({'name': userId})); // Add like
  }
}

/// Fetches comments for a specific post, ordered by latest to oldest.
Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
  final url = Uri.parse('${databaseURL}post/$postId/comments.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];

    // Convert to list and sort by descending order of keys
    List<Map<String, dynamic>> comments = data.entries.map((entry) {
      return {
        'id': entry.key,
        'name': entry.value['name'],
        'content': entry.value['content'],
      };
    }).toList();

    comments.sort((a, b) => b['id'].compareTo(a['id'])); // Latest to oldest
    return comments;
  } else {
    throw Exception('Failed to load comments');
  }
}

/// Adds a comment to a specific post.
Future<void> addComment(String postId, String userId, String content) async {
  final url = Uri.parse('${databaseURL}post/$postId/comments.json');
  await http.post(
    url,
    body: json.encode({'name': userId, 'content': content}),
  );
}

/// Reports a post by setting `reported` to true and `approval` to 'disapproved'.
Future<void> reportPost(String postId) async {
  final url = Uri.parse('${databaseURL}post/$postId.json');
  await http.patch(
    url,
    body: json.encode({'reported': true, 'approval': 'disapproved'}),
  );
}