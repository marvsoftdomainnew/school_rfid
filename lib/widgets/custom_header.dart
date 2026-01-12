import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
  });

  static const Color primary = Color(0xFF00b894);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
      color: Colors.white,
      child: Row(
        children: [
          // ===== BACK BUTTON =====
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.8.w),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: primary,
                size: 5.w,
              ),
            ),
          ),

          SizedBox(width: 5.w),

          // ===== TITLE AREA =====
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2d3436),
                ),
              ),

              if (subtitle != null) ...[
                SizedBox(height: 0.3.h),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
