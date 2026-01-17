class StudentAttendanceReportResponse {
  final bool success;
  final List<StudentAttendanceReportRecord> records;

  StudentAttendanceReportResponse({
    required this.success,
    required this.records,
  });

  factory StudentAttendanceReportResponse.fromJson(
      Map<String, dynamic> json) {
    return StudentAttendanceReportResponse(
      success: json['success'] == true,
      records: (json['records'] as List<dynamic>?)
          ?.map(
            (e) => StudentAttendanceReportRecord.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}


class StudentAttendanceReportRecord {
  final int? id;
  final String? userType;
  final int? userId;
  final int? adminId;
  final int? staffId;

  final String? className;
  final String? section;

  final DateTime? attendanceDate;
  final String? status;

  final String? inTime;
  final String? outTime;
  final int? workingMinutes;

  final String? rfidNumber;
  final String? entryMode;
  final String? deviceId;
  final String? ipAddress;
  final String? remarks;

  final DateTime? markedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  // ✅ NESTED STUDENT OBJECT
  final StudentUser? student;

  StudentAttendanceReportRecord({
    this.id,
    this.userType,
    this.userId,
    this.adminId,
    this.staffId,
    this.className,
    this.section,
    this.attendanceDate,
    this.status,
    this.inTime,
    this.outTime,
    this.workingMinutes,
    this.rfidNumber,
    this.entryMode,
    this.deviceId,
    this.ipAddress,
    this.remarks,
    this.markedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.student,
  });

  factory StudentAttendanceReportRecord.fromJson(
      Map<String, dynamic> json) {
    return StudentAttendanceReportRecord(
      id: _toInt(json['id']),
      userType: json['user_type'],
      userId: _toInt(json['user_id']),
      adminId: _toInt(json['admin_id']),
      staffId: _toInt(json['staff_id']),
      className: json['class'],
      section: json['section'],
      attendanceDate: _toDate(json['attendance_date']),
      status: json['status'],
      inTime: json['in_time'],
      outTime: json['out_time'],
      workingMinutes: _toInt(json['working_minutes']),
      rfidNumber: json['rfid_number'],
      entryMode: json['entry_mode'],
      deviceId: json['device_id'],
      ipAddress: json['ip_address'],
      remarks: json['remarks'],
      markedAt: _toDate(json['marked_at']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      deletedAt: _toDate(json['deleted_at']),

      // ✅ STUDENT OBJECT PARSING
      student: json['student'] != null
          ? StudentUser.fromJson(json['student'])
          : null,
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


class StudentUser {
  final int? id;
  final int? schoolId;
  final int? staffId;
  final int? studentId;

  final String? name;
  final String? fatherName;
  final String? motherName;

  final String? className;
  final String? section;

  final String? mobileNumber;
  final String? rfidNumber;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentUser({
    this.id,
    this.schoolId,
    this.staffId,
    this.studentId,
    this.name,
    this.fatherName,
    this.motherName,
    this.className,
    this.section,
    this.mobileNumber,
    this.rfidNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
      id: _toInt(json['id']),
      schoolId: _toInt(json['school_id']),
      staffId: _toInt(json['staff_id']),
      studentId: _toInt(json['student_id']),
      name: json['name'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      className: json['class'],
      section: json['section'],
      mobileNumber: json['mobile_number'],
      rfidNumber: json['rfid_number'],
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

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
