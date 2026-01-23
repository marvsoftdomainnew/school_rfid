import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/toast_util.dart';
import '../../../data/models/requests/mark_attendance_request.dart';
import '../../../data/repositories/mark_attendance_repository.dart';

class MarkAttendanceController extends GetxController {
  final MarkAttendanceRepository _repository = MarkAttendanceRepository();

  final isProcessing = false.obs;

  /// Call when RFID is fully read
  Future<void> markAttendance(String rfidNumber) async {
    if (isProcessing.value) return; // prevent double hit

    isProcessing.value = true;

    try {
      final request = MarkAttendanceRequest(
        rfidNumber: rfidNumber,
      );
      final response = await _repository.markAttendance(request);

      if (response.success == true) {
        ToastUtil.success(
          response.message ?? "Attendance marked",
        );
      } else {
        ToastUtil.error(
          response.message ?? "Failed to mark attendance",
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          ToastUtil.error(
            data['message'] ?? "Attendance already completed",
          );
        } else {
          ToastUtil.error("Attendance already completed");
        }
      } else {
        // OTHER API ERRORS
        ToastUtil.error(
          NetworkExceptions.getErrorMessage(e),
        );
      }
    } catch (_) {
      ToastUtil.error("Something went wrong");
    } finally {
      isProcessing.value = false;
    }
  }
}
