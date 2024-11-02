import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<void> saveAnnouncement(String senderName, String dateTime, String title, String content) async {
  final url = Uri.parse('${databaseURL}announcement.json');

  await http.post(url, body: json.encode({
    'sender_name': senderName,
    'date_time': dateTime, // Keep this as a string
    'title': title,
    'content': content,
  }));
}

Future<List<dynamic>> getAnnouncements() async {
  final url = Uri.parse('${databaseURL}announcement.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Convert the entries into a list
    List<Map<String, dynamic>> announcements = data.entries.map((entry) {
      final announcement = entry.value;
      return {
        'id': entry.key,
        'sender_name': announcement['sender_name'],
        'date_time': announcement['date_time'] as String, // Keep date_time as String
        'title': announcement['title'],
        'content': announcement['content'],
      };
    }).toList();

    // Sort the announcements by date_time in descending order
    announcements.sort((a, b) => b['date_time'].compareTo(a['date_time']));

    return announcements;
  } else {
    throw Exception('Failed to load announcements');
  }
}
