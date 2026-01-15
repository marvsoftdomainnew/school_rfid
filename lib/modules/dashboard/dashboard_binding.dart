import 'package:get/get.dart';
import 'package:schoolmsrfid/modules/dashboard/controller/attendance_summary_controller.dart';

import '../auth/controller/logout_controller.dart';
import '../staff/controller/staff_list_controller.dart';
import '../students/controller/student_list_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogoutController>(() => LogoutController(), fenix: true);
    Get.lazyPut<AttendanceSummaryController>(() => AttendanceSummaryController(), fenix: true);
    Get.lazyPut<StudentListController>(() => StudentListController(),);
    Get.lazyPut<StaffListController>(() => StaffListController(),);
  }
}
