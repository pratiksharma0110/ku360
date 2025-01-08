import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:ku360/model/notice.dart';
import 'package:ku360/services/shared_pref.dart';

class UserService {
  final String noticeUrl = dotenv.env['EXAM_NOTICE'] ?? '';
  final String onBoardingUrl = dotenv.env['ONBOARDING_URL'] ?? '';
  final sharedPref = SharedPrefHelper();

  Future<List<Notice>> fetchNotices() async {
    try {
      final token = await sharedPref.getValue("jwt_token");

      final response = await http.get(Uri.parse(noticeUrl), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Notice> notices = data.map((json) {
          final notice = Notice.fromJson(json);
          return notice;
        }).toList();

        return notices;
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> completeOnboarding({
    required String school,
    required String department,
    required int year,
    required int semester,
    String? profileImage,
  }) async {
    final String? jwt = await sharedPref.getValue('jwt_token');
    if (jwt == null) {
      print('No token found');
    }

    final response = await http.post(
      Uri.parse(onBoardingUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt ',
      },
      body: jsonEncode({
        'school': school,
        'department': department,
        'year': year,
        'semester': semester,
        'profile_image': profileImage,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': 'completed successfully'};
    } else {
      return {
        'success': false,
        'data': json.decode(response.body)['message'] ?? 'Unknown error'
      };
    }
  }
}
