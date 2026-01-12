import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color primary = Color(0xFF00b894); // purple like screenshot
  static const Color inactive = Color(0xFF7A7A7A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _item(LucideIcons.house, "Home", 0),
          _item(LucideIcons.graduationCap, "Student", 1),

          // Center Attendance Button (same level)
          Expanded(
            child: InkWell(
              onTap: () => onTap(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 7.h,
                    width: 7.h,
                    decoration: const BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.squareCheckBig,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _item(LucideIcons.idCardLanyard, "Staff", 3),
          _item(LucideIcons.userStar, "Profile", 4),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String label, int index) {
    final bool active = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: active ? primary : inactive,
            ),
            SizedBox(height: 0.6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight:
                active ? FontWeight.w700 : FontWeight.w400,
                color: active ? primary : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class CustomBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//
//   const CustomBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   static const Color _activeBg = Color(0xFFEEF2FF);
//   static const Color _activeColor = Color(0xFF3F51B5);
//   static const Color _inactiveColor = Color(0xFF8A8A8A);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 8.h,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Color(0xFFE0E0E0)),
//         ),
//       ),
//       child: Row(
//         children: [
//           _item(Icons.dashboard, "Dashboard", 0),
//           _item(Icons.school, "Students", 1),
//           _item(Icons.people, "Staff", 2),
//           _item(Icons.assignment_turned_in, "Attendance", 3),
//         ],
//       ),
//     );
//   }
//
//   Widget _item(IconData icon, String label, int index) {
//     final bool active = index == currentIndex;
//
//     return Expanded(
//       child: InkWell(
//         onTap: () => onTap(index),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeOut,
//           decoration: BoxDecoration(
//             color: active ? _activeBg : Colors.transparent,
//             border: Border(
//               top: BorderSide(
//                 color: active ? _activeColor : Colors.transparent,
//                 width: 3,
//               ),
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 22.sp,
//                 color: active ? _activeColor : _inactiveColor,
//               ),
//               SizedBox(height: 0.6.h),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11.sp,
//                   fontWeight:
//                   active ? FontWeight.w600 : FontWeight.w400,
//                   color: active ? _activeColor : _inactiveColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class CustomBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//
//   const CustomBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 8.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 12,
//             offset: const Offset(0, -2),
//           ),
//         ],
//         borderRadius: const BorderRadius.vertical(
//           top: Radius.circular(22),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _navItem(Icons.dashboard, "Dashboard", 0),
//           _navItem(Icons.school, "Students", 1),
//           _navItem(Icons.people, "Staff", 2),
//           _navItem(Icons.assignment_turned_in, "Attendance", 3),
//         ],
//       ),
//     );
//   }
//
//   Widget _navItem(IconData icon, String label, int index) {
//     final bool isActive = index == currentIndex;
//
//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         padding: EdgeInsets.symmetric(
//           horizontal: isActive ? 4.w : 0,
//           vertical: 1.h,
//         ),
//         decoration: BoxDecoration(
//           color: isActive ? Colors.blue.withOpacity(0.15) : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isActive ? Colors.blue : Colors.grey,
//               size: 20.sp,
//             ),
//             SizedBox(height: 0.3.h),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: isActive ? Colors.blue : Colors.grey,
//                 fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
