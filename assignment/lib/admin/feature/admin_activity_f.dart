import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL =
    'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to fetch activities from Firebase
Future<List<Map<String, dynamic>>> fetchActivities() async {
  final response = await http.get(Uri.parse('${databaseURL}activity.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> activities = [];

    data.forEach((key, value) {
      activities.add({
        'id': key, // Store activity ID
        'category': value['category'],
        'videodescription': value['videodescription'],
        'videoname': value['videoname'],
        'videourl': value['videourl'],
      });
    });

    return activities;
  } else {
    throw Exception('Failed to load activities');
  }
}

// Function to delete an activity
Future<void> deleteActivity(String activityId) async {
  final response =
      await http.delete(Uri.parse('${databaseURL}activity/$activityId.json'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete activity');
  }
}

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
