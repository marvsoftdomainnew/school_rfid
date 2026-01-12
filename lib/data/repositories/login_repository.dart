import 'package:schoolmsrfid/core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';
import '../models/requests/login_request.dart';
import '../models/responses/login_response.dart';

class LoginRepository {
  final _dio = ApiService.dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.loginUrl,
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }
}
