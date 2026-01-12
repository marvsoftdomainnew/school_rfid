import 'package:flutter/material.dart';
import 'package:schoolmsrfid/modules/attendance/mark_attendance_view.dart';
import 'package:schoolmsrfid/modules/settings/settings_view.dart';
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

  final List<Widget> _screens = [
    const DashboardView(),
    const StudentListView(),
    const MarkAttendanceView(),
    const StaffListView(),
    const SettingsView(),
  ];


  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
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
    );
  }
}


