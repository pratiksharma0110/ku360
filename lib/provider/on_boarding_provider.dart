import 'package:ku360/model/on_boarding_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'on_boarding_provider.g.dart';

const List<School> allSchool = [
  School(
    name: "School of Engineering",
    shortName: "SOE",
    image: 'assets/images/soe.png',
  ),
  School(
    name: "School of Science",
    shortName: "SOS",
    image: 'assets/images/sos.png',
  ),
];

const List<Department> allDepartment = [
  Department(
    name: "Computer Science and Engineering",
    shortName: "CSE",
    image: 'assets/images/soe.png',
  ),
  Department(
    name: "Mechanical",
    shortName: "Mech",
    image: 'assets/images/sos.png',
  ),
  Department(
    name: "Civil",
    shortName: "CIEG",
    image: 'assets/images/sos.png',
  ),
  Department(
    name: "Electrical",
    shortName: "EEE",
    image: 'assets/images/sos.png',
  ),
  Department(
    name: "Geomatics",
    shortName: "GE",
    image: 'assets/images/sos.png',
  ),
  Department(
    name: "Architecture",
    shortName: "Arch",
    image: 'assets/images/sos.png',
  ),
  Department(
    name: "Environemnt Science and Engineering",
    shortName: "ESE",
    image: 'assets/images/sos.png',
  ),
];
const List<int> allYears = [1, 2, 3, 4];

const List<int> allSemesters = [1, 2];

@riverpod
List<int> years(ref) {
  return allYears;
}

@riverpod
List<int> semesters(ref) {
  return allSemesters;
}

@riverpod
List<School> schools(ref) {
  return allSchool;
}

@riverpod
List<Department> departments(ref) {
  return allDepartment;
}
