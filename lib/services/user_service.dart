import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ku360/model/course.dart';
import 'package:ku360/model/notice.dart';
import 'package:ku360/model/routine.dart';
import 'package:ku360/model/userprofile.dart';
import 'package:ku360/services/api.dart';

class UserService {
  final apiService = ApiService();
  Future<bool> verifyToken() async {
    final verifyUrl = dotenv.env['VERIFY'] ?? '';
    try {
      final response = await apiService.securedRequest(verifyUrl);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['valid'] == true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during token verification: $e');
      return false;
    }
  }

  Future<bool> checkOnboardingStatus() async {
    final String onboardingUrl = dotenv.env['ONBOARDING_STATUS'] ?? '';
    try {
      final response = await apiService.securedRequest(onboardingUrl);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        return responseBody['on_boarding'] == true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking onboarding status: $e');
      throw Exception('Error checking onboarding status');
    }
  }

  Future<UserProfile> fetchUserProfile() async {
    final String userprofileUrl = dotenv.env['USER_PROFILE'] ?? '';
    try {
      final response = await apiService.securedRequest(userprofileUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return UserProfile.fromJson(data);
      } else {
        throw Exception(
          'Failed to load profile. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  Future<List<Course>> fetchCourses() async {
    final String courseUrl = dotenv.env['COURSE_URL'] ?? '';
    final userProfile = await fetchUserProfile();
    final year = userProfile.year.split(' ')[1];
    final semester = userProfile.semester.split(' ')[1];

    final Map<String, String> queryParams = {
      'year_id': year,
      'semester_id': semester,
    };

    try {
      final response = await apiService.publicRequest(
        url: courseUrl,
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          List<dynamic> data = decoded['data'];

          List<Course> courses = data.map((json) {
            return Course.fromJson(json);
          }).toList();

          return courses;
        } else {
          throw Exception('Unexpected response format: Missing "data" key');
        }
      } else {
        throw Exception(
            'Failed to load courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error fetching courses: $e");
    }
  }

  Future<List<Routine>> fetchRoutine() async {
    final String routineUrl = dotenv.env['ROUTINE_URL'] ?? '';

    final userProfile = await fetchUserProfile();
    final year = userProfile.year.split(' ')[1];
    final semester = userProfile.semester.split(' ')[1];
    final department = userProfile.department_id.toString();
    final Map<String, String> queryParams = {
      'year_id': year,
      'semester_id': semester,
      'department_id': department,
    };
   


    try {
      final response = await apiService.publicRequest(
          url: routineUrl, queryParams: queryParams);
          


      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          List<dynamic> data = decoded['data'];

          List<Routine> routine = data.map((json) {
            return Routine.fromJson(json);
          }).toList();

          return routine;
        } else {
          throw Exception('Unexpected response format: Missing "data" key');
        }
      } else {
        throw Exception(
            'Failed to load classes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error fetching courses: $e");
    }
  }

  Future<List<Notice>> fetchNotices() async {
    final String noticeUrl = dotenv.env['EXAM_NOTICE'] ?? '';
    try {
      final response = await apiService.securedRequest(noticeUrl);

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
    final String onBoardingUrl = dotenv.env['ONBOARDING_URL'] ?? '';
    try {
      final response = await apiService.securedRequest(
        onBoardingUrl,
        method: 'POST',
        body: {
          'school': school,
          'department': department,
          'year': year,
          'semester': semester,
          'profile_image': profileImage,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': 'Completed successfully',
        };
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Unknown error';
        return {
          'success': false,
          'data': errorMessage,
        };
      }
    } catch (e) {
      print('Error during onboarding: $e');
      return {
        'success': false,
        'data': 'Error connecting to the server',
      };
    }
  }
}
