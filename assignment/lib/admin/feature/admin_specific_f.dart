import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<Map<String, dynamic>> searchUser(String suserId) async {
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    for (var category in ['coach']) {
      if (data.containsKey(category)) {
        final userData = data[category];

        if (userData.containsKey(suserId)) {
          final user = userData[suserId];
          return {
            'username': user['username'] ?? 'Unknown',
            'gender': user['gender'] ?? 'unknown',
            'bio': user['bio'] ?? 'No bio available'
          };
        }
      }
    }

    throw Exception('User not found');
  } else {
    throw Exception('Failed to load user data');
  }
}

Future<List<Map<String, dynamic>>> fetchUserPosts(String suserId) async {
  print('Fetching posts for user: $suserId');
  final url = Uri.parse('${databaseURL}post.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> userPosts = [];

    data.forEach((postId, postData) {
      print('Post ID: $postId, Post Data: $postData');
      if (postData['name'] == suserId &&
          postData['approval'] == 'approved' &&
          postData['reported'] == false) {
        print('Adding post: $postId');
        userPosts.add({
          'id': postId,
          'title': postData['title'] ?? 'Untitled',
          'content': postData['content'] ?? 'No content available',
          'timestamp': postData['datetime'] ?? 'Unknown',
          'category': postData['category'] ?? 'General',
          'likes_count': postData['likes']?.length ?? 0,
          'comments_count': postData['comments']?.length ?? 0,
        });
      }
    });

    print('Total posts fetched: ${userPosts.length}');
    return userPosts;
  } else {
    throw Exception('Failed to load user posts');
  }
}


