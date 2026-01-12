import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

import 'controller/mark_attendance_controller.dart';

class MarkAttendanceView extends StatefulWidget {
  const MarkAttendanceView({super.key});

  @override
  State<MarkAttendanceView> createState() => _MarkAttendanceViewState();
}

class _MarkAttendanceViewState extends State<MarkAttendanceView>
    with SingleTickerProviderStateMixin {
  final Color primary = const Color(0xFF00b894);

  late AnimationController _pulseController;
  final TextEditingController rfidController = TextEditingController();
  final MarkAttendanceController controller = Get.put(MarkAttendanceController());

  final FocusNode _focusNode = FocusNode();

  String _buffer = "";
  bool cardDetected = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    /// IMPORTANT: focus lena zaruri hai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    rfidController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // =====================================================
  // 🔥 REAL RFID HANDLING (NO AUTO, NO TIMER)
  // =====================================================

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.enter) {
        if (_buffer.isNotEmpty && !controller.isProcessing.value) {
          final scannedRfid = _buffer;

          setState(() {
            cardDetected = true;
            rfidController.text = scannedRfid;
          });

          // 🔥 HIT API
          controller.markAttendance(scannedRfid);

          // 🔄 RESET AFTER SHORT DELAY
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;

            setState(() {
              cardDetected = false;
              rfidController.clear();
            });

            _buffer = "";

            // 🎯 focus back for next scan
            _focusNode.requestFocus();
          });
        }
      } else if (key == LogicalKeyboardKey.backspace) {
        if (_buffer.isNotEmpty) {
          _buffer = _buffer.substring(0, _buffer.length - 1);
        }
      } else {
        final char = event.character;
        if (char != null && RegExp(r'[0-9A-Za-z]').hasMatch(char)) {
          _buffer += char;
        }
      }
    }
  }

  // void _onKey(RawKeyEvent event) {
  //   if (event is RawKeyDownEvent) {
  //     final key = event.logicalKey;
  //
  //     // ENTER = card complete
  //     if (key == LogicalKeyboardKey.enter) {
  //       if (_buffer.isNotEmpty) {
  //         setState(() {
  //           cardDetected = true;
  //           rfidController.text = _buffer;
  //         });
  //
  //         // 🔗 YAHAN API CALL KAROGE
  //         // sendRfidToServer(_buffer);
  //
  //         _buffer = "";
  //       }
  //     }
  //     // BACKSPACE ignore
  //     else if (key == LogicalKeyboardKey.backspace) {
  //       if (_buffer.isNotEmpty) {
  //         _buffer = _buffer.substring(0, _buffer.length - 1);
  //       }
  //     }
  //     // DIGITS collect
  //     else {
  //       final char = event.character;
  //       if (char != null && RegExp(r'[0-9A-Za-z]').hasMatch(char)) {
  //         _buffer += char;
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: _onKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              children: [
                SizedBox(height: 6.h),

                // ===== TITLE =====
                Text(
                  "Mark Attendance",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2d3436),
                  ),
                ),

                SizedBox(height: 1.h),

                // ===== INSTRUCTION =====
                Text(
                  cardDetected
                      ? "Card detected successfully.\nPlease wait while we process attendance."
                      : "RFID device is not connected.\nPlease tap your card on the reader.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.4,
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(height: 6.h),

                // ===== RFID VISUAL =====
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) {
                    final scale = 1 + (_pulseController.value * 0.08);

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 58.w,
                        height: 58.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withOpacity(0.08),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.25),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Lottie.asset(
                          'assets/lottie/rfid_scan.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // ===== STATUS TEXT =====
                Obx(() {
                  return Text(
                    controller.isProcessing.value
                        ? "Processing attendance…"
                        : cardDetected
                        ? "RFID Card Tap Detected"
                        : "Waiting for card tap…",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: controller.isProcessing.value
                          ? primary
                          : cardDetected
                          ? primary
                          : Colors.grey,
                    ),
                  );
                }),


                SizedBox(height: 6.h),

                // ===== RFID FIELD =====
                TextField(
                  controller: rfidController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "RFID Number",
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.credit_card,
                      color: primary,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F3F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                // ===== FOOTER NOTE =====
                Text(
                  "Attendance will be marked automatically\nonce card is detected.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class MarkAttendanceView extends StatefulWidget {
//   const MarkAttendanceView({super.key});
//
//   @override
//   State<MarkAttendanceView> createState() => _MarkAttendanceViewState();
// }
//
// class _MarkAttendanceViewState extends State<MarkAttendanceView>
//     with SingleTickerProviderStateMixin {
//   final Color primary = const Color(0xFF00b894);
//
//   bool isStudent = true;
//   String search = "";
//
//   late AnimationController _tabController;
//
//   // ================= DUMMY DATA =================
//   final List<Map<String, dynamic>> students = List.generate(40, (i) {
//     return {
//       "name": "Student ${i + 1}",
//       "class": "Class ${i % 5 + 1}",
//       "section": ["A", "B", "C"][i % 3],
//       "marked": false,
//     };
//   });
//
//   final List<Map<String, dynamic>> staff = List.generate(30, (i) {
//     return {
//       "name": "Staff ${i + 1}",
//       "designation": [
//         "Teacher",
//         "Clerk",
//         "Principal",
//         "Peon"
//       ][i % 4],
//       "marked": false,
//     };
//   });
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // ================= CONFIRM DIALOG =================
//   void _confirmMark(int index, bool isStudentItem) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Confirm Attendance"),
//         content: const Text("Mark this person as PRESENT?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 if (isStudentItem) {
//                   students[index]["marked"] = true;
//                 } else {
//                   staff[index]["marked"] = true;
//                 }
//               });
//               Navigator.pop(context);
//             },
//             style: TextButton.styleFrom(foregroundColor: primary),
//             child: const Text("Confirm"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final list = isStudent ? students : staff;
//
//     final filtered = list.where((e) {
//       return e["name"]
//           .toString()
//           .toLowerCase()
//           .contains(search.toLowerCase());
//     }).toList();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       body: Column(
//         children: [
//           _header(),
//           _tabSwitch(),
//           if (isStudent) _filters(),
//           _searchBox(),
//           Expanded(child: _grid(filtered)),
//         ],
//       ),
//     );
//   }
//
//   // ================= HEADER =================
//   Widget _header() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
//       child: Text(
//         "Mark Attendance",
//         style: TextStyle(
//           fontSize: 18.sp,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
//
//   // ================= TAB SWITCH =================
//   Widget _tabSwitch() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 4.w),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           children: [
//             _tabItem("Students", isStudent, () {
//               setState(() => isStudent = true);
//             }),
//             _tabItem("Staff", !isStudent, () {
//               setState(() => isStudent = false);
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _tabItem(String title, bool active, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           padding: EdgeInsets.symmetric(vertical: 1.6.h),
//           decoration: BoxDecoration(
//             color: active ? primary : Colors.transparent,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: active ? Colors.white : Colors.black87,
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= FILTERS =================
//   Widget _filters() {
//     return Padding(
//       padding: EdgeInsets.all(4.w),
//       child: Row(
//         children: [
//           _dropdown("Class"),
//           SizedBox(width: 3.w),
//           _dropdown("Section"),
//         ],
//       ),
//     );
//   }
//
//   Widget _dropdown(String hint) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 3.w),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             hint: Text(hint),
//             items: ["Option 1", "Option 2"]
//                 .map((e) =>
//                 DropdownMenuItem(value: e, child: Text(e)))
//                 .toList(),
//             onChanged: (_) {},
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= SEARCH =================
//   Widget _searchBox() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
//       child: TextField(
//         onChanged: (v) => setState(() => search = v),
//         decoration: InputDecoration(
//           hintText: "Search...",
//           prefixIcon: const Icon(Icons.search),
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ================= GRID =================
//   Widget _grid(List<Map<String, dynamic>> list) {
//     return GridView.builder(
//       padding: EdgeInsets.all(4.w),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         crossAxisSpacing: 5.w,
//         mainAxisSpacing: 1.5.h,
//         childAspectRatio: 0.78,
//       ),
//       itemCount: list.length,
//       itemBuilder: (_, i) => _item(list[i], i),
//     );
//   }
//
//   // ================= ITEM =================
//   Widget _item(Map<String, dynamic> item, int index) {
//     final bool marked = item["marked"];
//     final Color ring = marked ? primary : Colors.grey[400]!;
//
//     return GestureDetector(
//       onTap: () => _confirmMark(index, isStudent),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 16.w,
//             height: 16.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               border: Border.all(color: ring, width: 2),
//               boxShadow: marked
//                   ? [
//                 BoxShadow(
//                   color: ring.withOpacity(0.35),
//                   blurRadius: 7,
//                   spreadRadius: 1,
//                 )
//               ]
//                   : [],
//             ),
//             child: Icon(
//               isStudent ? Icons.school : Icons.person,
//               size: 7.w,
//               color: ring,
//             ),
//           ),
//           SizedBox(height: 0.6.h),
//           Text(
//             item["name"],
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 13.sp,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           if (isStudent)
//             Text(
//               "${item["class"]} - ${item["section"]}",
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             )
//           else
//             Text(
//               item["designation"],
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: Colors.grey[600],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
