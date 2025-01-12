import 'package:flutter/material.dart';
import 'package:ku360/services/user_service.dart';
import 'package:ku360/model/chapter.dart';
import 'package:ku360/pages/userPages/result_page.dart'; // Ensure this is the correct path to the SearchResultsPage

class ChaptersPage extends StatefulWidget {
  final String courseId;
  final String pdfLink;
  final String courseName;
  final userService = UserService();

  ChaptersPage({
    super.key,
    required this.courseId,
    required this.pdfLink,
    required this.courseName,
  });

  @override
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  late Future<List<Chapter>> futureChapters;

  @override
  void initState() {
    super.initState();
    // Initialize the futureChapters variable when the page loads
    futureChapters = fetchCourses();
  }

  Future<List<Chapter>> fetchCourses() async {
    try {
      // Fetch the courses using the sendCourseData method
      final chapters = await widget.userService.sendCourseData(widget.courseId, widget.pdfLink);
      print(chapters); // Debug: Print the list of chapters to check if chapterName is present
      return chapters;
    } catch (e) {
      throw Exception('Failed to fetch chapters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters for ${widget.courseName}'), // Display course name in the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Chapter>>(
          future: futureChapters,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No chapters available.'));
            }

            final chapters = snapshot.data!;

            return ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                print(chapter.chapterName); 

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(chapter.chapterName), 
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(
                            chapterName: chapter.chapterName,
                            courseName: widget.courseName,
                          ),
                        ),
                      );
                    },
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
