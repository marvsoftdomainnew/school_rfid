class SchoolTimeScheduleResponse {
  final bool success;
  final SchoolTimeSetting? setting;
  final String? message;

  SchoolTimeScheduleResponse({
    required this.success,
    this.setting,
    this.message,
  });

  factory SchoolTimeScheduleResponse.fromJson(Map<String, dynamic> json) {
    return SchoolTimeScheduleResponse(
      success: json['success'] == true,
      setting: json['setting'] != null
          ? SchoolTimeSetting.fromJson(json['setting'])
          : null,
      message: json['message'],
    );
  }
}
class SchoolTimeSetting {
  final String? schoolStartTime; // HH:mm
  final String? schoolEndTime;   // HH:mm

  SchoolTimeSetting({
    this.schoolStartTime,
    this.schoolEndTime,
  });

  factory SchoolTimeSetting.fromJson(Map<String, dynamic> json) {
    return SchoolTimeSetting(
      schoolStartTime: json['school_start_time'],
      schoolEndTime: json['school_end_time'],
    );
  }
}
