class School {
  final String name;
  final String shortName;
  final String? image;

  const School({
    required this.name,
    required this.shortName,
    this.image,
  });
}

class Department {
  final String name;
  final int id;
  final String shortName;
  final String? image;

  const Department({required this.name,required this.id, required this.shortName, this.image});
}

class Year {
  final int value;

  Year(this.value) {
    if (value < 1 || value > 5) {
      throw ArgumentError('Year must be between 1 and 5.');
    }
  }

  @override
  String toString() => 'Year $value';
}

class Semester {
  final int value;

  Semester(this.value) {
    if (value < 1 || value > 2) {
      throw ArgumentError('Semester must be 1 or 2.');
    }
  }

  @override
  String toString() => 'Semester $value';
}
