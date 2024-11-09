import 'package:http/http.dart' as http;
import 'dart:convert';

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<Map<DateTime, int>> fetchPostCountsByMonth(DateTime month) async {
  final url = Uri.parse('$databaseURL/post.json');
  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("Failed to load data: ${response.statusCode}");
    return {};
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  Map<DateTime, int> postCounts = {};
  DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);

  // Initialize all days of the month to 0
  for (int i = 0; i < DateTime(month.year, month.month + 1, 0).day; i++) {
    postCounts[firstDayOfMonth.add(Duration(days: i))] = 0;
  }

  // Loop through the data to count posts for each day
  for (var entry in data.values) {
    try {
      DateTime postDate = DateTime.parse(entry['datetime']);
      if (postDate.month == month.month && postDate.year == month.year) {
        DateTime dateKey = DateTime(postDate.year, postDate.month, postDate.day);
        postCounts[dateKey] = (postCounts[dateKey] ?? 0) + 1;
      }
    } catch (e) {
      print("Error parsing date: ${entry['datetime']} - $e");
    }
  }

  // Print the post counts to debug  
  return postCounts;
}

Future<Map<DateTime, int>> userActiveLevel(DateTime month) async {
  final url = Uri.parse('$databaseURL/user/user.json');
  final response = await http.get(url);

  if (response.statusCode != 200) {
    print("Failed to load data: ${response.statusCode}");
    return {};
  }

  final data = json.decode(response.body) as Map<String, dynamic>;
  Map<DateTime, int> userCounts = {};

  // Set up the range of days in the specified month
  DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
  DateTime lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

  // Initialize count map for each day of the month
  for (int i = 0; i <= lastDayOfMonth.day - 1; i++) {
    userCounts[firstDayOfMonth.add(Duration(days: i))] = 0;
  }

  // Loop through each user and their activities
  for (var userEntry in data.values) {
    try {
      final activities = userEntry['activity'] as Map<String, dynamic>?;

      if (activities != null) {
        for (var activityEntry in activities.values) {
          // Ensure the activity entry is a map and contains a valid date field
          if (activityEntry is Map<String, dynamic> && activityEntry['date'] != null) {
            try {
              DateTime activityDate = DateTime.parse(activityEntry['date']);

              // Check if the activity date is within the specified month
              if (activityDate.month == month.month && activityDate.year == month.year) {
                DateTime dateKey = DateTime(activityDate.year, activityDate.month, activityDate.day);

                // Increment the count for the specific date
                if (userCounts.containsKey(dateKey)) {
                  userCounts[dateKey] = (userCounts[dateKey] ?? 0) + 1;
                }
              }
            } catch (e) {
              print("Error parsing date for activity: ${activityEntry['date']} - $e");
            }
          }
        }
      } else {
        print("No valid activities found for user or activities are not in the expected format.");
      }
    } catch (e) {
      print("Error parsing user data: $e");
    }
  }

  print(userCounts);
  return userCounts;
}




Future<List<Map<String, dynamic>>> fetchAllCoaches() async {
  final url = Uri.parse('$databaseURL/user/coach.json');
  final response = await http.get(url);
  final data = json.decode(response.body) as Map<String, dynamic>;

  // Convert the data into a list and sort it by 'username'
  List<Map<String, dynamic>> coaches = data.entries.map((e) {
    return {
      'id': e.key,  // Ensure the key is a String
      ...e.value as Map<String, dynamic>,  // Ensure the value is a Map<String, dynamic>
    };
  }).toList();

  // Sort the coaches list by the 'username' field
  coaches.sort((a, b) {
    return a['username'].compareTo(b['username']);  // Sort by 'username'
  });

  return coaches;
}

Future<List<Map<String, dynamic>>> fetchAllUsers() async {
  final url = Uri.parse('$databaseURL/user/user.json');
  final response = await http.get(url);
  final data = json.decode(response.body) as Map<String, dynamic>;

  // Convert the data into a list and sort it by 'username'
  List<Map<String, dynamic>> users = data.entries.map((e) {
    return {
      'id': e.key,  // Ensure the key is a String
      ...e.value as Map<String, dynamic>,  // Ensure the value is a Map<String, dynamic>
    };
  }).toList();

  // Sort the coaches list by the 'username' field
  users.sort((a, b) {
    return a['username'].compareTo(b['username']);  // Sort by 'username'
  });

  return users;
}

Future<void> deleteCoach(String coachId) async {
  final url = Uri.parse('$databaseURL/user/coach/$coachId.json');
  await http.delete(url);
}

Future<void> deleteUser(String userId) async {
  final url = Uri.parse('$databaseURL/user/user/$userId.json');
  await http.delete(url);
}

Future<void> updateUser(String? userId, String username, String gender, String height, String password, String secretPas) async {
  final url = userId == null
      ? Uri.parse('$databaseURL/user/user.json')  // URL for creating a new coach
      : Uri.parse('$databaseURL/user/user/$userId.json');  // URL for updating an existing coach

  final updatedUserData = {
    'username': username,
    'gender': gender,
    'height': height,
    'password': password,
    'secretpas': secretPas,
  };

  try {
    final response = userId == null
        ? await http.post(
            url,
            body: json.encode(updatedUserData),
          ) // Create new coach
        : await http.patch(
            url,
            body: json.encode(updatedUserData),
          ); // Update existing coach

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('User ${userId == null ? 'added' : 'updated'} successfully');
    } else {
      throw Exception('Failed to ${userId == null ? 'add' : 'update'} user');
    }
  } catch (error) {
    throw Exception('Failed to ${userId == null ? 'add' : 'update'} user: $error');
  }
}

Future<void> updateCoach(String? coachId, String username, String gender, String bio, String password, String secretPas) async {
  final url = coachId == null
      ? Uri.parse('$databaseURL/user/coach.json')  // URL for creating a new coach
      : Uri.parse('$databaseURL/user/coach/$coachId.json');  // URL for updating an existing coach

  final updatedCoachData = {
    'username': username,
    'gender': gender,
    'bio': bio,
    'password': password,
    'secretpas': secretPas,
  };

  try {
    final response = coachId == null
        ? await http.post(
            url,
            body: json.encode(updatedCoachData),
          ) // Create new coach
        : await http.patch(
            url,
            body: json.encode(updatedCoachData),
          ); // Update existing coach

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Coach ${coachId == null ? 'added' : 'updated'} successfully');
    } else {
      throw Exception('Failed to ${coachId == null ? 'add' : 'update'} coach');
    }
  } catch (error) {
    throw Exception('Failed to ${coachId == null ? 'add' : 'update'} coach: $error');
  }
}