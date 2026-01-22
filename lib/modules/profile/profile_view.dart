import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/modules/profile/school_time_schedule_view.dart';
import 'package:schoolmsrfid/modules/reports/staff_attendance_report_view.dart';
import 'package:schoolmsrfid/modules/reports/student_attendance_report_view.dart';
import 'package:sizer/sizer.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_controller.dart';
import '../auth/controller/logout_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ThemeController themeController = Get.find();
  final Color primary = const Color(0xFF00b894);
  bool isDarkMode = false;
  final LogoutController logoutController = Get.find();


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              const Text("Logout"),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout from this account?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                logoutController.logout();
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 3.h),
              children: [
                // _sectionTitle("Account"),
                // _settingItem(
                //   icon: Icons.lock_outline,
                //   title: "Change Password",
                //   onTap: () {Get.to(
                //         () => const ChangePasswordView(),
                //     transition: Transition.cupertino,
                //   );},
                // ),
                //
                // SizedBox(height: 2.h),

                _sectionTitle("Reports"),
                _settingItem(
                  icon: Icons.badge_outlined,
                  title: "Staff Attendance Report",
                  onTap: () {Get.to(
                        () => const StaffAttendanceReportView(),
                    transition: Transition.cupertino,
                  );},
                ),
                _settingItem(
                  icon: Icons.assignment_turned_in_outlined,
                  title: "Student Attendance Report",
                  onTap: () {Get.to(
                        () => const StudentAttendanceReportView(),
                    transition: Transition.cupertino,
                  );},
                ),

                _sectionTitle("Settings"),
                _settingItem(
                  icon: Icons.schedule,
                  title: "School Time Schedule",
                  onTap: () {
                    Get.to(
                          () => const SchoolTimeScheduleView(),
                      transition: Transition.cupertino,
                    );
                  },
                ),

                // SizedBox(height: 2.h),

                // _sectionTitle("Preferences"),
                // _toggleItem(
                //   icon: Icons.dark_mode_outlined,
                //   title: "Dark Mode",
                // ),

                SizedBox(height: 3.h),

                _sectionTitle("Danger Zone"),
                _settingItem(
                  icon: Icons.logout,
                  title: "Logout",
                  titleColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 10.h, 4.w, 3.h),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withOpacity(0.1),
              border: Border.all(color: primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.25),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 10.w,
              color: primary,
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            "School Admin",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2d3436),
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            "+91 9876543210",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  // ================= NORMAL ITEM =================
  Widget _settingItem({
    required IconData icon,
    required String title,
    Color? titleColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.4.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.2.w),
              decoration: BoxDecoration(
                color: (iconColor ?? primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? const Color(0xFF2d3436),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // ================= TOGGLE ITEM =================
  Widget _toggleItem({
    required IconData icon,
    required String title,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.2.w),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primary,
              size: 5.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2d3436),
              ),
            ),
          ),
          Switch(
            value: themeController.isDarkMode,
            activeColor: AppColors.primary,
            onChanged: (_) {
              themeController.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
