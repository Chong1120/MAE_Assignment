import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Fetch posts by the logged-in coach (userId)
Future<List<Map<String, dynamic>>> fetchCoachPosts(String userId) async {
  final url = Uri.parse('${databaseURL}post.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    List<Map<String, dynamic>> coachPosts = [];

    data.forEach((postId, postData) {
      if (postData['name'] == userId &&
          postData['approval'] == 'approved' &&
          postData['reported'] == false) {
        
        coachPosts.add({
          'id': postId,
          'title': postData['title'] ?? 'Untitled',
          'likes_count': postData['likes']?.length ?? 0,
          'comments_count': postData['comments']?.length ?? 0,
        });
      }
    });

    return coachPosts;
  } else {
    throw Exception('Failed to load coach posts');
  }
}

// Calculate the total likes and comments for the coach
Future<Map<String, num>> calculateTotalLikesAndComments(String userId) async {
  final coachPosts = await fetchCoachPosts(userId);

  num totalLikes = 0;
  num totalComments = 0;

  for (var post in coachPosts) {
    totalLikes += post['likes_count'];
    totalComments += post['comments_count'];
  }

  return {
    'totalLikes': totalLikes,
    'totalComments': totalComments,
  };
}

// Sort posts by likes
List<Map<String, dynamic>> sortPostsByLikes(List<Map<String, dynamic>> posts) {
  posts.sort((a, b) => b['likes_count'].compareTo(a['likes_count']));
  return posts;
}

// Sort posts by comments
List<Map<String, dynamic>> sortPostsByComments(List<Map<String, dynamic>> posts) {
  posts.sort((a, b) => b['comments_count'].compareTo(a['comments_count']));
  return posts;
}
