class AddStaffResponse {
  final bool success;
  final Staff? staff;
  final String? message;

  AddStaffResponse({
    required this.success,
    this.staff,
    this.message,
  });

  factory AddStaffResponse.fromJson(Map<String, dynamic> json) {
    return AddStaffResponse(
      success: json['success'] == true,
      staff: json['staff'] != null ? Staff.fromJson(json['staff']) : null,
      message: json['message'],
    );
  }
}
class Staff {
  final int? id;
  final int? staffRoleId;
  final String staffName;
  final String? fatherName;
  final String? motherName;
  final String? mobileNumber;
  final String? rfidNumber;
  final int? schoolId;
  final String? post;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Staff({
    this.id,
    this.staffRoleId,
    required this.staffName,
    this.fatherName,
    this.motherName,
    this.mobileNumber,
    this.rfidNumber,
    this.schoolId,
    this.post,
    this.createdAt,
    this.updatedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: _toInt(json['id']),
      staffRoleId: _toInt(json['staff_role_id']),
      staffName: json['staff_name'] ?? '',
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      mobileNumber: json['mobile_number'],
      rfidNumber: json['rfid_number'],
      schoolId: _toInt(json['school_id']),
      post: json['post'],
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  // ---------- helpers ----------
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
