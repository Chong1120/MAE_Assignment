import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<String> checkLogin(String username, String password) async {
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Check 'admin' category
    if (data.containsKey('admin')) {
      final adminData = data['admin'];
      if (_validateCredentials(adminData, username, password)) {
        return 'admin';
      }
    }

    // Check 'coach' category
    if (data.containsKey('coach')) {
      final coachData = data['coach'];
      if (_validateCredentials(coachData, username, password)) {
        return 'coach';
      }
    }

    // Check 'user' category
    if (data.containsKey('user')) {
      final userData = data['user'];
      if (_validateCredentials(userData, username, password)) {
        return 'user';
      }
    }

    // No match found
    return 'invalid';
  } else {
    throw Exception('Failed to load user data');
  }
}

// Helper function to validate credentials in each category
bool _validateCredentials(Map<String, dynamic> userData, String username, String password) {
  // Directly compare the username and password in the given user data
  return userData['username'] == username && userData['password'] == password;
}
