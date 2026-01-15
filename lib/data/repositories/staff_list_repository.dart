import 'package:schoolmsrfid/data/models/responses/staff_list_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class StaffListRepository {
  final _dio = ApiService.dio;

  Future<StaffListResponse> fetchStaffList() async {
    final response = await _dio.post(
      ApiEndpoints.staffListUrl,
    );
    return StaffListResponse.fromJson(response.data);
  }
}
