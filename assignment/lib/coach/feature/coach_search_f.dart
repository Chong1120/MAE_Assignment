import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL =
    'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to search for coaches based on the search query
Future<List<Map<String, dynamic>>> searchCoaches(String query) async {
  final response = await http.get(Uri.parse('${databaseURL}user/coach.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> coaches = [];

    data.forEach((key, value) {
      if (value['username'].toLowerCase().contains(query.toLowerCase())) {
        coaches.add({
          'id': key,
          'username': value['username'],
          'bio': value['bio'],
        });
      }
    });

    return coaches;
  } else {
    throw Exception('Failed to load coaches');
  }
}
