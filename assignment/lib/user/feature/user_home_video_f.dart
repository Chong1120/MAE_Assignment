import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for date formatting

const String databaseURL =
    'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

// Function to fetch workout videos based on the selected category
Future<List<Map<String, dynamic>>> fetchWorkoutVideos(String category) async {
  final response = await http.get(Uri.parse('${databaseURL}activity.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<Map<String, dynamic>> videos = [];

    for (var activity in data.values) {
      if (activity['category'] == category) {
        videos.add({
          'videoname': activity['videoname'],
          'videodescription': activity['videodescription'],
          'videourl': activity['videourl'],
        });
      }
    }

    return videos;
  } else {
    throw Exception('Failed to load videos');
  }
}

// Function to update user activity in Firebase
Future<void> updateUserActivity(String userId) async {
  final currentDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now()); // Get current date
  final userActivityPath =
      'user/user/$userId/activity'; // Path to user's activities

  // Fetch existing activities
  final response =
      await http.get(Uri.parse('${databaseURL}$userActivityPath.json'));

  if (response.statusCode == 200) {
    final Map<String, dynamic>? activitiesData = json.decode(response.body);

    // If there's no activity data yet (for new users)
    if (activitiesData == null || activitiesData.isEmpty) {
      // Create a new activity for the user with the current date and set count to 1
      final newActivityKey =
          'activity001_$userId'; // Generate a key for the new activity
      await http.put(
        Uri.parse('${databaseURL}$userActivityPath/$newActivityKey.json'),
        body: json.encode({
          'date': currentDate,
          'number': 1, // Start with 1 for the new activity
        }),
      );
      return; // Exit the function as we have added the initial activity
    }

    bool dateExists = false;
    String activityKeyToUpdate = '';
    int activityCount = 0;

    // Check if any activity has the current date
    activitiesData.forEach((key, activity) {
      if (activity['date'] == currentDate) {
        dateExists = true;
        activityKeyToUpdate = key; // Store the key of the activity to update
        activityCount = activity['number']; // Get the existing count
      }
    });

    if (dateExists) {
      // If the date exists, update the existing activity's count
      await http.patch(
        Uri.parse('${databaseURL}$userActivityPath/$activityKeyToUpdate.json'),
        body: json.encode({'number': activityCount + 1}), // Increment count
      );
    } else {
      // If the date does not exist, create a new activity
      final newActivityKey =
          'activity00${activitiesData.length + 1}_$userId'; // Create a new key
      await http.put(
        Uri.parse('${databaseURL}$userActivityPath/$newActivityKey.json'),
        body: json.encode({
          'date': currentDate,
          'number': 1, // Start with 1 for the new activity
        }),
      );
    }
  } else {
    throw Exception('Failed to load user activities');
  }
}
