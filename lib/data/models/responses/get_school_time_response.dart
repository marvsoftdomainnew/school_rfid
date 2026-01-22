class GetSchoolTimeResponse {
  final bool success;
  final SchoolTimeSetting? setting;

  GetSchoolTimeResponse({
    required this.success,
    this.setting,
  });

  factory GetSchoolTimeResponse.fromJson(Map<String, dynamic> json) {
    return GetSchoolTimeResponse(
      success: json['success'] == true,
      setting: json['setting'] != null
          ? SchoolTimeSetting.fromJson(json['setting'])
          : null,
    );
  }
}

class SchoolTimeSetting {
  final String? schoolStartTime; // format: HH:mm:ss
  final String? schoolEndTime;   // format: HH:mm:ss

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
