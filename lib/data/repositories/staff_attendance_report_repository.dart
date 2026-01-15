import 'package:schoolmsrfid/data/models/responses/staff_attandance_report_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class StaffAttendanceReportRepository {
  final _dio = ApiService.dio;

  Future<StaffAttandanceReportResponse> fetchStaffReport() async {
    final response = await _dio.post(
      ApiEndpoints.staffAttendanceReportUrl,
    );

    return StaffAttandanceReportResponse.fromJson(response.data);
  }
}
