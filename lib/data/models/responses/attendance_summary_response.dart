class AttendanceSummaryResponse {
  final bool success;
  final int? student;
  final int? staff;
  final int? presentStudent;
  final int? presentStaff;
  final int? absentStudent;
  final int? absentStaff;
  final int? late;           // overall (optional use)
  final int? lateStaff;
  final int? lateStudent;

  AttendanceSummaryResponse({
    required this.success,
    this.student,
    this.staff,
    this.presentStudent,
    this.presentStaff,
    this.absentStudent,
    this.absentStaff,
    this.late,
    this.lateStaff,
    this.lateStudent,
  });

  factory AttendanceSummaryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryResponse(
      success: json['success'] == true,
      student: _toInt(json['student']),
      staff: _toInt(json['staff']),
      presentStudent: _toInt(json['presentstudent']),
      presentStaff: _toInt(json['presentstaff']),
      absentStudent: _toInt(json['absentstudent']),
      absentStaff: _toInt(json['absentstaff']),
      late: _toInt(json['late']),
      lateStaff: _toInt(json['latestaff']),
      lateStudent: _toInt(json['latestudent']),
    );
  }

  /// Handles int, string, null safely
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
