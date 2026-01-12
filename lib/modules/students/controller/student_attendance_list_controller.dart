import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/data/repositories/student_attendance_list_repository.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';

class StudentAttendanceListController extends GetxController {
  final StudentAttendanceListRepository _repository = StudentAttendanceListRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  /// Final list used by UI
  final students = <Map<String, dynamic>>[].obs;

  /// Search-filtered list
  final filteredStudents = <Map<String, dynamic>>[].obs;

  // ================= API =================
  Future<void> fetchStudents() async {
    isLoading.value = true;

    try {
      final response = await _repository.fetchStudentAttendance();

      if (response.success == true) {
        /// Map API → UI format
        final list = response.records.map((record) {
          return {
            'id': record.userId,
            'name': 'Student ${record.userId}', // backend can send name later
            'class': record.className ?? 'Class',
            'section': record.section ?? '-',
            'isPresent': record.status == 'present',
          };
        }).toList();

        students.assignAll(list);
        filteredStudents.assignAll(list);
      } else {
        SnackbarUtil.showError(
          "Error",
          "Failed to load student attendance",
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
      filteredStudents.assignAll(students);
      return;
    }

    final q = query.toLowerCase();
    filteredStudents.assignAll(
      students.where((s) {
        return s['name'].toLowerCase().contains(q) ||
            s['class'].toLowerCase().contains(q) ||
            s['section'].toLowerCase().contains(q);
      }).toList(),
    );
  }
}
