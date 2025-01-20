import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/src/response.dart';
import 'package:ku360/model/chapter.dart';
import 'package:ku360/model/attendance.dart';
import 'package:ku360/model/course.dart';
import 'package:ku360/model/notice.dart';
import 'package:ku360/model/routine.dart';
import 'package:ku360/model/userprofile.dart';
import 'package:ku360/services/api.dart';
import 'package:ku360/model/searchResult.dart';
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
  final department = userProfile.department_id.toString();
  final Map<String, String> queryParams = {
    'year_id': year,
    'semester_id': semester,
    'department_id': department,
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
Future<List<SearchResult>> searchResults(String chapName, String courseName) async {
  final String searchUrl = dotenv.env['SEARCH_URL'] ?? '';
  final Map<String, String> queryParams = {
    'chapter_name': chapName,
    'course_name': courseName,
  };

  print('Chapter Name: $chapName');
  print('Course Name: $courseName');
  print('Search URL: $searchUrl');

  try {
    final response = await apiService.publicRequest(
      url: searchUrl,
      queryParams: queryParams,
    );
    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Map the response data to SearchResult objects
      return jsonData.map<SearchResult>((item) {
        // Assuming item has the necessary fields based on your API response
        return SearchResult.fromJson(item);
      }).toList();
    } else {
      print('Failed to fetch search results. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching search results: $e');
    return [];
  }
}


Future<List<Chapter>> sendCourseData(String courseId, String pdfLink) async {
  final String chapterUrl = dotenv.env['CHAPTER_URL'] ?? '';
  if (chapterUrl.isEmpty) {
    throw Exception('Chapter URL is not set.');
  }

  final Map<String, String> queryParams = {
    'course_id': courseId,
    'pdf_link': pdfLink,
  };

  final response = await apiService.publicRequest(
    url: chapterUrl,
    queryParams: queryParams,
  );


  try {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        List<dynamic> data = decoded['data'];

        List<Chapter> chapters = data.map((json) {
          return Chapter.fromJson(json); // Convert each item to a Chapter
        }).toList();

        return chapters;
      } else {
        throw Exception('Unexpected response format: Missing "data" key');
      }
    } else {
      throw Exception('Failed to load courses. Status code: ${response.statusCode}');
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

  Future<List<Attendance>> fetchAttendances() async {
  final String attendanceUrl = dotenv.env['ATTENDANCE_URL'] ?? '';

  try {
    

    
    final response = await apiService.securedRequest(
      attendanceUrl,
      
    );

    if (response.statusCode == 200) {
      
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
     
        List<dynamic> data = decoded['data'];

      
        List<Attendance> attendances = data.map((json) {
          return Attendance.fromJson(json);
        }).toList();

      
        return attendances;
      } else {
      
        throw Exception('Unexpected response format: Missing "data" key');
      }
    } else {
      
      throw Exception(
          'Failed to fetch attendance. Status code: ${response.statusCode}');
    }
  } catch (e) {
   
    print('Error fetching attendances: $e');
    throw Exception('Error fetching attendances');
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
