import 'package:schoolmsrfid/data/models/requests/school_time_schedule_request.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';
import '../models/responses/school_time_schedule_response.dart';

class SchoolTimeSchedulRepository {
  final _dio = ApiService.dio;

  Future<SchoolTimeScheduleResponse> setTime(SchoolTimeScheduleRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.scheduleTimeUrl,
        data: request
    );
    return SchoolTimeScheduleResponse.fromJson(response.data);
  }
}
