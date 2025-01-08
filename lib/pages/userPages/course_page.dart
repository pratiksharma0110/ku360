import 'package:flutter/material.dart';
import 'package:ku360/model/course.dart';

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Course> courses = Course.fetchCourses();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
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
                        SizedBox(height: 8),
                        Text(
                          'Instructor: ${course.instructorName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Attendance: ${course.attendance}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: course.attendance < 80
                                ? Colors.red // Red for attendance < 80
                                : Colors.green, // Green for attendance ≥ 80
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
                                      content:
                                          Text('PDF link: ${course.pdfLink}'),
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
        ),
      ),
    );
  }
}

