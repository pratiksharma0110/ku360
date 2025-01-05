import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String registerUrl = dotenv.env['REGISTER_URL'] ?? '';
  final String loginUrl = dotenv.env['LOGIN_URL'] ?? '';

  Future<Map<String, dynamic>> register(
      {String? firstname,
      String? lastname,
      String? email,
      String? password}) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'],
        };
      }
    } catch (err) {
      print("Error: $err");
      return {
        'success': false,
        'message': 'Error connecting to the server',
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token =
            responseBody['token']; //backend is sending cookie as token in json

        return {
          'success': true,
          'data': responseBody['message'],
        };
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'],
        };
      }
    } catch (err) {
      print("Error: $err");
      return {
        'success': false,
        'message': 'Error connecting to the server',
      };
    }
  }
}
