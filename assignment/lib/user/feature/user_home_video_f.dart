import 'dart:convert';
import 'package:http/http.dart' as http;

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
