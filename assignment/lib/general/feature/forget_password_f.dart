// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to check if username and secret word match
Future<bool> checkSecretWord(String username, String secretWord) async {
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Iterate over user types (admin, coach, user) to find the matching username and secret word
    for (var category in ['admin', 'coach', 'user']) {
      if (data.containsKey(category)) {
        final userData = data[category];
        // Check each user ID within the category for a match
        for (var userId in userData.keys) {
          final user = userData[userId];
          if (user['username'] == username && user['secretpas'] == secretWord) {
            return true;
          }
        }
      }
    }

    // No match found
    return false;
  } else {
    throw Exception('Failed to load user data');
  }
}

// Function to update the password
Future<void> updatePassword(String username, String newPassword) async {
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Identify user category and user ID to update the password
    String category = '';
    String userId = '';

    // Iterate over each category to find the username and get the specific user ID
    for (var cat in ['admin', 'coach', 'user']) {
      if (data.containsKey(cat)) {
        final userData = data[cat];
        for (var id in userData.keys) {
          if (userData[id]['username'] == username) {
            category = cat;
            userId = id;
            break;
          }
        }
      }
      if (category.isNotEmpty && userId.isNotEmpty) break;
    }

    if (category.isNotEmpty && userId.isNotEmpty) {
      final userUpdateUrl = Uri.parse('${databaseURL}user/$category/$userId.json');
      final updateResponse = await http.patch(
        userUpdateUrl,
        body: json.encode({'password': newPassword}),
      );

      if (updateResponse.statusCode == 200) {

      } else {
        throw Exception('Failed to update password');
      }
    } else {
      throw Exception('User or User ID not found');
    }
  } else {
    throw Exception('Failed to load user data');
  }
}
