import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL =
    'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to edit an existing activity
Future<void> editActivity(
    String activityId, Map<String, dynamic> updatedActivity) async {
  final response = await http.put(
    Uri.parse('${databaseURL}activity/$activityId.json'),
    body: json.encode(updatedActivity),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to edit activity');
  }
}
