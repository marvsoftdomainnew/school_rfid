import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height,
    this.radius,
    this.backgroundColor,
    this.textStyle,
  });

  static const Color _primary = Color(0xFF00b894);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading, // ✅ tap disabled WITHOUT disabling button
      child: SizedBox(
        width: double.infinity,
        height: height ?? 6.h,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.all(backgroundColor ?? _primary),
            foregroundColor:
            WidgetStateProperty.all(Colors.white),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 16),
              ),
            ),
          ),
          onPressed: () {
            // ✅ keyboard close
            FocusScope.of(context).unfocus();
            onPressed();
          },
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Text(
            text,
            style: textStyle ??
                TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
        ),
      ),
    );
  }
}
