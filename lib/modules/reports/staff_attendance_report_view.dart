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


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../../widgets/custom_header.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// import 'controller/staff_attendance_report_controller.dart';
//
// class StaffAttendanceReportView extends StatefulWidget {
//   const StaffAttendanceReportView({super.key});
//
//   @override
//   State<StaffAttendanceReportView> createState() =>
//       _StaffAttendanceReportViewState();
// }
//
// class _StaffAttendanceReportViewState
//     extends State<StaffAttendanceReportView> {
//   final controller = Get.put(StaffAttendanceReportController());
//   final primary = const Color(0xFF00b894);
//
//   @override
//   void initState() {
//     super.initState();
//       controller.fetchReport();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: primary,
//         icon: const Icon(Icons.picture_as_pdf),
//         label: const Text("Export PDF"),
//         onPressed: () => _exportPdf(),
//       ),
//       body: Column(
//         children: [
//           const CustomHeader(
//             title: "Staff Attendance",
//             subtitle: "Daily • Weekly • Monthly",
//           ),
//           _periodSelector(),
//           Expanded(child: _table()),
//         ],
//       ),
//     );
//   }
//
//   Widget _periodSelector() {
//     return Obx(() {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: 4.w),
//         child: Row(
//           children: ReportPeriod.values.map((p) {
//             final active = controller.selectedPeriod.value == p;
//             return Padding(
//               padding: EdgeInsets.only(right: 2.w),
//               child: ChoiceChip(
//                 label: Text(p.name.capitalizeFirst!),
//                 selected: active,
//                 selectedColor: primary.withOpacity(0.15),
//                 onSelected: (_) => controller.changePeriod(p),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     });
//   }
//
//   Widget _table() {
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       if (controller.reportRows.isEmpty) {
//         return const Center(child: Text("No data available"));
//       }
//
//       return SingleChildScrollView(
//         padding: EdgeInsets.all(4.w),
//         child: Table(
//           border: TableBorder.all(color: Colors.grey.shade300),
//           columnWidths: const {
//             0: FlexColumnWidth(2),
//             1: FlexColumnWidth(2),
//             2: FlexColumnWidth(1),
//             3: FlexColumnWidth(1),
//             4: FlexColumnWidth(1),
//           },
//           children: [
//             _header(),
//             ...controller.reportRows.map(_row),
//           ],
//         ),
//       );
//     });
//   }
//
//   TableRow _header() => TableRow(
//     decoration: BoxDecoration(color: primary.withOpacity(0.08)),
//     children: const [
//       _Cell("Staff"),
//       _Cell("Role"),
//       _Cell("Present"),
//       _Cell("Total"),
//       _Cell("%"),
//     ],
//   );
//
//   TableRow _row(StaffReportRow r) => TableRow(
//     children: [
//       _Cell(r.staffName),
//       _Cell(r.role),
//       _Cell("${r.present}"),
//       _Cell("${r.total}"),
//       _Cell("${r.percentage}%"),
//     ],
//   );
//
//
//
//   void _exportPdf() async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         build: (_) {
//           return pw.Table.fromTextArray(
//             headers: ['Staff', 'Role', 'Present', 'Total', '%'],
//             data: controller.reportRows.map((r) {
//               return [
//                 r.staffName,
//                 r.role,
//                 r.present.toString(),
//                 r.total.toString(),
//                 "${r.staffName}%",
//               ];
//             }).toList(),
//           );
//         },
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (_) => pdf.save());
//   }
//
// }
//
// class _Cell extends StatelessWidget {
//   final String text;
//   const _Cell(this.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 1.2.h),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/responses/staff_attandance_report_response.dart';
import '../../widgets/custom_header.dart';
import 'controller/staff_attendance_report_controller.dart';

class StaffAttendanceReportView extends StatefulWidget {
  const StaffAttendanceReportView({super.key});

  @override
  State<StaffAttendanceReportView> createState() =>
      _StaffAttendanceReportViewState();
}

class _StaffAttendanceReportViewState
    extends State<StaffAttendanceReportView> {
  final Color primary = const Color(0xFF00b894);

  final StaffAttendanceReportController controller =
  Get.put(StaffAttendanceReportController());

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
        onPressed: controller.exportPdf,
      ),

      body: Column(
        children: [
          const CustomHeader(
            title: "Staff Attendance",
            subtitle: "Filter by Post & Date Range",
          ),

          _filters(),

          Expanded(child: _table()),
        ],
      ),
    );
  }

  // =====================================================
  // FILTERS
  // =====================================================
  Widget _filters() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
      child: Column(
        children: [
          _postDropdown(),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(child: _toDatePicker()),
              SizedBox(width: 3.w),
              Expanded(child: _fromDatePicker()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postDropdown() {
    return Obx(() {
      final posts = controller.getPostList();

      return DropdownButtonFormField<String>(
        value: controller.selectedPost.value,
        decoration: const InputDecoration(
          labelText: "Post / Designation",
          border: OutlineInputBorder(),
        ),
        items: posts
            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
            .toList(),
        onChanged: (v) {
          controller.selectedPost.value = v;
          controller.applyFilters();
        },
      );
    });
  }

  Widget _toDatePicker() {
    return _datePicker(
      label: "To Date",
      dateRx: controller.toDate,
      onPicked: (d) {
        controller.toDate.value = d;
      },
    );
  }

  Widget _fromDatePicker() {
    return _datePicker(
      label: "From Date",
      dateRx: controller.fromDate,
      onPicked: (d) {
        if (controller.toDate.value == null) {
          Get.snackbar("Validation", "Please select To Date first");
          return;
        }

        if (d.isAfter(controller.toDate.value!)) {
          Get.snackbar(
            "Invalid Date",
            "From Date cannot be after To Date",
          );
          return;
        }

        controller.fromDate.value = d;
        controller.applyFilters();
      },
    );
  }

  Widget _datePicker({
    required String label,
    required Rxn<DateTime> dateRx,
    required Function(DateTime) onPicked,
  }) {
    return Obx(() {
      final date = dateRx.value;

      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now(),
          );
          if (picked != null) onPicked(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            date == null
                ? "Select date"
                : "${date.day}/${date.month}/${date.year}",
          ),
        ),
      );
    });
  }

  // =====================================================
  // TABLE
  // =====================================================
  Widget _table() {
    return Obx(() {
      return SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey.shade300),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _headerRow(),
            ...controller.filteredRecords.map(_dataRow),
          ],
        ),
      );
    });
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: BoxDecoration(color: primary.withOpacity(0.08)),
      children: const [
        _Cell("Staff"),
        _Cell("Post"),
        _Cell("Present"),
        _Cell("Total"),
        _Cell("%"),
      ],
    );
  }

  TableRow _dataRow(StaffReportRecord r) {
    final present = r.status == "present" ? 1 : 0;
    final total = 1;
    final percent = ((present / total) * 100).toStringAsFixed(0);

    return TableRow(
      children: [
        _Cell("Staff ${r.staffId ?? '-'}"),
        _Cell(r.userType ?? ''),
        _Cell("$present"),
        _Cell("$total"),
        _Cell("$percent%"),
      ],
    );
  }
}

// =====================================================
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
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}


