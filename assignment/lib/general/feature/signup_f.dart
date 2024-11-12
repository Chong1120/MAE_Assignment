import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<bool> saveNewUser(String? userId, String username, String gender, String height, String password, String secretpas) async {
  final url = Uri.parse('$databaseURL/user/user.json');

  final userData = {
    'username': username,
    'gender': gender,
    'height': height,
    'password': password,
    'secretpas': secretpas
  };

  try {
    final response = await http.post(url, body: json.encode(userData));
    return response.statusCode == 200;
  } catch (error) {
    print(error); // Optionally handle error better or log somewhere
    return false;
  }
}
