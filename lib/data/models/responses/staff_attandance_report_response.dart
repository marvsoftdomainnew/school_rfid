class StaffAttandanceReportResponse {
  final bool success;
  final List<StaffReportRecord> records;

  StaffAttandanceReportResponse({
    required this.success,
    required this.records,
  });

  factory StaffAttandanceReportResponse.fromJson(
      Map<String, dynamic> json) {
    return StaffAttandanceReportResponse(
      success: json['success'] == true,
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => StaffReportRecord.fromJson(e))
          .toList() ??
          [],
    );
  }
}


class StaffReportRecord {
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

  final StaffUser? staff;

  StaffReportRecord({
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
    this.staff,
  });

  factory StaffReportRecord.fromJson(Map<String, dynamic> json) {
    return StaffReportRecord(
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

      // ✅ STAFF OBJECT PARSING
      staff: json['staff'] != null
          ? StaffUser.fromJson(json['staff'])
          : null,
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


class StaffUser {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? mobileNumber;
  final String? rfidNumber;

  StaffUser({
    this.id,
    this.name,
    this.email,
    this.role,
    this.mobileNumber,
    this.rfidNumber,
  });

  factory StaffUser.fromJson(Map<String, dynamic> json) {
    return StaffUser(
      id: _toInt(json['id']),
      name: json['name'],
      email: json['email'],
      role: json['role'],
      mobileNumber: json['mobile_number'],
      rfidNumber: json['rfid_number'],
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
