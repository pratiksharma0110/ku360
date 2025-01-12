class Course {
  final  int subId; 
  final String subCode;
  final String subName;
  final int subCredit;
  final String pdfLink;

  Course({
    required this.subId,
    required this.subCode,
    required this.subName,
    required this.subCredit,
    required this.pdfLink,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      subId: json['id'] ?? 0,
      subCode: json['subject_code'] ?? '',
      subName: json['subject'] ?? '',
      subCredit: json['credit'] ?? 0,
      pdfLink: json['pdf_link'] ?? '',
    );
  }
}
