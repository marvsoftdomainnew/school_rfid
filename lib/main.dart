import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/theme/theme_controller.dart';
import 'package:sizer/sizer.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'School Management System',
          initialRoute: AppRoutes.splash,
          getPages: AppPages.getRoutes(),
          theme: themeController.theme,
        ));
      },
    );
  }
}

