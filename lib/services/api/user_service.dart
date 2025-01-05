import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ku360/model/notice.dart';

class UserService {
  Future<List<Notice>> fetchNotices() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.69:5000/getNotice'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Notice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notices');
    }
  }

  Future<void> completeOnboarding({
    required String userId,
    required String school,
    required String department,
    required int year,
    required int semester,
    String? profileImage,
  }) async {
    final url = 'http://192.168.1.69:5000/onBoarding';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userId',
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
      print('Onboarding completed successfully');
    } else {
      final error = json.decode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to complete onboarding: $error');
    }
  }
}

