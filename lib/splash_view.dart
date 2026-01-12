import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'core/constants/app_keys.dart';
import 'core/services/sharedpreferences_service.dart';
import 'routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  final Color primary = const Color(0xFF00b894);

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _decideNavigation();
  }

  Future<void> _decideNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferencesService.getInstance();
    final bool isLogin = prefs.getBool(AppKeys.isLogin) ?? false;

    if (isLogin) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: SplashWavePainter(primary),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ===== ICON =====
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withOpacity(0.35),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ===== APP NAME =====
                    Text(
                      "School Management",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2d3436),
                        letterSpacing: 0.6,
                      ),
                    ),

                    SizedBox(height: 0.6.h),

                    Text(
                      "RFID Attendance System",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashWavePainter extends CustomPainter {
  final Color color;

  SplashWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(0.12);

    final path = Path();
    path.moveTo(0, size.height * 0.25);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.15,
      size.width,
      size.height * 0.3,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});
//
//   @override
//   State<SplashView> createState() => _SplashViewState();
// }
//
// class _SplashViewState extends State<SplashView>
//     with SingleTickerProviderStateMixin {
//   final Color primary = const Color(0xFF00b894);
//
//   late AnimationController _controller;
//   bool showLogo = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2800),
//     )..addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() => showLogo = true);
//       }
//     });
//
//     _controller.forward();
//
//     Future.delayed(const Duration(seconds: 4), () {
//       // Get.offAllNamed(AppRoutes.login);
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 180,
//               height: 180,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // ===== RFID RIPPLE =====
//                   CustomPaint(
//                     size: const Size(180, 180),
//                     painter: RfidRipplePainter(
//                       animation: _controller,
//                       color: primary,
//                     ),
//                   ),
//
//                   // ===== LOGO LINE DRAW =====
//                   CustomPaint(
//                     size: const Size(150, 150),
//                     painter: LogoLinePainter(
//                       animation: _controller,
//                       color: primary,
//                     ),
//                   ),
//
//                   // ===== FINAL IMAGE =====
//                   AnimatedOpacity(
//                     opacity: showLogo ? 1 : 0,
//                     duration: const Duration(milliseconds: 500),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(24),
//                       child: Image.asset(
//                         'assets/images/logo.png',
//                         width: 130,
//                         height: 130,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: 3.h),
//
//             Text(
//               "School Management",
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.6,
//                 color: const Color(0xFF2d3436),
//               ),
//             ),
//
//             SizedBox(height: 0.6.h),
//
//             Text(
//               "RFID Attendance System",
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RfidRipplePainter extends CustomPainter {
//   final Animation<double> animation;
//   final Color color;
//
//   RfidRipplePainter({
//     required this.animation,
//     required this.color,
//   }) : super(repaint: animation);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final maxRadius = size.width / 2;
//
//     for (int i = 0; i < 3; i++) {
//       final progress = (animation.value + (i * 0.25)) % 1;
//       final radius = progress * maxRadius;
//
//       final paint = Paint()
//         ..color = color.withOpacity((1 - progress) * 0.25)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2;
//
//       canvas.drawCircle(center, radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
//
// class LogoLinePainter extends CustomPainter {
//   final Animation<double> animation;
//   final Color color;
//
//   LogoLinePainter({
//     required this.animation,
//     required this.color,
//   }) : super(repaint: animation);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3
//       ..strokeCap = StrokeCap.round;
//
//     final rect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
//       const Radius.circular(24),
//     );
//
//     final path = Path()..addRRect(rect);
//     final metric = path.computeMetrics().first;
//
//     final extractPath = metric.extractPath(
//       0,
//       metric.length * animation.value,
//     );
//
//     canvas.drawPath(extractPath, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }




