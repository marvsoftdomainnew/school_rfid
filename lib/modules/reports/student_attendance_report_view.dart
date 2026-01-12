// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import '../../widgets/custom_header.dart';
//
// class StudentAttendanceReportView extends StatefulWidget {
//   const StudentAttendanceReportView({super.key});
//
//   @override
//   State<StudentAttendanceReportView> createState() =>
//       _StudentAttendanceReportViewState();
// }
//
// class _StudentAttendanceReportViewState
//     extends State<StudentAttendanceReportView> {
//   final Color primary = const Color(0xFF00b894);
//
//   String selectedPeriod = "Daily";
//
//   final List<Map<String, dynamic>> students = List.generate(10, (i) {
//     return {
//       "name": "Student ${i + 1}",
//       "present": i % 3 != 0,
//       "presentDays": 18 - i,
//       "totalDays": 22,
//     };
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: primary,
//         onPressed: () {
//           // TODO: PDF / Print logic later
//         },
//         icon: const Icon(Icons.print),
//         label: const Text("Export PDF"),
//       ),
//
//       body: Column(
//         children: [
//           const CustomHeader(
//             title: "Student Attendance",
//             subtitle: "Daily / Weekly / Monthly",
//           ),
//
//           _periodSelector(),
//
//           Expanded(child: _table()),
//         ],
//       ),
//     );
//   }
//
//   // ================= PERIOD SELECTOR =================
//   Widget _periodSelector() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//       child: Row(
//         children: ["Daily", "Weekly", "Monthly"].map((p) {
//           final active = selectedPeriod == p;
//           return Padding(
//             padding: EdgeInsets.only(right: 2.w),
//             child: ChoiceChip(
//               label: Text(p),
//               selected: active,
//               selectedColor: primary.withOpacity(0.15),
//               onSelected: (_) => setState(() => selectedPeriod = p),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   // ================= TABLE =================
//   Widget _table() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(4.w),
//       child: Table(
//         border: TableBorder.symmetric(
//           inside: BorderSide(color: Colors.grey.shade300),
//         ),
//         columnWidths: const {
//           0: FlexColumnWidth(2),
//           1: FlexColumnWidth(1),
//           2: FlexColumnWidth(1),
//           3: FlexColumnWidth(1),
//         },
//         children: [
//           _headerRow(),
//           ...students.map(_dataRow),
//         ],
//       ),
//     );
//   }
//
//   TableRow _headerRow() {
//     return TableRow(
//       decoration: BoxDecoration(color: primary.withOpacity(0.08)),
//       children: [
//         _cell("Student"),
//         _cell("Present"),
//         _cell("Total"),
//         _cell("%"),
//       ],
//     );
//   }
//
//   TableRow _dataRow(Map<String, dynamic> s) {
//     final int present =
//     selectedPeriod == "Daily" ? (s["present"] ? 1 : 0) : s["presentDays"];
//     final int total =
//     selectedPeriod == "Daily" ? 1 : s["totalDays"];
//     final percent = ((present / total) * 100).toStringAsFixed(0);
//
//     return TableRow(
//       children: [
//         _cell(s["name"]),
//         _cell("$present"),
//         _cell("$total"),
//         _cell("$percent%"),
//       ],
//     );
//   }
//
//   Widget _cell(String text) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 1.2.h),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 13.sp),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/custom_header.dart';
import 'controller/student_attendance_report_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StudentAttendanceReportView extends StatefulWidget {
  const StudentAttendanceReportView({super.key});

  @override
  State<StudentAttendanceReportView> createState() =>
      _StudentAttendanceReportViewState();
}

class _StudentAttendanceReportViewState
    extends State<StudentAttendanceReportView> {
  final controller = Get.put(StudentAttendanceReportController());
  final primary = const Color(0xFF00b894);

  @override
  void initState() {
    super.initState();
    controller.fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("Export PDF"),
        onPressed: _exportPdf,
      ),

      body: Column(
        children: [
          const CustomHeader(
            title: "Student Attendance",
            subtitle: "Daily • Weekly • Monthly",
          ),

          _periodSelector(),

          Expanded(child: _table()),
        ],
      ),
    );
  }

  Widget _periodSelector() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: ReportPeriod.values.map((p) {
            final active = controller.selectedPeriod.value == p;
            return Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: ChoiceChip(
                label: Text(p.name.capitalizeFirst!),
                selected: active,
                selectedColor: primary.withOpacity(0.15),
                onSelected: (_) => controller.changePeriod(p),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _table() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.tableRows.isEmpty) {
        return const Center(child: Text("No data available"));
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            _header(),
            ...controller.tableRows.map(_row),
          ],
        ),
      );
    });
  }

  TableRow _header() => TableRow(
    decoration: BoxDecoration(color: primary.withOpacity(0.08)),
    children: const [
      _Cell("Student"),
      _Cell("Present"),
      _Cell("Total"),
      _Cell("%"),
    ],
  );

  TableRow _row(StudentReportRow r) => TableRow(
    children: [
      _Cell(r.name),
      _Cell("${r.present}"),
      _Cell("${r.total}"),
      _Cell("${r.percent}%"),
    ],
  );

  Future<void> _exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) {
          return pw.Table.fromTextArray(
            headers: ['Student', 'Present', 'Total', '%'],
            data: controller.tableRows.map((r) {
              return [
                r.name,
                r.present.toString(),
                r.total.toString(),
                "${r.percent}%",
              ];
            }).toList(),
          );
        },
      ),
    );

    try {
      await Printing.layoutPdf(onLayout: (_) => pdf.save());
    } catch (_) {
      Get.snackbar(
        "PDF Error",
        "PDF service not available on this device",
      );
    }
  }
}

class _Cell extends StatelessWidget {
  final String text;
  const _Cell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
