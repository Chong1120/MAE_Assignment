import 'dart:convert';
import 'package:http/http.dart' as http;

const String databaseURL = 'https://fitness-app-490b6-default-rtdb.asia-southeast1.firebasedatabase.app/';

Future<bool> checkSecretWord(String username, String secretWord) async 
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
          if (user['username'] == username && user['secretpas'] == secretWord) 
          {
            return true;
          }
        }
      }
    }
    return false;
  } 
  else 
  {
    throw Exception('Failed to load user data');
  }
}

Future<void> updatePassword(String username, String newPassword) async 
{
  final url = Uri.parse('${databaseURL}user.json');
  final response = await http.get(url);

  if (response.statusCode == 200) 
  {
    final Map<String, dynamic> data = json.decode(response.body);

    String category = '';
    String userId = '';

    for (var cat in ['admin', 'coach', 'user']) 
    {
      if (data.containsKey(cat)) 
      {
        final userData = data[cat];
        for (var id in userData.keys) 
        {
          if (userData[id]['username'] == username) 
          {
            category = cat;
            userId = id;
            break;
          }
        }
      }
      if (category.isNotEmpty && userId.isNotEmpty) break;
    }

    if (category.isNotEmpty && userId.isNotEmpty) 
    {
      final userUpdateUrl = Uri.parse('${databaseURL}user/$category/$userId.json');
      final updateResponse = await http.patch
      (
        userUpdateUrl,
        body: json.encode({'password': newPassword}),
      );

      if (updateResponse.statusCode == 200) 
      {

      } 
      else 
      {
        throw Exception('Failed to update password');
      }
    } 
    else 
    {
      throw Exception('User or User ID not found');
    }
  } 
  else 
  {
    throw Exception('Failed to load user data');
  }
}
