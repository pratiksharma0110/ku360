import 'package:flutter/material.dart';
import 'package:ku360/model/course.dart';
import 'package:ku360/services/user_service.dart';
import 'chapter_page.dart'; 

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
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
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

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3 / 3.8,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () async {
                          try {
                          
                            await userService.sendCourseData(course.subId.toString(), course.pdfLink);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChaptersPage(
                                  courseId: course.subId.toString(),
                                  pdfLink: course.pdfLink,
                                  courseName: course.subName, 
                                ),
                              ),
                            );
                          } catch (e) {
                        
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error sending course data: $e'),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                        ),
                      );
                    },
                  );
                },
              );
            } else {
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
