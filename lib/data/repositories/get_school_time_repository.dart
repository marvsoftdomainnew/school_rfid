import 'package:schoolmsrfid/data/models/responses/get_school_time_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class GetSchoolTimeRepository {
  final _dio = ApiService.dio;

  Future<GetSchoolTimeResponse> getTime() async {
    final response = await _dio.post(
      ApiEndpoints.getScheduleTimeUrl,
    );
    return GetSchoolTimeResponse.fromJson(response.data);
  }
}
