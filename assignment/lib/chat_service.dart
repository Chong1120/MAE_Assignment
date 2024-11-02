import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode and jsonDecode

class ChatService {
  final String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

  // Add message to the database
  Future<void> addMessage(String message) async {
    final url = Uri.parse('$databaseURL/messages.json'); // Adjust endpoint as necessary

    await http.post(
      url,
      body: json.encode({
        'text': message,
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );
  }

  // Fetch messages from the database
  Future<List<dynamic>> fetchMessages() async {
    final url = Uri.parse('$databaseURL/messages.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData.values.toList(); // Convert to List
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
