import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void show(
      String message, {
        ToastGravity gravity = ToastGravity.BOTTOM,
        Color backgroundColor = const Color(0xFF2d3436),
        Color textColor = Colors.white,
      }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 14,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static void success(String message) {
    show(message, backgroundColor: const Color(0xFF00b894));
  }

  static void error(String message) {
    show(message, backgroundColor: const Color(0xFFE74C3C));
  }

  static void warning(String message) {
    show(message, backgroundColor: const Color(0xFFF39C12));
  }
}
