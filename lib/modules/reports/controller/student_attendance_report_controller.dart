import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/repositories/student_attendance_list_repository.dart';
import '../../../core/services/network_exceptions.dart';

enum ReportPeriod { daily, weekly, monthly }

class StudentReportRow {
  final String name;
  final int present;
  final int total;
  final int percent;

  StudentReportRow({
    required this.name,
    required this.present,
    required this.total,
    required this.percent,
  });
}

class StudentAttendanceReportController extends GetxController {
  final StudentAttendanceListRepository _repository =
  StudentAttendanceListRepository();

  final isLoading = false.obs;
  final selectedPeriod = ReportPeriod.daily.obs;

  final _records = <Map<String, dynamic>>[];
  final tableRows = <StudentReportRow>[].obs;

  // ================= API =================
  Future<void> fetchReport() async {
    isLoading.value = true;

    try {
      final response = await _repository.fetchStudentAttendance();

      if (response.success == true) {
        _records.clear();

        for (final r in response.records) {
          _records.add({
            'studentId': r.userId,
            'name': 'Student ${r.userId}',
            'date': r.attendanceDate,
            'status': r.status,
          });
        }

        _recalculate();
      }
    } on DioException catch (e) {
      Get.snackbar("Error", NetworkExceptions.getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PERIOD CHANGE =================
  void changePeriod(ReportPeriod p) {
    selectedPeriod.value = p;
    _recalculate();
  }

  // ================= CORE LOGIC =================
  void _recalculate() {
    final Map<int, List<Map<String, dynamic>>> grouped = {};

    for (final r in _records) {
      grouped.putIfAbsent(r['studentId'], () => []).add(r);
    }

    final now = DateTime.now();
    final rows = <StudentReportRow>[];

    grouped.forEach((_, list) {
      int present = 0;
      int total = 0;

      for (final r in list) {
        final DateTime d = r['date'];
        bool include = false;

        if (selectedPeriod.value == ReportPeriod.daily) {
          include = _sameDay(d, now);
        } else if (selectedPeriod.value == ReportPeriod.weekly) {
          include = d.isAfter(now.subtract(const Duration(days: 7)));
        } else {
          include = d.month == now.month && d.year == now.year;
        }

        if (include) {
          total++;
          if (r['status'] == 'present' || r['status'] == 'late') {
            present++;
          }
        }
      }

      if (total > 0) {
        rows.add(
          StudentReportRow(
            name: list.first['name'],
            present: present,
            total: total,
            percent: ((present / total) * 100).round(),
          ),
        );
      }
    });

    tableRows.assignAll(rows);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
