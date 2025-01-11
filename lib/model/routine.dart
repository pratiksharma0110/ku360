class Routine {
  final String time;
  final String subCode;
  final String subName;
  final String instructor;

  Routine({required this.time, required this.subCode, required this.subName,required this.instructor});

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      time: json['time'],
      subCode: json['sub_code'],
      subName: json['sub_name'],
      instructor: json['instructor_name']
    );
  }
}
