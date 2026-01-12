import 'package:schoolmsrfid/data/models/responses/staff_attendance_list_responce.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class StaffAttendanceListRepository {
  final _dio = ApiService.dio;

  Future<StaffAttendanceListResponce> fetchStaffAttendance() async {
    final response = await _dio.get(
      ApiEndpoints.staffAttendanceListUrl,
    );
    return StaffAttendanceListResponce.fromJson(response.data);
  }
}
