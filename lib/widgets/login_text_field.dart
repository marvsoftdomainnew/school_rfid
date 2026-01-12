import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.errorText,
  });

  static const Color primary = Color(0xFF00b894);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelStyle: const TextStyle(
              color: primary, // ✅ always primary
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: primary,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF0F3F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: primary,
                width: 1,
              ),
            ),
          ),
        ),

        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 0.8.h, left: 1.w),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 13.sp,
              ),
            ),
          ),
      ],
    );
  }
}
