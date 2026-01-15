import 'package:schoolmsrfid/data/models/responses/staff_attandance_report_response.dart';
import 'package:schoolmsrfid/data/models/responses/student_attendance_report_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class StudentAttendanceReportRepository {
  final _dio = ApiService.dio;

  Future<StudentAttendanceReportResponse> fetchStaffReport() async {
    final response = await _dio.post(
      ApiEndpoints.studentAttendanceReportUrl,
    );

    return StudentAttendanceReportResponse.fromJson(response.data);
  }
}
