import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<void> saveNewUser(String? userId, String username, String gender, String height, String password, String secretpas) async{
  final url = Uri.parse('$databaseURL/user/user.json');

  final userData = {
    'username': username,
    'gender': gender,
    'height': height,
    'password': password,
    'secretpas': secretpas
  };

  try {
    await http.post(url, body: json.encode(userData));
  }
  catch (error){
    throw Exception('$error');
  }
}