import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import '../../core/utils/toast_util.dart';
import 'controller/attendance_summary_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AttendanceSummaryController summaryController;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _chartController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    summaryController = Get.find<AttendanceSummaryController>();
    // ✅ Register lifecycle observer
    WidgetsBinding.instance.addObserver(this);
    summaryController.fetchSummary();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutCubic,
    );

    _fadeController.forward();
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _chartController.forward();
    });
  }

  // ================= APP LIFECYCLE =================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("📱 App resumed → refreshing dashboard data");
      summaryController.fetchSummary();
    }
  }

  Future<void> _onRefresh() async {
    await summaryController.fetchSummary();
    ToastUtil.success("Dashboard updated");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fadeController.dispose();
    _slideController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    int? index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 700 + (index ?? 0) * 150),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: animValue,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 6.w),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2d3436),
                  ),
                ),
                // SizedBox(height: 0.5.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Option 1: Donut Chart Card
  Widget _buildDonutChartCard({
    required String title,
    required int present,
    required int total,
    required Color color,
    required IconData icon,
    int? index,
  }) {
    final absent = total - present;
    // final percentage = (present / total * 100).toInt();
    final safeTotal = total == 0 ? 1 : total;
    final percentage = ((present / safeTotal) * 100).round();

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index ?? 0) * 200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, (1 - animValue) * 20),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.5.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 6.w),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2d3436),
                              ),
                            ),
                            Text(
                              "Today's Overview",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      // Donut Chart
                      Expanded(
                        flex: 3,
                        child: AnimatedBuilder(
                          animation: _chartAnimation,
                          builder: (context, child) {
                            return SizedBox(
                              height: 20.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(35.w, 35.w),
                                    painter: DonutChartPainter(
                                      present: present,
                                      absent: absent,
                                      color: color,
                                      animationValue: _chartAnimation.value,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$percentage%",
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                      ),
                                      Text(
                                        "Present",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Stats
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildMiniStat(
                              "Present",
                              "$present",
                              color,
                              Icons.check_circle,
                            ),
                            SizedBox(height: 2.h),
                            _buildMiniStat(
                              "Absent",
                              "$absent",
                              Colors.red,
                              Icons.cancel,
                            ),
                            SizedBox(height: 2.h),
                            _buildMiniStat(
                              "Total",
                              "$total",
                              Colors.grey,
                              Icons.people,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Option 2: Bar Chart Card
  Widget _buildBarChartCard({
    required String title,
    required int present,
    required int total,
    required Color color,
    required IconData icon,
    int? index,
  }) {
    final absent = total - present;
    final safeTotal = total == 0 ? 1 : total;
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index ?? 0) * 200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, (1 - animValue) * 20),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.5.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 6.w),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  // Bar Chart
                  AnimatedBuilder(
                    animation: _chartAnimation,
                    builder: (context, child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Present Bar
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "$present",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  // height: (present / total) * 15.h * _chartAnimation.value,
                                  height: (present / safeTotal) * 15.h * _chartAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "Present",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Absent Bar
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "$absent",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  // height: (absent / total) * 15.h * _chartAnimation.value,
                                  height: (absent / safeTotal) * 15.h * _chartAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "Absent",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Total Bar
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "$total",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  height: 15.h * _chartAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  Widget _buildBarChartShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatsGridShimmer() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 3.w,
      mainAxisSpacing: 2.5.h,
      childAspectRatio: 1.15,
      children: List.generate(
        6,
        (_) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                color: const Color(0xFF2d3436),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            color: const Color(0xFF00b894), // primary
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Option 1: Donut Chart for Students
                  Obx(() {
                    if (summaryController.isLoading.value &&
                        !summaryController.hasData) {
                      return _buildDonutChartShimmer();
                    }

                    return _buildDonutChartCard(
                      title: "Students Attendance",
                      present: summaryController.presentStudent.value ?? 0,
                      total: summaryController.student.value ?? 0,
                      color: const Color(0xFF667eea),
                      icon: Icons.school,
                      index: 0,
                    );
                  }),

                  SizedBox(height: 2.5.h),

                  // Option 2: Bar Chart for Staff
                  Obx(() {
                    if (summaryController.isLoading.value &&
                        !summaryController.hasData) {
                      return _buildBarChartShimmer();
                    }

                    return _buildBarChartCard(
                      title: "Staff Attendance",
                      present: summaryController.presentStaff.value ?? 0,
                      total: summaryController.staff.value ?? 0,
                      color: const Color(0xFF00b894),
                      icon: Icons.badge,
                      index: 1,
                    );
                  }),

                  SizedBox(height: 3.h),

                  // Quick Stats Header
                  Row(
                    children: [
                      Container(
                        width: 1.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Quick Statistics",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2d3436),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Stats Grid
                  Obx(() {
                    if (summaryController.isLoading.value &&
                        !summaryController.hasData) {
                      return _buildStatsGridShimmer();
                    }

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.5.h,
                      childAspectRatio: 1.15,
                      children: [
                        _buildStatCard(
                          title: "Total Students",
                          value: "${summaryController.student.value ?? 0}",
                          color: const Color(0xFF667eea),
                          icon: Icons.school,
                        ),
                        _buildStatCard(
                          title: "Total Staff",
                          value: "${summaryController.staff.value ?? 0}",
                          color: const Color(0xFF00b894),
                          icon: Icons.people,
                        ),
                        _buildStatCard(
                          title: "Present Students",
                          value:
                              "${summaryController.presentStudent.value ?? 0}",
                          color: const Color(0xFF55efc4),
                          icon: Icons.check_circle,
                        ),
                        _buildStatCard(
                          title: "Absent Students",
                          value:
                              "${summaryController.absentStudent.value ?? 0}",
                          color: const Color(0xFFff7675),
                          icon: Icons.cancel,
                        ),
                        _buildStatCard(
                          title: "Present Staff",
                          value: "${summaryController.presentStaff.value ?? 0}",
                          color: const Color(0xFF74b9ff),
                          icon: Icons.badge,
                        ),
                        _buildStatCard(
                          title: "Absent Staff",
                          value: "${summaryController.absentStaff.value ?? 0}",
                          color: const Color(0xFFfdcb6e),
                          icon: Icons.warning,
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  final int present;
  final int absent;
  final Color color;
  final double animationValue;

  DonutChartPainter({
    required this.present,
    required this.absent,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // final total = present + absent;
    // final presentAngle = (present / total) * 2 * math.pi * animationValue;
    // final absentAngle = (absent / total) * 2 * math.pi * animationValue;
    final total = present + absent;
    if (total == 0) return; // ✅ critical fix

    final presentAngle =
        (present / total) * 2 * math.pi * animationValue;
    final absentAngle =
        (absent / total) * 2 * math.pi * animationValue;


    // Background circle
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Present arc
    final presentPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      presentAngle,
      false,
      presentPaint,
    );

    // Absent arc
    final absentPaint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2 + presentAngle,
      absentAngle,
      false,
      absentPaint,
    );
  }

  @override
  bool shouldRepaint(DonutChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
