import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<List<Map<String, dynamic>>> fetchWeightData(String userId) async {
  print(userId);
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    List<Map<String, dynamic>> weightlist = [];

    // Iterate through 'coach' category (or other categories if needed)
    for (var category in ['user']) {
      if (data.containsKey(category)) {
        final userData = data[category];

        // Iterate through userData and look for the userId
        for (var currentUserId in userData.keys) {
          if (currentUserId == userId) {
            final userWeights = userData[currentUserId]['weight'];
            
            // If weights exist for the user, iterate and collect weight data
            if (userWeights != null) {
              userWeights.forEach((key, weightData) {
                DateTime date = DateTime.parse(weightData['date']);
                num value = weightData['value'];
                // Add the data to the weightlist
                weightlist.add({
                  'date': date.toString(),
                  'value': value,
                });
              });
            }
          }
        }
      }
    }

    return weightlist;
  } else {
    // Handle error if the response is not 200 (OK)
    print("Error fetching data: ${response.statusCode}");
    return [];
  }
}



Future<void> addWeightData(String userId, DateTime date, double value) async {
  final url = Uri.parse('${databaseURL}user/user/$userId/weight.json');

  try {
    // Prepare the data to be sent to Firebase
    final Map<String, dynamic> weightData = {
      'date': date.toIso8601String(),
      'value': value,
    };

    // Send a POST request to Firebase to add the weight data
    final response = await http.post(url, body: json.encode(weightData));

    // Handle the response from Firebase
    if (response.statusCode == 200) {
      print("Weight data added successfully.");
    } else {
      print("Failed to add weight data: ${response.statusCode}");
    }
  } catch (e) {
    // Handle any errors
    print("Error adding weight data: $e");
  }
}

Future<List<Map<String, dynamic>>> fetchActivityData(String userId) async {
  print(userId);
  final url = Uri.parse('${databaseURL}user/user/$userId/activity.json');  // Firebase URL for activities

  try {
    final response = await http.get(url);  // Sending GET request to fetch data from Firebase

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<Map<String, dynamic>> activityList = [];

      // Loop through the activity data and extract each one
      data.forEach((activityId, activityData) {
        activityList.add({
          'activityId': activityId,             // Store the activity ID
          'num': activityData['number'],         // Updated to match 'number' field in Firebase
          'date': activityData['date'],          // Date of the activity
        });
      });
      print(activityList);
      return activityList;  // Return the list of activity data
    } else {
      print("Failed to fetch activity data: ${response.statusCode}");
      return [];  // Return empty list if fetch fails
    }
  } catch (e) {
    print("Error fetching activity data: $e");
    return [];  // Return empty list in case of an error
  }
}
