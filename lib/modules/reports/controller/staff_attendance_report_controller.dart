import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/responses/staff_attendance_list_responce.dart';
import '../../../data/repositories/staff_attendance_list_repository.dart';

enum ReportPeriod { daily, weekly, monthly }

class StaffAttendanceReportController extends GetxController {
  final StaffAttendanceListRepository _repository =
  StaffAttendanceListRepository();

  // ================= STATE =================
  final isLoading = false.obs;
  final selectedPeriod = ReportPeriod.daily.obs;

  /// Raw API records
  final records = <StaffAttendanceRecord>[].obs;

  /// Aggregated table rows (UI ready)
  final reportRows = <StaffReportRow>[].obs;

  // ================= API =================
  Future<void> fetchReport() async {
    isLoading.value = true;

    try {
      final response = await _repository.fetchStaffAttendance();

      if (response.success == true) {
        records.assignAll(response.records);
        _generateReport();
      } else {
        SnackbarUtil.showError(
          "Error",
          "Failed to load attendance report",
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

  // ================= PERIOD CHANGE =================
  void changePeriod(ReportPeriod period) {
    selectedPeriod.value = period;
    _generateReport();
  }

  // ================= CORE LOGIC =================
  void _generateReport() {
    final Map<int, List<StaffAttendanceRecord>> grouped = {};

    for (final r in records) {
      final staffId = r.staffId ?? r.userId;
      if (staffId == null) continue;

      if (!_isInSelectedPeriod(r.attendanceDate)) continue;

      grouped.putIfAbsent(staffId, () => []).add(r);
    }

    final List<StaffReportRow> rows = [];

    grouped.forEach((staffId, list) {
      final total = list.length;
      final present =
          list.where((e) => e.status == 'present').length;

      rows.add(
        StaffReportRow(
          staffId: staffId,
          staffName: "Staff $staffId", // backend name later
          role: list.first.userType ?? 'Staff',
          present: present,
          total: total,
        ),
      );
    });

    reportRows.assignAll(rows);
  }

  // ================= DATE FILTER =================
  bool _isInSelectedPeriod(DateTime? date) {
    if (date == null) return false;

    final now = DateTime.now();

    switch (selectedPeriod.value) {
      case ReportPeriod.daily:
        return _isSameDay(date, now);

      case ReportPeriod.weekly:
        return date.isAfter(
          now.subtract(const Duration(days: 7)),
        );

      case ReportPeriod.monthly:
        return date.year == now.year && date.month == now.month;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}


class StaffReportRow {
  final int staffId;
  final String staffName;
  final String role;
  final int present;
  final int total;

  StaffReportRow({
    required this.staffId,
    required this.staffName,
    required this.role,
    required this.present,
    required this.total,
  });

  String get percentage {
    if (total == 0) return "0";
    return ((present / total) * 100).toStringAsFixed(0);
  }
}
