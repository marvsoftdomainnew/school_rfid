import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/services/sharedpreferences_service.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/repositories/logout_repository.dart';
import '../../../routes/app_routes.dart';

class LogoutController extends GetxController {
  final LogoutRepository _repository = LogoutRepository();

  final isLoading = false.obs;

  Future<void> logout() async {
    isLoading.value = true;

    try {
      final response = await _repository.logout();

      if (response.success == true) {
        final prefs = await SharedPreferencesService.getInstance();
        await prefs.clear();

        SnackbarUtil.showSuccess("Logout", response.message ?? "Successfully logged out",);
        Get.offAllNamed(AppRoutes.login);
      } else {
        SnackbarUtil.showError(
          "Error",
          response.message ?? "Logout failed",
        );
      }
    } on DioException catch (e) {
      final msg = NetworkExceptions.getErrorMessage(e);
      SnackbarUtil.showError("Error", msg);
    } catch (e) {
      SnackbarUtil.showError("Error", "Unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }
}
