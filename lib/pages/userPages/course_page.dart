import 'package:flutter/material.dart';
import 'package:ku360/model/course.dart';
import 'package:ku360/services/user_service.dart';

class CoursesPage extends StatelessWidget {

  final userService = UserService();

  Future<List<Course>> fetchCourses() async {
    try {
      return await userService.fetchCourses();
    } catch (e) {
      throw Exception('Failed to fetch courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Course>>(
          future: fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading spinner while fetching courses
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if fetching courses fails
              return Center(
                child: Text(
                  'Failed to load courses: ${snapshot.error}',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (snapshot.hasData) {
              final courses = snapshot.data ?? [];

              if (courses.isEmpty) {
                return Center(
                  child: Text(
                    'No courses available.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // Build the GridView if data is successfully fetched
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  mainAxisSpacing: 8, // Space between rows
                  crossAxisSpacing: 8, // Space between columns
                  childAspectRatio: 3 / 3.8, // Smaller cards with good proportions
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  course.subName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                course.subCode,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(
                                      '${course.subCredit} Credits',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (course.pdfLink.isNotEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('PDF link: ${course.pdfLink}'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'View',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              // Handle any unexpected state
              return Center(
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
