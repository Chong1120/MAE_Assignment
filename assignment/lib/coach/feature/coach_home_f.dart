import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<String> gender(String userId) async {
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    for (var category in ['coach']) {
      if (data.containsKey(category)) {
        final userData = data[category];
        
        for (var userId in userData.keys) {
          final user = userData[userId];
          return user['gender'] ?? 'unknown';
        }
      }
    }
    
    return 'unknown';
  } else {
    throw Exception('Failed to load user data');
  }
}


Future<List<Map<String, dynamic>>> getpost() async {
  final url = Uri.parse('${databaseURL}post.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    List<Map<String, dynamic>> post = data.entries.map((entry) {
      final post = entry.value;
      return {
        'id': entry.key,
        'name': post['name'] ?? 'Unknown',
      };
    }).toList();

    return post;
  } else {
    throw Exception('Failed to load announcements');
  }
}
