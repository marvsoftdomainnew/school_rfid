class ApiEndpoints {
  // Base URL
  static const String baseUrl = "https://ourskool.in/api";

  // Endpoints
  static const String loginUrl = "$baseUrl/staff/authenticate";
  static const String logoutUrl = "$baseUrl/logout";
  static const String dashboardUrl = "$baseUrl/dashboard";
  static const String studentsListUrl = "$baseUrl/staff/studentlist";
  static const String staffListUrl = "$baseUrl/staff/stafflist";
  static const String addStudentUrl = "$baseUrl/student/create";
  static const String addStaffUrl = "$baseUrl/staff/create";
  static const String staffAttendanceReportUrl = "$baseUrl/staff/attendance";
  static const String studentAttendanceReportUrl = "$baseUrl/student/attendance";
  static const String markAttendanceUrl = "$baseUrl/staff/markattendance";
  static const String scheduleTimeUrl = "$baseUrl/settings";
  static const String getScheduleTimeUrl = "$baseUrl/getsettings";
}
