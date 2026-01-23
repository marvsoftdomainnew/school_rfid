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

  //  REAL RFID HANDLING (NO AUTO, NO TIMER)

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

          controller.markAttendance(scannedRfid);

          // RESET AFTER SHORT DELAY
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;

            setState(() {
              cardDetected = false;
              rfidController.clear();
            });

            _buffer = "";

            // focus back for next scan
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

                    final showDoneAnimation =
                        cardDetected || controller.isProcessing.value;

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
                          showDoneAnimation
                              ? 'assets/lottie/success.json'
                              : 'assets/lottie/rfid_scan.json',
                          repeat: showDoneAnimation ? false : true,
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

