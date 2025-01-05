class Notice {
  final String title;
  final String date;
  final String downloadLink;

  Notice({required this.title, required this.date, required this.downloadLink});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      title: json['title'],
      date: json['date'],
      downloadLink: json['downloadLink'],
    );
  }
}
