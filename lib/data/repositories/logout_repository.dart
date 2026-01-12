import 'package:schoolmsrfid/core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';
import '../models/responses/logout_response.dart';

class LogoutRepository {
  final _dio = ApiService.dio;

  Future<LogoutResponse> logout() async {
    final response = await _dio.post(
      ApiEndpoints.logoutUrl,
    );
    return LogoutResponse.fromJson(response.data);
  }
}
