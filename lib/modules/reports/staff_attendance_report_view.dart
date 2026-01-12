// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import '../../widgets/custom_header.dart';
//
// class StaffAttendanceReportView extends StatefulWidget {
//   const StaffAttendanceReportView({super.key});
//
//   @override
//   State<StaffAttendanceReportView> createState() =>
//       _StaffAttendanceReportViewState();
// }
//
// class _StaffAttendanceReportViewState extends State<StaffAttendanceReportView> {
//   final Color primary = const Color(0xFF00b894);
//   String selectedPeriod = "Daily";
//
//   // ================= DUMMY STAFF DATA =================
//   final List<Map<String, dynamic>> staffData =
//   List.generate(50, (index) {
//     final totalDays = 22;
//     final presentDays = 14 + (index % 8);
//
//     return {
//       "id": index + 1,
//       "name": "Staff ${index + 1}",
//       "designation": [
//         "Teacher",
//         "Principal",
//         "Clerk",
//         "Librarian",
//         "Peon",
//         "Accountant",
//         "Coach",
//       ][index % 7],
//
//       // Daily
//       "todayPresent": index % 4 != 0,
//
//       // Weekly
//       "weeklyPresent": 4 + (index % 3),
//       "weeklyTotal": 6,
//
//       // Monthly
//       "monthlyPresent": presentDays,
//       "monthlyTotal": totalDays,
//     };
//   });
//
//   // ================= HELPERS =================
//   int _present(Map<String, dynamic> s) {
//     if (selectedPeriod == "Daily") {
//       return s["todayPresent"] ? 1 : 0;
//     }
//     if (selectedPeriod == "Weekly") {
//       return s["weeklyPresent"];
//     }
//     return s["monthlyPresent"];
//   }
//
//   int _total(Map<String, dynamic> s) {
//     if (selectedPeriod == "Daily") return 1;
//     if (selectedPeriod == "Weekly") return s["weeklyTotal"];
//     return s["monthlyTotal"];
//   }
//
//   String _percent(Map<String, dynamic> s) {
//     final p = _present(s);
//     final t = _total(s);
//     return ((p / t) * 100).toStringAsFixed(0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // ===== EXPORT BUTTON =====
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: primary,
//         onPressed: () {
//           // TODO: PDF / Excel export
//         },
//         icon: const Icon(Icons.print),
//         label: const Text("Export PDF"),
//       ),
//
//       body: Column(
//         children: [
//           const CustomHeader(
//             title: "Staff Attendance",
//             subtitle: "Daily • Weekly • Monthly",
//           ),
//
//           _periodSelector(),
//
//           Expanded(child: _attendanceTable()),
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
//   Widget _attendanceTable() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(4.w),
//       child: Table(
//         border: TableBorder.symmetric(
//           inside: BorderSide(color: Colors.grey.shade300),
//         ),
//         columnWidths: const {
//           0: FlexColumnWidth(2),
//           1: FlexColumnWidth(2),
//           2: FlexColumnWidth(1),
//           3: FlexColumnWidth(1),
//           4: FlexColumnWidth(1),
//         },
//         children: [
//           _headerRow(),
//           ...staffData.map(_dataRow),
//         ],
//       ),
//     );
//   }
//
//   TableRow _headerRow() {
//     return TableRow(
//       decoration: BoxDecoration(color: primary.withOpacity(0.08)),
//       children: [
//         _cell("Staff"),
//         _cell("Role"),
//         _cell("Present"),
//         _cell("Total"),
//         _cell("%"),
//       ],
//     );
//   }
//
//   TableRow _dataRow(Map<String, dynamic> s) {
//     return TableRow(
//       children: [
//         _cell(s["name"]),
//         _cell(s["designation"]),
//         _cell("${_present(s)}"),
//         _cell("${_total(s)}"),
//         _cell("${_percent(s)}%"),
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
//           style: TextStyle(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/custom_header.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'controller/staff_attendance_report_controller.dart';

class StaffAttendanceReportView extends StatefulWidget {
  const StaffAttendanceReportView({super.key});

  @override
  State<StaffAttendanceReportView> createState() =>
      _StaffAttendanceReportViewState();
}

class _StaffAttendanceReportViewState
    extends State<StaffAttendanceReportView> {
  final controller = Get.put(StaffAttendanceReportController());
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
        onPressed: () => _exportPdf(),
      ),
      body: Column(
        children: [
          const CustomHeader(
            title: "Staff Attendance",
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

      if (controller.reportRows.isEmpty) {
        return const Center(child: Text("No data available"));
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _header(),
            ...controller.reportRows.map(_row),
          ],
        ),
      );
    });
  }

  TableRow _header() => TableRow(
    decoration: BoxDecoration(color: primary.withOpacity(0.08)),
    children: const [
      _Cell("Staff"),
      _Cell("Role"),
      _Cell("Present"),
      _Cell("Total"),
      _Cell("%"),
    ],
  );

  TableRow _row(StaffReportRow r) => TableRow(
    children: [
      _Cell(r.staffName),
      _Cell(r.role),
      _Cell("${r.present}"),
      _Cell("${r.total}"),
      _Cell("${r.percentage}%"),
    ],
  );



  void _exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) {
          return pw.Table.fromTextArray(
            headers: ['Staff', 'Role', 'Present', 'Total', '%'],
            data: controller.reportRows.map((r) {
              return [
                r.staffName,
                r.role,
                r.present.toString(),
                r.total.toString(),
                "${r.staffName}%",
              ];
            }).toList(),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (_) => pdf.save());
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
