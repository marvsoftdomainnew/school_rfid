import 'package:schoolmsrfid/data/models/requests/add_students_request.dart';
import 'package:schoolmsrfid/data/models/responses/add_student_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class AddStudentRepository {
  final _dio = ApiService.dio;

  Future<AddStudentResponse> addStudent(AddStudentsRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.addStudentUrl,
      data: request.toJson(),
    );
    return AddStudentResponse.fromJson(response.data);
  }
}
