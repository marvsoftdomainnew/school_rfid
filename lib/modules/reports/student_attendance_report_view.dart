import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_calendar_picker.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/filter_input_decoration.dart';
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
          SizedBox(height: 1.h),
          Expanded(child: _table()),
        ],
      ),
    );
  }

  // FILTERS
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
              Expanded(child: _fromDatePicker()),
              SizedBox(width: 3.w),
              Expanded(child: _toDatePicker()),
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
        isDense: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: filterDecoration("Class"),
        items: classes
            .map(
              (c) => DropdownMenuItem<String>(
            value: c,
            child: Text(
              "Class $c",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: (v) {
          controller.selectedClass.value = v;
          controller.applyFilters();
        },
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2d3436),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(14),
      );
    });
  }

  Widget _sectionDropdown() {
    return Obx(() {
      final sections = controller.getSectionList();

      return DropdownButtonFormField<String>(
        value: controller.selectedSection.value,
        isDense: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: filterDecoration("Section"),
        items: sections
            .map(
              (s) => DropdownMenuItem<String>(
            value: s,
            child: Text(
              "Section $s",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: (v) {
          controller.selectedSection.value = v;
          controller.applyFilters();
        },
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2d3436),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(14),
      );
    });
  }

  Widget _toDatePicker() {
    return _datePicker(
      label: "End Date",
      dateRx: controller.toDate,
      onPicked: (d) {
        final startDate = controller.fromDate.value;

        // ❌ Start Date not selected yet
        if (startDate == null) {
          Get.snackbar(
            "Validation",
            "Please select Start Date first",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // ❌ End Date cannot be before Start Date
        if (d.isBefore(startDate)) {
          Get.snackbar(
            "Invalid Date",
            "End Date must be after Start Date",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        controller.toDate.value = d;
        controller.applyFilters();
      },
    );
  }


  Widget _fromDatePicker() {
    return _datePicker(
      label: "Start Date",
      dateRx: controller.fromDate,
      onPicked: (d) {
        final endDate = controller.toDate.value;

        // ❌ Start Date cannot be after End Date
        if (endDate != null && d.isAfter(endDate)) {
          Get.snackbar(
            "Invalid Date",
            "Start Date must be before End Date",
            snackPosition: SnackPosition.BOTTOM,
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

      return SizedBox(
        height: 6.h,
        child: InkWell(
          onTap: () async {
            final picked = await showModalBottomSheet<DateTime>(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) {
                return CustomCalendarPicker(
                  initialDate: dateRx.value,
                  firstDate: DateTime(2022),
                  lastDate: DateTime.now(),
                );
              },
            );

            if (picked != null) onPicked(picked);
          },
          child: InputDecorator(
            decoration: filterDecoration(label).copyWith(
              // ❌ CLEAR ICON
              suffixIcon: date == null
                  ? null
                  : IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.grey,
                ),
                onPressed: () {
                  dateRx.value = null;     // clear date
                  controller.applyFilters(); // show all data
                },
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                date == null
                    ? "Select date"
                    : "${date.day}/${date.month}/${date.year}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: date == null
                      ? Colors.grey[500]
                      : const Color(0xFF2d3436),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // TABLE
  Widget _table() {
    return Obx(() {
      return SingleChildScrollView(
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
        _Cell("Student Name"),
        _Cell("Class"),
        _Cell("Section"),
        _Cell("Status"),
      ],
    );
  }

  TableRow _dataRow(record) {
    return TableRow(
      children: [
        _Cell(record.student?.name ?? "-"),
        _Cell(record.student?.className ?? "-"),
        _Cell(record.student?.section ?? "-"),
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


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../widgets/custom_header.dart';
// import '../../widgets/filter_input_decoration.dart';
// import 'controller/student_attendance_report_controller.dart';
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
//   final controller =
//   Get.put(StudentAttendanceReportController());
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
//         onPressed: controller.exportPdf,
//       ),
//
//       body: Column(
//         children: [
//           const CustomHeader(
//             title: "Student Attendance",
//             subtitle: "Filter by Class, Section & Date",
//           ),
//
//           _filters(),
//
//           Expanded(child: _table()),
//         ],
//       ),
//     );
//   }
//
//   // =====================================================
//   // FILTERS
//   // =====================================================
//   Widget _filters() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: _classDropdown()),
//               SizedBox(width: 3.w),
//               Expanded(child: _sectionDropdown()),
//             ],
//           ),
//           SizedBox(height: 1.5.h),
//           Row(
//             children: [
//               Expanded(child: _fromDatePicker()),
//               SizedBox(width: 3.w),
//               Expanded(child: _toDatePicker()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _classDropdown() {
//     return Obx(() {
//       final classes = controller.getClassList();
//
//       return DropdownButtonFormField<String>(
//         value: controller.selectedClass.value,
//         isDense: true,
//         icon: const Icon(Icons.keyboard_arrow_down_rounded),
//         decoration: filterDecoration("Class"),
//         items: classes
//             .map(
//               (c) => DropdownMenuItem<String>(
//             value: c,
//             child: Text(
//               "Class $c",
//               style: TextStyle(
//                 fontSize: 13.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         )
//             .toList(),
//         onChanged: (v) {
//           controller.selectedClass.value = v;
//           controller.applyFilters();
//         },
//         style: TextStyle(
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF2d3436),
//         ),
//         dropdownColor: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       );
//     });
//   }
//
//
//   Widget _sectionDropdown() {
//     return Obx(() {
//       final sections = controller.getSectionList();
//
//       return DropdownButtonFormField<String>(
//         value: controller.selectedSection.value,
//         isDense: true,
//         icon: const Icon(Icons.keyboard_arrow_down_rounded),
//         decoration: filterDecoration("Section"),
//         items: sections
//             .map(
//               (s) => DropdownMenuItem<String>(
//             value: s,
//             child: Text(
//               "Section $s",
//               style: TextStyle(
//                 fontSize: 13.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         )
//             .toList(),
//         onChanged: (v) {
//           controller.selectedSection.value = v;
//           controller.applyFilters();
//         },
//         style: TextStyle(
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w600,
//           color: const Color(0xFF2d3436),
//         ),
//         dropdownColor: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       );
//     });
//   }
//
//   Widget _toDatePicker() {
//     return _datePicker(
//       label: "To Date",
//       dateRx: controller.toDate,
//       onPicked: (d) => controller.toDate.value = d,
//     );
//   }
//
//   Widget _fromDatePicker() {
//     return _datePicker(
//       label: "From Date",
//       dateRx: controller.fromDate,
//       onPicked: (d) {
//         if (controller.toDate.value == null) {
//           Get.snackbar("Validation", "Please select To Date first");
//           return;
//         }
//         if (d.isAfter(controller.toDate.value!)) {
//           Get.snackbar(
//               "Invalid Date", "From Date cannot be after To Date");
//           return;
//         }
//         controller.fromDate.value = d;
//         controller.applyFilters();
//       },
//     );
//   }
//
//   Widget _datePicker({
//     required String label,
//     required Rxn<DateTime> dateRx,
//     required Function(DateTime) onPicked,
//   }) {
//     return Obx(() {
//       final date = dateRx.value;
//
//       return SizedBox(
//         height: 6.h,
//         child: InkWell(
//           onTap: () async {
//             final picked = await showDatePicker(
//               context: context,
//               initialDate: date ?? DateTime.now(),
//               firstDate: DateTime(2022),
//               lastDate: DateTime.now(),
//             );
//             if (picked != null) onPicked(picked);
//           },
//           child: InputDecorator(
//             decoration: filterDecoration(label),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 date == null
//                     ? "Select date"
//                     : "${date.day}/${date.month}/${date.year}",
//                 style: TextStyle(
//                   fontSize: 13.sp,
//                   fontWeight: FontWeight.w600,
//                   color: date == null
//                       ? Colors.grey[500]
//                       : const Color(0xFF2d3436),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//
//
//   // =====================================================
//   // TABLE
//   // =====================================================
//   Widget _table() {
//     return Obx(() {
//       return SingleChildScrollView(
//         padding: EdgeInsets.all(4.w),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Table(
//             border: TableBorder.symmetric(
//               inside: BorderSide(color: Colors.grey.shade300),
//             ),
//             defaultColumnWidth: const FixedColumnWidth(120),
//             children: [
//               _headerRow(),
//               ...controller.filteredRecords.map(_dataRow),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//
//   TableRow _headerRow() {
//     return TableRow(
//       decoration: BoxDecoration(color: primary.withOpacity(0.08)),
//       children: const [
//         _Cell("Date"),
//         _Cell("Student Name"),
//         _Cell("Roll No"),
//         _Cell("Class"),
//         _Cell("Section"),
//         _Cell("Status"),
//         _Cell("In Time"),
//         _Cell("Out Time"),
//         _Cell("Duration"),
//         _Cell("RFID"),
//       ],
//     );
//   }
//
//
//   TableRow _dataRow(record) {
//     return TableRow(
//       children: [
//         _Cell(record.attendanceDate != null
//             ? "${record.attendanceDate!.day}/${record.attendanceDate!.month}/${record.attendanceDate!.year}"
//             : "-"),
//
//         _Cell(record.student?.name ?? "-"),
//
//         _Cell(record.student?.studentId?.toString() ?? "-"),
//
//         _Cell(record.student?.className ?? record.className ?? "-"),
//
//         _Cell(record.student?.section ?? record.section ?? "-"),
//
//         _Cell(record.status ?? "-"),
//
//         _Cell(record.inTime ?? "-"),
//
//         _Cell(record.outTime ?? "-"),
//
//         _Cell(record.workingMinutes != null
//             ? "${record.workingMinutes} min"
//             : "-"),
//
//         _Cell(record.rfidNumber ?? "-"),
//       ],
//     );
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
//           style: TextStyle(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }

