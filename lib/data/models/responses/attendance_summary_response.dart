class AttendanceSummaryResponse {
  final bool success;
  final int? student;
  final int? staff;
  final int? presentStudent;
  final int? presentStaff;
  final int? absentStudent;
  final int? absentStaff;

  AttendanceSummaryResponse({
    required this.success,
    this.student,
    this.staff,
    this.presentStudent,
    this.presentStaff,
    this.absentStudent,
    this.absentStaff,
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
    );
  }

  /// Handles int, string, null safely
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
