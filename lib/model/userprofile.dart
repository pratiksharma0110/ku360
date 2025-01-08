class UserProfile {
  final String profileImageUrl;
  final String name;
  final String email;
  final String department;
  final String school;
  final String year;
  final String semester;

  UserProfile(
      {required this.profileImageUrl,
      required this.name,
      required this.email,
      required this.department,
      required this.school,
      required this.year,
      required this.semester});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        profileImageUrl: json['profile_image'] ?? '',
        name: json['full_name'] ?? '',
        email: json['email'] ?? '',
        school: json['school'] ?? '',
        department: json['department'] ?? '',
        year: json['year_name'] ?? ' ',
        semester: json['semester_name'] ?? ' ');
  }
}
