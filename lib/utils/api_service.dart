import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update base URL to your machine's IP address for testing on physical devices
  static const String baseUrl = "http://localhost:5000/api/";

  /// Sends an OTP to the given email
  static Future<void> sendOtp(String email) async {
    final url = Uri.parse("$baseUrl/send-otp");
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

  /// Verifies the given OTP for the email
  static Future<bool> verifyOtp(String email, String otp) async {
    final url = Uri.parse("$baseUrl/verify-otp");
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
