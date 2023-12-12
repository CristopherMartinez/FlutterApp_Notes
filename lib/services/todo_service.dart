import 'dart:convert';

import 'package:http/http.dart' as http;

//All functions for api call is here
class TodoService {
  //function deleteByID
  static Future<bool> deleteById(String id) async {
    //The url
    final url = 'https://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    //Return the response.statusCode
    return response.statusCode == 200;
  }

  //The function for get the first 10 elements
  //We add the symbol "?" for accept null
  static Future<List?> fetchTodos() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      //Return the result, the list of items
      return result;
    } else {
      return null;
    }
  }
}
