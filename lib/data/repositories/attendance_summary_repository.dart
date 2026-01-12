  import 'package:schoolmsrfid/core/constants/api_endpoints.dart';
  import '../../core/services/api_service.dart';
  import '../models/responses/attendance_summary_response.dart';

  class AttendanceSummaryRepository {
    final _dio = ApiService.dio;

    Future<AttendanceSummaryResponse> fetchSummary() async {
      final response = await _dio.get(
        ApiEndpoints.dashboardUrl,
      );

      return AttendanceSummaryResponse.fromJson(response.data);
    }
  }
