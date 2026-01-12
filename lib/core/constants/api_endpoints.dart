class ApiEndpoints {
  // Base URL
  static const String baseUrl = "https://ourskool.in/api";
  // static const String imageBaseUrl = "https://chavanbrothers.co.in/";

  // Endpoints
  static const String loginUrl = "$baseUrl/staff/authenticate";
  static const String logoutUrl = "$baseUrl/logout";
  static const String dashboardUrl = "$baseUrl/dashboard";
  static const String studentsAttendanceListUrl = "$baseUrl/student/attendance";
  static const String staffAttendanceListUrl = "$baseUrl/staff/attendance";
  static const String addStudentUrl = "$baseUrl/student/create";
  static const String addStaffUrl = "$baseUrl/staff/create";
  static const String markAttendanceUrl = "$baseUrl/staff/markattendance";
  // static const String signupUrl = "$baseUrl/user/register";
  // static const String getCategoryUrl = "$baseUrl/user/categories";
  // static const String getBannersUrl = "$baseUrl/getbanners";
  //
  //
  // static String productByCategoryUrl(int categoryId) =>
  //     "$baseUrl/products/categories/$categoryId";
}
