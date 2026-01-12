import 'package:schoolmsrfid/data/models/responses/students_attendance_list_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class StudentAttendanceListRepository {
  final _dio = ApiService.dio;

  Future<StudentsAttendanceListResponse> fetchStudentAttendance() async {
    final response = await _dio.get(
      ApiEndpoints.studentsAttendanceListUrl,
    );
    return StudentsAttendanceListResponse.fromJson(response.data);
  }
}
