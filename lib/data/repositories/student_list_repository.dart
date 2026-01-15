import 'package:schoolmsrfid/data/models/responses/students_list_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class StudentListRepository {
  final _dio = ApiService.dio;

  Future<StudentsListResponse> fetchStudentAttendance() async {
    final response = await _dio.post(
      ApiEndpoints.studentsListUrl,
    );
    return StudentsListResponse.fromJson(response.data);
  }
}
