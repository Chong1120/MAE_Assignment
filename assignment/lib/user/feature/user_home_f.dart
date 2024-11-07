import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL =
    'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to fetch workout categories from Firebase
Future<List<String>> fetchWorkoutCategories() async {
  final response = await http.get(Uri.parse('${databaseURL}activity.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<String> categories = [];

    for (var activity in data.values) {
      if (activity['category'] != null) {
        categories.add(activity['category']);
      }
    }

    return categories.toSet().toList(); // Use toSet() to avoid duplicates
  } else {
    throw Exception('Failed to load categories');
  }
}
