class Attendance {
  final String sub_code;
  final String total_classes;
  final String attended_classes;
  final String attended_percentage;
  
  
  

  Attendance({
    required this.sub_code,
    required this.total_classes,
    required this.attended_classes,
    required this.attended_percentage
    
 
    
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(sub_code: json['course_id']??'', 
    total_classes: json['total_classes'] ??'', 
    attended_classes: json['attended_classes']??'', 
    attended_percentage: json['attendance_percentage'] ??''
      
    );
  }
}
