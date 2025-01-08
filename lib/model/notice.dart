class Notice {
  final String title;
  final String date;
  final String downloadLink;

  Notice({required this.title, required this.date, required this.downloadLink});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      title: json['title'] ?? "title",
      date: json['date'] ?? "date ",
      downloadLink: json['link'] ?? "link ",
    );
  }
}
