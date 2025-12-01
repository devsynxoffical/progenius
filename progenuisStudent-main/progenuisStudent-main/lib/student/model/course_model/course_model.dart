class FreeCourse {
  final String? id;
  final String? courseImage;
  final String? title;
  final String? description;
  final String? status;
  final double? noOfStudents;
  final String? destination;
  final List<dynamic>? customers;
  final List<Student>? students; // ✅ Handle students properly
  final int? version;

  FreeCourse({
    this.id,
    this.courseImage,
    this.title,
    this.description,
    this.status,
    this.noOfStudents,
    this.destination,
    this.customers,
    this.students,
    this.version,
  });

  factory FreeCourse.fromJson(Map<String, dynamic> json) {
    return FreeCourse(
      id: json['_id'] as String?,
      courseImage: json['courseImage'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      noOfStudents: (json['noOfStudents'] as num?)?.toDouble(),
      destination: json['destination'] ?? "",
      customers: json['customers'] as List<dynamic>?,
      
      // ✅ Handle both `List<String>` and `List<Map<String, dynamic>>` for `students`
      students: (json['students'] as List<dynamic>?)
          ?.map((student) {
            if (student is Map<String, dynamic>) {
              return Student.fromJson(student); // PAID courses
            } else if (student is String) {
              return Student(id: student); // UNPAID courses (only contains student IDs)
            } else {
              return null;
            }
          })
          .whereType<Student>()
          .toList(),

      version: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'courseImage': courseImage,
      'title': title,
      'description': description,
      'status': status,
      'noOfStudents': noOfStudents,
      'destination': destination,
      'customers': customers,
      'students': students?.map((student) => student.toJson()).toList(),
      '__v': version,
    };
  }
}



class Student {
  final String? id;
  final String? fullName;
  final String? email;

  Student({
    this.id,
    this.fullName,
    this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
    };
  }
}



