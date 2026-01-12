import 'package:get/get.dart';
import 'package:schoolmsrfid/routes/app_pages.dart';
import 'package:schoolmsrfid/routes/app_routes.dart';
import '../services/sharedpreferences_service.dart';
import '../constants/app_keys.dart';
import '../../modules/auth/login_view.dart';

class SessionManager {
  static bool _isLoggingOut = false;

  static Future<void> forceLogout() async {
    if (_isLoggingOut) return; // 🛑 prevent multiple triggers
    _isLoggingOut = true;

    final prefs = await SharedPreferencesService.getInstance();
    await prefs.clear();

    // Clear GetX memory
    Get.deleteAll(force: true);

    // Redirect to login
    Get.offAllNamed(AppRoutes.login);

    _isLoggingOut = false;
  }
}
