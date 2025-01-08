import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/userprofile.dart';
import 'package:ku360/services/shared_pref.dart';

class ProfileService {
  final sharedPref = SharedPrefHelper();
  final String userprofileUrl = dotenv.env['USER_PROFILE'] ?? '';

  Future<UserProfile> fetchUserProfile() async {
    try {
      final token = await sharedPref.getValue('jwt_token');

      final uri = Uri.parse(userprofileUrl);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return UserProfile.fromJson(data);
      } else {
        throw Exception(
          'Failed to load profile. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      throw Exception('Error fetching user profile: $e');
    }
  }
}
