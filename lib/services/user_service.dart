
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  // GET: Retrieve a user from DummyJSON.
  Future<User> fetchUser() async {
    final url = Uri.https('dummyjson.com', '/users/1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json =
          jsonDecode(response.body) as Map<String, dynamic>;

      return User.fromJson(json);
    } else {
      throw Exception(
        'Failed to retrieve user: ${response.statusCode}',
      );
    }
  }

  // POST: Send a User object to DummyJSON.
  Future<Map<String, dynamic>> createUser(User user) async {
    final url = Uri.https('dummyjson.com', '/users/add');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body)
          as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to create user: ${response.statusCode}',
      );
    }
  }
}
