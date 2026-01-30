import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/data/models/responses/students_list_response.dart';
import 'package:schoolmsrfid/data/repositories/student_list_repository.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';

class StudentListController extends GetxController {
  final StudentListRepository _repository = StudentListRepository();

  final isLoading = false.obs;

  /// Original API list
  final students = <Map<String, dynamic>>[].obs;

  /// Filtered list (UI)
  final filteredStudents = <Map<String, dynamic>>[].obs;

  // ================= API =================
  Future<void> fetchStudents() async {
    isLoading.value = true;

    try {
      final StudentsListResponse response =
      await _repository.fetchStudentAttendance();

      if (response.success == true) {
        final list = response.records.map((StudentRecord r) {
          return {
            'id': r.studentId ?? r.id,
            'name': r.name ?? '',
            'class': r.studentClass ?? '',
            'section': r.section ?? '',
            'rfid': r.rfidNumber ?? '',
            'mobile': r.mobileNumber ?? '',
            'father_name': r.fatherName ?? '',
            'mother_name': r.motherName ?? '',
          };
        }).toList();

        students.assignAll(list);
        filteredStudents.assignAll(list);
      } else {
        SnackbarUtil.showError(
          "Error",
          response.message ?? "Failed to load students",
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

  // ================= SEARCH (NAME ONLY) =================
  void filterByName(String query) {
    if (query.trim().isEmpty) {
      filteredStudents.assignAll(students);
      return;
    }

    final q = query.toLowerCase();

    filteredStudents.assignAll(
      students.where((s) {
        return (s['name'] ?? '').toLowerCase().contains(q);
      }).toList(),
    );
  }
}
