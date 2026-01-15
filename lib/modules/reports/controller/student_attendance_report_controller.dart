import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/responses/student_attendance_report_response.dart';
import '../../../data/repositories/student_attendance_report_repository.dart';

class StudentAttendanceReportController extends GetxController {
  final StudentAttendanceReportRepository _repository =
  StudentAttendanceReportRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  final records = <StudentAttendanceReportRecord>[].obs;
  final filteredRecords = <StudentAttendanceReportRecord>[].obs;

  final selectedClass = RxnString();
  final selectedSection = RxnString();
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();

  // ================= API =================
  Future<void> fetchReport() async {
    isLoading.value = true;

    try {
      final response = await _repository.fetchStaffReport();

      if (response.success) {
        records.assignAll(response.records);
        applyFilters();
      } else {
        SnackbarUtil.showError("Error", "Failed to load student report");
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

  // ================= FILTER LOGIC =================
  void applyFilters() {
    filteredRecords.assignAll(
      records.where((r) {
        final matchClass = selectedClass.value == null ||
            r.className == selectedClass.value;

        final matchSection = selectedSection.value == null ||
            r.section == selectedSection.value;

        final recordDate = r.attendanceDate;

        final matchFrom = fromDate.value == null ||
            (recordDate != null &&
                !recordDate.isBefore(fromDate.value!));

        final matchTo = toDate.value == null ||
            (recordDate != null &&
                !recordDate.isAfter(toDate.value!));

        return matchClass && matchSection && matchFrom && matchTo;
      }).toList(),
    );
  }

  // ================= DROPDOWN DATA =================
  List<String> getClassList() {
    return records
        .map((e) => e.className)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
  }

  List<String> getSectionList() {
    return records
        .map((e) => e.section)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
  }

  // ================= PDF EXPORT =================
  Future<void> exportPdf() async {
    if (filteredRecords.isEmpty) {
      SnackbarUtil.showError("No Data", "Nothing to export");
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Text(
            "Student Attendance Report",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: [
              "Student ID",
              "Class",
              "Section",
              "Date",
              "Status",
            ],
            data: filteredRecords.map((r) {
              return [
                r.userId?.toString() ?? "-",
                r.className ?? "-",
                r.section ?? "-",
                r.attendanceDate != null
                    ? "${r.attendanceDate!.day}/${r.attendanceDate!.month}/${r.attendanceDate!.year}"
                    : "-",
                r.status ?? "-",
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
    );
  }
}
