import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/responses/staff_attandance_report_response.dart';
import '../../../data/repositories/staff_attendance_report_repository.dart';

class StaffAttendanceReportController extends GetxController {
  final StaffAttendanceReportRepository _repository =
  StaffAttendanceReportRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  final records = <StaffReportRecord>[].obs;
  final filteredRecords = <StaffReportRecord>[].obs;

  final selectedPost = RxnString();
  final fromDate = Rxn<DateTime>();
  final toDate = Rxn<DateTime>();

  // ================= API =================
  Future<void> fetchReport() async {
    isLoading.value = true;

    try {
      final StaffAttandanceReportResponse response =
      await _repository.fetchStaffReport();

      if (response.success == true) {
        records.assignAll(response.records);
        applyFilters();
      } else {
        SnackbarUtil.showError("Error", "Failed to load staff report");
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
        final matchPost = selectedPost.value == null ||
            selectedPost.value!.isEmpty ||
            r.userType == selectedPost.value;

        final recordDate = r.attendanceDate;

        final matchFrom = fromDate.value == null ||
            (recordDate != null &&
                !recordDate.isBefore(fromDate.value!));

        final matchTo = toDate.value == null ||
            (recordDate != null &&
                !recordDate.isAfter(toDate.value!));

        return matchPost && matchFrom && matchTo;
      }).toList(),
    );
  }

  // ================= HELPERS =================
  List<String> getPostList() {
    final posts = records
        .map((e) => e.userType)
        .whereType<String>()
        .toSet()
        .toList();
    posts.sort();
    return posts;
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
            "Staff Attendance Report",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Table.fromTextArray(
            headers: ["Staff ID", "Post", "Present", "Total", "%"],
            data: filteredRecords.map((r) {
              final present = r.status == "present" ? 1 : 0;
              final total = 1;
              final percent = ((present / total) * 100).toStringAsFixed(0);

              return [
                r.staffId ?? "-",
                r.userType ?? "-",
                present.toString(),
                total.toString(),
                "$percent%",
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
