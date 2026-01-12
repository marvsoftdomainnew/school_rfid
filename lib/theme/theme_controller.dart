import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  final _isDark = false.obs;

  bool get isDarkMode => _isDark.value;

  ThemeData get theme =>
      _isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme() {
    _isDark.value = !_isDark.value;
    Get.changeTheme(theme); // 🔥 INSTANT APP UPDATE
  }
}
