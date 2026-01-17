import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/responses/staff_attandance_report_response.dart';
import '../../widgets/custom_calendar_picker.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/filter_input_decoration.dart';
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
          SizedBox(height: 1.h,),
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
          _postDropdown(),
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

  Widget _postDropdown() {
    return Obx(() {
      final posts = controller.getPostList();

      return DropdownButtonFormField<String>(
        value: controller.selectedPost.value,
        isDense: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: filterDecoration("Post / Designation"),
        items: posts
            .map(
              (p) => DropdownMenuItem<String>(
            value: p,
            child: Text(
              p,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: (v) {
          controller.selectedPost.value = v;
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
        // padding: EdgeInsets.all(4.w),
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey.shade300),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
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
        _Cell("Staff Name"),
        _Cell("Post"),
        _Cell("Status"),
      ],
    );
  }

  TableRow _dataRow(StaffReportRecord r) {
    final present = r.status == "present" ? 1 : 0;
    final total = 1;
    final percent = ((present / total) * 100).toStringAsFixed(0);

    return TableRow(
      children: [
        _Cell(r.staff?.name ?? "-"),
        _Cell(r.staff?.role ?? "-"),
        _Cell(r.status ?? "-"),
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


