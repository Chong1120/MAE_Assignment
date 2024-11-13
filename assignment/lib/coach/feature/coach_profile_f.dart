import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<String> searchUser(String userId,String category)async{
  final url = Uri.parse('$databaseURL/user/coach.json');
  final response = await http.get(url);
  final Map<String, dynamic> data = json.decode(response.body);
  
  if (data.containsKey(userId)) {
    final user = data[userId];
    print(userId);
    print(user[category]);
    return user[category];
  }
  else {
    return 'Error';
  }
}

Future<void> saveNewUser(String? userId, String username, String gender, String bio, String password, String secretpas) async{
  final url = Uri.parse('$databaseURL/user/coach/$userId.json');

  final userData = {
    'username': username,
    'gender': gender,
    'bio': bio,
    'password': password,
    'secretpas': secretpas
  };

  try {
    await http.patch(url, body: json.encode(userData));
  }
  catch (error){
    throw Exception('$error');
  }
}