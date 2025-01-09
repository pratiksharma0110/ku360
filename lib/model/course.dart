class Course {
  final String subCode;
  final String subName;
  final int subCredit;
  final String pdfLink;

  Course({
    required this.subCode,
    required this.subName,
    required this.subCredit,
    required this.pdfLink,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      subCode: json['sub_code'] ?? '',
      subName: json['sub_name'] ?? '',
      subCredit: json['sub_credit'] ?? 0,
      pdfLink: json['pdf_link'] ?? '',
    );
  }
}
