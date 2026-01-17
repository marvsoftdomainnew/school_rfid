import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

InputDecoration filterDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      fontSize: 16.sp,
      color: Colors.grey[600],
    ),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 3.w,
      vertical: 1.6.h,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF00b894),
        width: 1.4,
      ),
    ),
  );
}
