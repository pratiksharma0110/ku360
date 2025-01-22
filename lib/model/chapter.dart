class Chapter {
  final int chapterId;
  final String chapterName; 

  Chapter({required this.chapterName, required this.chapterId});


  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterName: json['chapter'] ?? '',
      chapterId: json['id'] ?? '', 
    );
  }
}
