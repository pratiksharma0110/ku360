import 'package:ku360/model/on_boarding_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'on_boarding_notifier.g.dart';

@riverpod
class SchoolNotifier extends _$SchoolNotifier {
  static final School _unselected = School(name: 'Unselected', shortName: '');
  @override
  School build() {
    return _unselected;
  }

  //method to add:
  void add(School school) {
    if (state != school) {
      state = school;
      print('${school.name} selected');
    } else {
      state = _unselected;
      print('${school.name} unselected');
    }
  }
}

@riverpod
class DepartmentNotifier extends _$DepartmentNotifier {
  static final Department defaultValue = Department(
    name: "Computer Science and Engineering",
    id: 1,
    shortName: "CSE",
    image: 'assets/images/soe.png',
  );
  @override
  Department build() {
    return defaultValue;
  }

  void add(Department department) {
    if (state != department) {
      state = department;
      print('${department.name} selected');
    }
  }
}

@riverpod
class YearNotifier extends _$YearNotifier {
  static final int _defaultYear = 1;

  @override
  int build() {
    return _defaultYear;
  }

  void select(int year) {
    if (state != year) {
      state = year;
      print('Year $year selected');
    }
  }
}

@riverpod
class SemesterNotifier extends _$SemesterNotifier {
  static final int _defaultSemester = 1;

  @override
  int build() {
    return _defaultSemester;
  }

  void select(int semester) {
    if (state != semester) {
      state = semester;
      print('Semester $semester selected');
    }
  }
}
