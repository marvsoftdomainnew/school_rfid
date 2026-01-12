import 'package:schoolmsrfid/data/models/requests/add_staff_request.dart';
import 'package:schoolmsrfid/data/models/requests/mark_attendance_request.dart';
import 'package:schoolmsrfid/data/models/responses/add_staff_response.dart';
import 'package:schoolmsrfid/data/models/responses/mark_attendance_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class MarkAttendanceRepository {
  final _dio = ApiService.dio;

  Future<MarkAttendanceResponse> markAttendance(MarkAttendanceRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.markAttendanceUrl,
      data: request.toJson(),
    );
    return MarkAttendanceResponse.fromJson(response.data);
  }
}
