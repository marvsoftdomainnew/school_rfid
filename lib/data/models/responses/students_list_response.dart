class StudentsListResponse {
  final bool success;
  final String? message;
  final List<StudentRecord> records;

  StudentsListResponse({
    required this.success,
    this.message,
    required this.records,
  });

  factory StudentsListResponse.fromJson(Map<String, dynamic> json) {
    return StudentsListResponse(
      success: json['success'] == true,
      message: json['message'],
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => StudentRecord.fromJson(e))
          .toList() ??
          [],
    );
  }
}
class StudentRecord {
  final int? id;
  final int? schoolId;
  final int? staffId;
  final int? studentId;

  final String? name;
  final String? fatherName;
  final String? motherName;
  final String? studentClass;
  final String? section;
  final String? mobileNumber;
  final String? rfidNumber;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentRecord({
    this.id,
    this.schoolId,
    this.staffId,
    this.studentId,
    this.name,
    this.fatherName,
    this.motherName,
    this.studentClass,
    this.section,
    this.mobileNumber,
    this.rfidNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      id: _toInt(json['id']),
      schoolId: _toInt(json['school_id']),
      staffId: _toInt(json['staff_id']),
      studentId: _toInt(json['student_id']),

      name: json['name'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      studentClass: json['class'], // ⚠️ keyword handled safely
      section: json['section'],
      mobileNumber: json['mobile_number'],
      rfidNumber: json['rfid_number'],

      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  // ================= SAFE PARSERS =================

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
