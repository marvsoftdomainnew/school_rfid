import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_header.dart';
import 'controller/school_time_schedule_controller.dart';

class SchoolTimeScheduleView extends StatefulWidget {
  const SchoolTimeScheduleView({super.key});

  @override
  State<SchoolTimeScheduleView> createState() =>
      _SchoolTimeScheduleViewState();
}

class _SchoolTimeScheduleViewState
    extends State<SchoolTimeScheduleView> {
  final controller = Get.put(SchoolTimeScheduleController());


  final Color primary = AppColors.primary;

  Future<void> _pickTime({
    required bool isStart,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dialHandColor: primary,
              dialBackgroundColor: primary.withOpacity(0.1),
              hourMinuteTextColor: primary,
              entryModeIconColor: primary,
            ),
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              onSurface: const Color(0xFF2d3436),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          controller.startTime.value = picked;

          if (controller.endTime.value != null &&
              controller.toMinutes(controller.endTime.value!) <=
                  controller.toMinutes(picked)) {
            controller.endTime.value = null;
          }
        } else {
          if (controller.startTime.value == null) {
            Get.snackbar(
              "Validation",
              "Please select Start Time first",
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          controller.endTime.value = picked;
        }
      });
    }

  }

  String _format(TimeOfDay? t) {
    if (t == null) return "--:--";
    final h = t.hourOfPeriod.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? "AM" : "PM";
    return "$h:$m $p";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            4.w,
            1.h,
            4.w,
            MediaQuery.of(context).padding.bottom ,
          ),
          child: Obx(() => PrimaryButton(
            text: "UPDATE",
            isLoading: controller.isLoading.value,
            onPressed: controller.saveSchedule,
          )),

        ),
      ),

      body: Column(
        children: [
          const CustomHeader(
            title: "Time Schedule",
            subtitle: "Set school working hours",
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 10.h),
              child: Column(
                children: [
                  Obx(() => _timeCard(
                    title: "Start Time",
                    time: _format(controller.startTime.value),
                    onTap: () => _pickTime(isStart: true),
                  )),

                  SizedBox(height: 2.h),

                  Obx(() => _timeCard(
                    title: "End Time",
                    time: _format(controller.endTime.value),
                    onTap: () => _pickTime(isStart: false),
                  )),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ================= TIME CARD =================
  Widget _timeCard({
    required String title,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time,
                color: primary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2d3436),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
