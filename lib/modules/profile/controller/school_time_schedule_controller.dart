import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/requests/school_time_schedule_request.dart';
import '../../../data/models/responses/get_school_time_response.dart';
import '../../../data/repositories/get_school_time_repository.dart';
import '../../../data/repositories/school_time_schedul_repository.dart';


class SchoolTimeScheduleController extends GetxController {
  final SchoolTimeSchedulRepository _saveRepository = SchoolTimeSchedulRepository();
  final GetSchoolTimeRepository _getRepository = GetSchoolTimeRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  final startTime = Rxn<TimeOfDay>();
  final endTime = Rxn<TimeOfDay>();

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    fetchSchoolTime();
  }

  // ================= GET SCHOOL TIME =================
  Future<void> fetchSchoolTime() async {
    isLoading.value = true;

    try {
      final GetSchoolTimeResponse response = await _getRepository.getTime();

      if (response.success && response.setting != null) {
        startTime.value =
            _parseTime(response.setting!.schoolStartTime);
        endTime.value =
            _parseTime(response.setting!.schoolEndTime);
      }
    } catch (e) {
      SnackbarUtil.showError(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SAVE SCHOOL TIME =================
  Future<void> saveSchedule() async {
    if (startTime.value == null || endTime.value == null) {
      SnackbarUtil.showError(
        "Validation",
        "Please select start and end time",
      );
      return;
    }

    if (toMinutes(endTime.value!) <= toMinutes(startTime.value!)) {
      SnackbarUtil.showError(
        "Validation",
        "End time must be after start time",
      );
      return;
    }

    isLoading.value = true;

    try {
      final request = SchoolTimeScheduleRequest(
        schoolName: "Data",
        schoolStartTime: _toApiTime(startTime.value!),
        schoolEndTime: _toApiTime(endTime.value!),
      );

      final response = await _saveRepository.setTime(request);

      if (response.success) {
        SnackbarUtil.showSuccess("Success", "Time schedule saved successfully"
        );
      } else {
        SnackbarUtil.showError("Error", "Failed to save schedule",);
      }
    } catch (e) {
      SnackbarUtil.showError("Error", e.toString(),);
    } finally {
      isLoading.value = false;
    }
  }

  // ================= HELPERS =================
  TimeOfDay? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;

    // supports HH:mm or HH:mm:ss
    final parts = value.split(':');
    if (parts.length < 2) return null;

    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);

    if (h == null || m == null) return null;

    return TimeOfDay(hour: h, minute: m);
  }

  String _toApiTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
}
