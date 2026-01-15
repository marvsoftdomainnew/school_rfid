class StaffListResponse {
  final bool success;
  final String? message;
  final List<StaffRecord> records;

  StaffListResponse({
    required this.success,
    this.message,
    required this.records,
  });

  factory StaffListResponse.fromJson(Map<String, dynamic> json) {
    return StaffListResponse(
      success: json['success'] == true,
      message: json['message'],
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => StaffRecord.fromJson(e))
          .toList() ??
          [],
    );
  }
}
class StaffRecord {
  final int? id;
  final int? schoolId;
  final int? staffRoleId;

  final String? staffName;
  final String? fatherName;
  final String? motherName;
  final String? post;

  final String? mobileNumber;
  final String? rfidNumber;
  final String? avatarUrl;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  StaffRecord({
    this.id,
    this.schoolId,
    this.staffRoleId,
    this.staffName,
    this.fatherName,
    this.motherName,
    this.post,
    this.mobileNumber,
    this.rfidNumber,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffRecord.fromJson(Map<String, dynamic> json) {
    return StaffRecord(
      id: _toInt(json['id']),
      schoolId: _toInt(json['school_id']),
      staffRoleId: _toInt(json['staff_role_id']),
      staffName: json['staff_name'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      post: json['post'],
      mobileNumber: json['mobile_number'],
      rfidNumber: json['rfid_number'],
      avatarUrl: json['avatar_url'],
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
