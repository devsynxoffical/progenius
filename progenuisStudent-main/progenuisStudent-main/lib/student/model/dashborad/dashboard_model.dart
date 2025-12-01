import 'dart:ui';

class StudentStats {
  final int totalStudents;
  final int premiumStudents;
  final int freeStudents;

  StudentStats({
    required this.totalStudents,
    required this.premiumStudents,
    required this.freeStudents,
  });

  List<PieData> toPieData() {
    return [
      PieData('Premium', premiumStudents.toDouble(), const Color(0xFF4CAF50)),
      PieData('Free', freeStudents.toDouble(), const Color(0xFFF44336)),
    ];
  }

  factory StudentStats.fromJson(Map<String, dynamic> json) {
    return StudentStats(
      totalStudents: json['totalStudents'] ?? 0,
      premiumStudents: json['paidStudentsCount'] ?? 0,
      freeStudents: json['freeStudentsCount'] ?? 0,
    );
  }

  static StudentStats fromApiResponse(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return StudentStats.fromJson(data);
  }
}

class PieData {
  final String label;
  final double value;
  final Color color;

  PieData(this.label, this.value, this.color);
}