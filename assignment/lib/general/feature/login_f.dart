import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to check login credentials and return both category and userId if matched
Future<Map<String, String>?> checkLogin(String username, String password) async {
  print("1");
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    for (var category in ['admin', 'coach', 'user']) {
      if (data.containsKey(category)) {
        final userData = data[category];
        
        // Check each user ID within the category for a match
        for (var userId in userData.keys) {
          final user = userData[userId];
          if (user['username'] == username && user['password'] == password) {
            // Return both category and userId in a map
            return {'category': category, 'userId': userId};
          }
        }
      }
    }
    
    return null; // Invalid credentials
  } else {
    throw Exception('Failed to load user data');
  }
}
