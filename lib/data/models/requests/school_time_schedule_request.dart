class SchoolTimeScheduleRequest {
  final String schoolName;
  final String schoolStartTime;
  final String schoolEndTime;

  SchoolTimeScheduleRequest({
    required this.schoolName,
    required this.schoolStartTime,
    required this.schoolEndTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "school_name": schoolName,
      "school_start_time": schoolStartTime,
      "school_end_time": schoolEndTime,
    };
  }
}
