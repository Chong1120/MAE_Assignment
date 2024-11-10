import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<String> searchUser(String userId)async{
  final url = Uri.parse('$databaseURL/user/admin.json');
  final response = await http.get(url);
  final Map<String, dynamic> data = json.decode(response.body);
  
  if (data.containsKey(userId)) {
    final user = data[userId];

    return user['username'];
  }
  else {
    return 'Error';
  }
}