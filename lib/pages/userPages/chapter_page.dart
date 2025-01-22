import 'package:flutter/material.dart';
import 'package:ku360/model/topic.dart';
import 'package:ku360/services/user_service.dart';
import 'package:ku360/model/chapter.dart';
import 'package:ku360/pages/userPages/result_page.dart';

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
  final Map<int, Future<List<Topic>>> _topicsCache = {};

  @override
  void initState() {
    super.initState();
    futureChapters = fetchChapters();
  }

  Future<List<Chapter>> fetchChapters() async {
    try {
      final chapters = await widget.userService.sendCourseData(widget.courseId, widget.pdfLink);
      return chapters;
    } catch (e) {
      throw Exception('Failed to fetch chapters: $e');
    }
  }

  Future<List<Topic>> fetchTopics(int chapterId) async {
    if (_topicsCache.containsKey(chapterId)) {
      return _topicsCache[chapterId]!;
    }

    final topicsFuture = widget.userService.sendChapterData(chapterId);
    _topicsCache[chapterId] = topicsFuture;
    return topicsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapters for ${widget.courseName}'),
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

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(chapter.chapterName),
                    children: [
                      // Add chapter name as the first clickable item
                      ListTile(
                        title: Text(
                          'View entire chapter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsPage(
                                topicName: null, 
                                chapterName: chapter.chapterName,
                                courseName: widget.courseName,
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(), 
                      FutureBuilder<List<Topic>>(
                        future: fetchTopics(chapter.chapterId),
                        builder: (context, topicSnapshot) {
                          if (topicSnapshot.connectionState == ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (topicSnapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Error loading topics: ${topicSnapshot.error}'),
                            );
                          }

                          if (!topicSnapshot.hasData || topicSnapshot.data!.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('No topics available for this chapter.'),
                            );
                          }

                          final topics = topicSnapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: topics.length,
                            itemBuilder: (context, index) {
                              final topic = topics[index];
                              return ListTile(
                                title: Text(topic.topicName),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchResultsPage(
                                        topicName: topic.topicName,
                                        chapterName: chapter.chapterName,
                                        courseName: widget.courseName,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
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