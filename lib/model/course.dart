class Course {
  final String subCode;
  final String subName;
  final int subCredit;
  final String pdfLink;
  final String instructorName; 
  final int attendance; 

  Course({
    required this.subCode,
    required this.subName,
    required this.subCredit,
    required this.pdfLink,
    required this.instructorName,
    required this.attendance,
  });

//call api and return from db: 
  static List<Course> fetchCourses() {
    return [
      Course(
        subCode: 'MATH 101',
        subName: 'Calculus and Linear Algebra',
        subCredit: 3,
        pdfLink: 'https://example.com/math101.pdf',
        instructorName: 'Dr. Dummy', // Dummy instructor
        attendance: 85, // Dummy attendance
      ),
      Course(
        subCode: 'PHYS 101',
        subName: 'General Physics I',
        subCredit: 3,
        pdfLink: 'https://example.com/phys101.pdf',
        instructorName: 'Dr. Dummy',
        attendance: 90,
      ),
      Course(
        subCode: 'COMP 102',
        subName: 'Computer Programming',
        subCredit: 3,
        pdfLink: 'https://example.com/comp102.pdf',
        instructorName: 'Dr. Dummy',
        attendance: 80,
      ),
      Course(
        subCode: 'ENGG 111',
        subName: 'Elements of Engineering I',
        subCredit: 3,
        pdfLink: 'https://example.com/engg111.pdf',
        instructorName: 'Dr. Dummy',
        attendance: 95,
      ),
      Course(
        subCode: 'CHEM 101',
        subName: 'General Chemistry',
        subCredit: 2,
        pdfLink: 'https://example.com/chem101.pdf',
        instructorName: 'Dr. Dummy',
        attendance: 75,
      ),
    ];
  }
}

