import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schoolmsrfid/modules/attendance/mark_attendance_view.dart';
import 'package:schoolmsrfid/modules/profile/profile_view.dart';
import '../../core/utils/toast_util.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../staff/staff_list_view.dart';
import '../students/student_list_view.dart';
import 'dashboard_view.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}


class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  DateTime? _lastBackPressTime;

  final List<Widget> _screens = [
    const DashboardView(),
    const StudentListView(),
    const MarkAttendanceView(),
    const StaffListView(),
    const ProfileView(),
  ];

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    final now = DateTime.now();

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 3)) {
      _lastBackPressTime = now;

      ToastUtil.show("Press back again to exit");
      return false;
    }
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: CustomBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}



