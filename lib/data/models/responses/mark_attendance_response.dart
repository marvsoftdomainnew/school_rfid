class MarkAttendanceResponse {
  final bool success;
  final String? type;
  final String? message;

  MarkAttendanceResponse({
    required this.success,
    this.type,
    this.message,
  });

  factory MarkAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return MarkAttendanceResponse(
      success: json['success'] == true,
      type: json['type']?.toString(),
      message: json['message']?.toString(),
    );
  }
}
