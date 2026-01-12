import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/repositories/staff_attendance_list_repository.dart';

class StaffAttendanceListController extends GetxController {
  final StaffAttendanceListRepository _repository = StaffAttendanceListRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  /// Full list
  final staffs = <Map<String, dynamic>>[].obs;

  /// Search-filtered list
  final filteredStaffs = <Map<String, dynamic>>[].obs;

  // ================= API =================
  Future<void> fetchStaffs() async {
    isLoading.value = true;

    try {
      final response = await _repository.fetchStaffAttendance();

      if (response.success == true) {
        final list = response.records.map((record) {
          return {
            'id': record.staffId ?? record.userId,
            'name': 'Staff ${record.staffId ?? record.userId}',
            'designation': record.userType ?? 'Staff',
            'isPresent': record.status == 'present',
          };
        }).toList();

        staffs.assignAll(list);
        filteredStaffs.assignAll(list);
      } else {
        SnackbarUtil.showError(
          "Error",
          "Failed to load staff attendance",
        );
      }
    } on DioException catch (e) {
      SnackbarUtil.showError(
        "Error",
        NetworkExceptions.getErrorMessage(e),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SEARCH =================
  void filter(String query) {
    if (query.isEmpty) {
      filteredStaffs.assignAll(staffs);
      return;
    }

    final q = query.toLowerCase();
    filteredStaffs.assignAll(
      staffs.where((s) {
        return s['name'].toLowerCase().contains(q) ||
            s['designation'].toLowerCase().contains(q);
      }).toList(),
    );
  }
}
