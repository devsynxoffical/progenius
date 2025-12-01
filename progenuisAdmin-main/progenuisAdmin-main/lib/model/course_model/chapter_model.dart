// class Chapter {
// final String? id;
//   final String title;
//   final String description;
//   final String courseId;
//   final bool isLocked;

//   Chapter({
//   this.id,
//     required this.title,
//     required this.description,
//     required this.courseId,
//     required this.isLocked,
//   });

//   factory Chapter.fromJson(Map<String, dynamic> json) {
//     return Chapter(
//        id: json['_id']?.toString(),
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       courseId: json['course'] ?? '',
//       isLocked: json['isLocked'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "title": title,
//       "description": description,
//       "isLocked": isLocked,
//       "course": courseId,
//     };
//   }
// }


class Chapter {
  final String? id;
  final String? title;
  final String? description;
  final bool? isLocked;
  final String? courseId;

  Chapter({
    this.id,
    this.title,
    this.description,
    this.isLocked,
    this.courseId,
  });

  /// ✅ **Factory Constructor for Safe JSON Parsing**
  factory Chapter.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Chapter();

    return Chapter(
      id: json['_id']?.toString(),
      title: json['title'] ?? "No Title",
      description: json['description'] ?? "No Description",
      isLocked: json['isLocked'] ?? false,
      courseId: json['course']?.toString() ?? "",
    );
  }

  /// ✅ **Convert to JSON**
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "isLocked": isLocked,
      "course": courseId,
    };
  }

  /// ✅ **CopyWith Method to Modify Fields**
  Chapter copyWith({
    String? id,
    String? title,
    String? description,
    bool? isLocked,
    String? course,
  }) {
    return Chapter(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isLocked: isLocked ?? this.isLocked,
      courseId: course ?? this.courseId,
    );
  }
}


// class Chapter {
//   final String? id;
//   final String? title;
//   final String? description;
//   final bool? isLocked;
//   final String? course;

//   Chapter({
//     this.id,
//     this.title,
//     this.description,
//     this.isLocked,
//     this.course,
//   });

//   /// ✅ **Factory Constructor for Safe JSON Parsing**
//   factory Chapter.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Chapter();

//     return Chapter(
//       id: json['_id']?.toString(),
//       title: json['title'] ?? "No Title",
//       description: json['description'] ?? "No Description",
//       isLocked: json['isLocked'] ?? false,
//       course: json['course']?.toString() ?? "",
//     );
//   }

//   /// ✅ **Convert to JSON**
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id,
//       "title": title,
//       "description": description,
//       "isLocked": isLocked,
//       "course": course,
//     };
//   }
// }
