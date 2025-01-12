class Chapter {
  final String chapterName; 

  Chapter({required this.chapterName});


  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterName: json['chapter'] ?? '', 
    );
  }
}
