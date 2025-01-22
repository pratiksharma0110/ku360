import 'package:flutter/material.dart';
import 'package:ku360/model/searchResult.dart';
import 'package:ku360/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResultsPage extends StatelessWidget {
  final String chapterName;
  final String courseName;
  final String? topicName;
  final userService = UserService();

  SearchResultsPage({
    super.key,
    required this.chapterName,
    required this.courseName,
    this.topicName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder<List<SearchResult>>(
        future: userService.searchResults(topicName, chapterName, courseName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No results found.'),
            );
          }

          final results = snapshot.data!;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: result.thumbnail.isNotEmpty
                      ? Image.network(
                          result.thumbnail,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.link, size: 50),
                  title: Text(
                    result.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(result.snippet),
                  trailing: result.isVideo
                      ? const Icon(Icons.play_circle_fill, color: Colors.red)
                      : null,
                  onTap: () => _openLink(context, result.link),
                ),
              );
            },
          );
        },
      ),
    );
  }

 Future<void> _openLink(BuildContext context, String url) async {
  if (url.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("URL is empty")),
    );
    return;
  }

  try {
    final Uri uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot open this link")),
        );
      }
      return;
    }

    final bool confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Open Link'),
            content: Text('Do you want to open this link?\n\n$url'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      // Launch the URL in an external browser
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening URL: $e")),
      );
    }
  }
}
}