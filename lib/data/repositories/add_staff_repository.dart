import 'package:schoolmsrfid/data/models/requests/add_staff_request.dart';
import 'package:schoolmsrfid/data/models/responses/add_staff_response.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/api_service.dart';

class AddStaffRepository {
  final _dio = ApiService.dio;

  Future<AddStaffResponse> addStaff(AddStaffRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.addStaffUrl,
      data: request.toJson(),
    );
    return AddStaffResponse.fromJson(response.data);
  }
}
