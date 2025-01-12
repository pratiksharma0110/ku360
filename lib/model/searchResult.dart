class SearchResult {
  final String title;
  final String link;
  final String snippet;
  final String thumbnail;
  final bool isVideo;

  // Constructor
  SearchResult({
    required this.title,
    required this.link,
    required this.snippet,
    required this.thumbnail,
    required this.isVideo,
  });

  // Factory method to create a SearchResult from JSON
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] ?? 'No Title', // Default to 'No Title' if null
      link: json['link'] ?? '',
      snippet: json['snippet'] ?? 'No Description', // Default to 'No Description' if null
      thumbnail: json['thumbnail'] ?? '', // Fallback to empty string if no thumbnail
      isVideo: json['isVideo'] ?? false, // Default to false if not provided
    );
  }
}
