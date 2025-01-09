class Routine {
  final String time;
  final String subCode;
  final String subName;

  Routine({required this.time, required this.subCode, required this.subName});

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      time: json['time'],
      subCode: json['sub_code'],
      subName: json['sub_name'],
    );
  }
}
