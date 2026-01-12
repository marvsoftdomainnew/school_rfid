import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtil {
  static const Color _successColor = Color(0xFF00b894);
  static const Color _errorColor = Color(0xFFE74C3C);
  static const Color _warningColor = Color(0xFFF39C12);
  static const Color _infoColor = Color(0xFF3498DB);

  static void showSuccess(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: _successColor,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: _errorColor,
      icon: Icons.error_outline,
    );
  }

  static void showWarning(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: _warningColor,
      icon: Icons.warning_amber_outlined,
    );
  }

  static void showInfo(String title, String message) {
    _show(
      title,
      message,
      backgroundColor: _infoColor,
      icon: Icons.info_outline,
    );
  }

  static void _show(
      String title,
      String message, {
        required Color backgroundColor,
        required IconData icon,
      }) {
    // Prevent snackbar spam
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
