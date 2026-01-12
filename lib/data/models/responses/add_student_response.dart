class AddStudentResponse {
  final bool success;
  final Student? student;
  final String? message;

  AddStudentResponse({
    required this.success,
    this.student,
    this.message,
  });

  factory AddStudentResponse.fromJson(Map<String, dynamic> json) {
    return AddStudentResponse(
      success: json['success'] == true,
      student:
      json['student'] != null ? Student.fromJson(json['student']) : null,
      message: json['message'],
    );
  }
}
class Student {
  final int? studentId;
  final String name;
  final String? fatherName;
  final String? motherName;
  final String? studentClass;
  final String? section;
  final String? mobileNumber;
  final String? rfidNumber;
  final int? schoolId;
  final int? staffId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int id;

  Student({
    this.studentId,
    required this.name,
    this.fatherName,
    this.motherName,
    this.studentClass,
    this.section,
    this.mobileNumber,
    this.rfidNumber,
    this.schoolId,
    this.staffId,
    this.createdAt,
    this.updatedAt,
    required this.id,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      name: json['name'] ?? '',
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      studentClass: json['class'],
      section: json['section'],
      mobileNumber: json['mobile_number'],
      rfidNumber: json['rfid_number'],
      schoolId: json['school_id'],
      staffId: json['staff_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      id: json['id'] ?? 0,
    );
  }
}
