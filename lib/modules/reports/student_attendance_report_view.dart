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




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import '../../widgets/custom_header.dart';
// import 'controller/student_attendance_report_controller.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
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
//   final controller = Get.put(StudentAttendanceReportController());
//   final primary = const Color(0xFF00b894);
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchReport();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: primary,
//         icon: const Icon(Icons.picture_as_pdf),
//         label: const Text("Export PDF"),
//         onPressed: _exportPdf,
//       ),
//
//       body: Column(
//         children: [
//           const CustomHeader(
//             title: "Student Attendance",
//             subtitle: "Daily • Weekly • Monthly",
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
//       if (controller.tableRows.isEmpty) {
//         return const Center(child: Text("No data available"));
//       }
//
//       return SingleChildScrollView(
//         padding: EdgeInsets.all(4.w),
//         child: Table(
//           border: TableBorder.all(color: Colors.grey.shade300),
//           columnWidths: const {
//             0: FlexColumnWidth(2),
//             1: FlexColumnWidth(1),
//             2: FlexColumnWidth(1),
//             3: FlexColumnWidth(1),
//           },
//           children: [
//             _header(),
//             ...controller.tableRows.map(_row),
//           ],
//         ),
//       );
//     });
//   }
//
//   TableRow _header() => TableRow(
//     decoration: BoxDecoration(color: primary.withOpacity(0.08)),
//     children: const [
//       _Cell("Student"),
//       _Cell("Present"),
//       _Cell("Total"),
//       _Cell("%"),
//     ],
//   );
//
//   TableRow _row(StudentReportRow r) => TableRow(
//     children: [
//       _Cell(r.name),
//       _Cell("${r.present}"),
//       _Cell("${r.total}"),
//       _Cell("${r.percent}%"),
//     ],
//   );
//
//   Future<void> _exportPdf() async {
//     final pdf = pw.Document();
//
//     pdf.addPage(
//       pw.Page(
//         build: (_) {
//           return pw.Table.fromTextArray(
//             headers: ['Student', 'Present', 'Total', '%'],
//             data: controller.tableRows.map((r) {
//               return [
//                 r.name,
//                 r.present.toString(),
//                 r.total.toString(),
//                 "${r.percent}%",
//               ];
//             }).toList(),
//           );
//         },
//       ),
//     );
//
//     try {
//       await Printing.layoutPdf(onLayout: (_) => pdf.save());
//     } catch (_) {
//       Get.snackbar(
//         "PDF Error",
//         "PDF service not available on this device",
//       );
//     }
//   }
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

import '../../widgets/custom_header.dart';
import 'controller/student_attendance_report_controller.dart';

class StudentAttendanceReportView extends StatefulWidget {
  const StudentAttendanceReportView({super.key});

  @override
  State<StudentAttendanceReportView> createState() =>
      _StudentAttendanceReportViewState();
}

class _StudentAttendanceReportViewState
    extends State<StudentAttendanceReportView> {
  final Color primary = const Color(0xFF00b894);

  final controller =
  Get.put(StudentAttendanceReportController());

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
            title: "Student Attendance",
            subtitle: "Filter by Class, Section & Date",
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
          Row(
            children: [
              Expanded(child: _classDropdown()),
              SizedBox(width: 3.w),
              Expanded(child: _sectionDropdown()),
            ],
          ),
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

  Widget _classDropdown() {
    return Obx(() {
      final classes = controller.getClassList();

      return DropdownButtonFormField<String>(
        value: controller.selectedClass.value,
        decoration: const InputDecoration(
          labelText: "Class",
          border: OutlineInputBorder(),
        ),
        items: classes
            .map((c) => DropdownMenuItem(
          value: c,
          child: Text("Class $c"),
        ))
            .toList(),
        onChanged: (v) {
          controller.selectedClass.value = v;
          controller.applyFilters();
        },
      );
    });
  }

  Widget _sectionDropdown() {
    return Obx(() {
      final sections = controller.getSectionList();

      return DropdownButtonFormField<String>(
        value: controller.selectedSection.value,
        decoration: const InputDecoration(
          labelText: "Section",
          border: OutlineInputBorder(),
        ),
        items: sections
            .map((s) => DropdownMenuItem(
          value: s,
          child: Text("Section $s"),
        ))
            .toList(),
        onChanged: (v) {
          controller.selectedSection.value = v;
          controller.applyFilters();
        },
      );
    });
  }

  Widget _toDatePicker() {
    return _datePicker(
      label: "To Date",
      dateRx: controller.toDate,
      onPicked: (d) => controller.toDate.value = d,
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
              "Invalid Date", "From Date cannot be after To Date");
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
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
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
        _Cell("Student ID"),
        _Cell("Class"),
        _Cell("Section"),
        _Cell("Status"),
      ],
    );
  }

  TableRow _dataRow(record) {
    return TableRow(
      children: [
        _Cell(record.userId?.toString() ?? "-"),
        _Cell(record.className ?? "-"),
        _Cell(record.section ?? "-"),
        _Cell(record.status ?? "-"),
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
