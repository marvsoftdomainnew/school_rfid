import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/app_log.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/repositories/attendance_summary_repository.dart';

class AttendanceSummaryController extends GetxController {
  final AttendanceSummaryRepository _repository = AttendanceSummaryRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  // ================= DATA (Reactive) =================
  final student = 0.obs;
  final staff = 0.obs;
  final presentStudent = 0.obs;
  final presentStaff = 0.obs;
  final absentStudent = 0.obs;
  final absentStaff = 0.obs;

  // ================= API CALL =================
  Future<void> fetchSummary() async {
    isLoading.value = true;

    try {
      final response = await _repository.fetchSummary();

      if (response.success == true) {
        student.value = response.student ?? 0;
        staff.value = response.staff ?? 0;
        presentStudent.value = response.presentStudent ?? 0;
        presentStaff.value = response.presentStaff ?? 0;
        absentStudent.value = response.absentStudent ?? 0;
        absentStaff.value = response.absentStaff ?? 0;
      } else {
        SnackbarUtil.showError("Error", "Failed to load dashboard summary",);
      }
    } on DioException catch (e) {
      final msg = NetworkExceptions.getErrorMessage(e);
      appLog("Error:  $msg");
    } catch (e) {
      SnackbarUtil.showError("Error", "Unexpected error occurred",);
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasData {
    return student.value > 0 ||
        staff.value > 0 ||
        presentStudent.value > 0 ||
        presentStaff.value > 0;
  }
}
