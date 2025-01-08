import 'package:flutter/material.dart';
import 'package:ku360/model/notice.dart';
import 'package:ku360/pages/pdf_viewer.dart';
import 'package:ku360/services/user_service.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final userService = UserService();
  late Future<List<Notice>> futureNotices;

  @override
  void initState() {
    super.initState();
    futureNotices = userService.fetchNotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 60),
          ),
          Expanded(
            child: FutureBuilder(
                future: futureNotices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load notices'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No notices available'));
                  } else {
                    List<Notice> notices = snapshot.data!;
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: ListView.builder(
                          itemCount: notices.length,
                          itemBuilder: (context, index) {
                            Notice notice = notices[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Card.filled(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  title: Text(
                                    notice.title,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(notice.date),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PdfViewer(
                                          pdfUrl: notice.downloadLink),
                                    ));
                                  },
                                ),
                              ),
                            );
                          }),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
