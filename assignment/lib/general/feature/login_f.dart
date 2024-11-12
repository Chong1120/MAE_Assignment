import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<Map<String, String>?> checkLogin(String username, String password) async 
{
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) 
  {
    final Map<String, dynamic> data = json.decode(response.body);

    for (var category in ['admin', 'coach', 'user']) 
    {
      if (data.containsKey(category)) 
      {
        final userData = data[category];
        
        for (var userId in userData.keys) 
        {
          final user = userData[userId];
          if (user['username'] == username && user['password'] == password) 
          {
            return {'category': category, 'userId': userId};
          }
        }
      }
    }
    
    return null;
  } 
  else 
  {
    throw Exception('Failed to load user data');
  }
}
