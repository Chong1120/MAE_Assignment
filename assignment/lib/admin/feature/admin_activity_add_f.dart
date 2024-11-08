import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL =
    'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to add a new activity
Future<void> addActivity(Map<String, dynamic> activity) async {
  final response = await http.post(
    Uri.parse('${databaseURL}activity.json'),
    body: json.encode(activity),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add activity');
  }
}
