import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'shared_pref.dart';

class AuthService {
 
  

  Future<Map<String, dynamic>> register(
      {String? firstname,
      String? lastname,
      String? email,
      String? password}) async {
    try {
       final String registerUrl = dotenv.env['REGISTER_URL'] ?? '';
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
      final String loginUrl = dotenv.env['LOGIN_URL'] ?? '';
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
        final sharedPref = SharedPrefHelper();
        await sharedPref.saveValue('jwt_token', responseBody['token']);

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


   Future<void> sendOtp(String email) async {
    final String otpUrl = dotenv.env['SEND_OTP'] ?? '';
    final url = Uri.parse(otpUrl);
    print("ya xa");
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        print('OTP sent successfully');
      } else {
        throw Exception('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }

  
   Future<bool> verifyOtp(String email, String otp) async {
    final String verifyUrl = dotenv.env['VERIFY_OTP'] ?? '';
    final url = Uri.parse(verifyUrl);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        throw Exception('Failed to verify OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }
}