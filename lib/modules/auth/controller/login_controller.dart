import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/core/utils/snackbar_util.dart';
import 'package:schoolmsrfid/core/utils/toast_util.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/services/sharedpreferences_service.dart';
import '../../../data/models/requests/login_request.dart';
import '../../../data/repositories/login_repository.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final LoginRepository _repository = LoginRepository();

  final isLoading = false.obs;

  // 👇 field-wise errors
  final emailError = RxnString();
  final passwordError = RxnString();

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(email);
  }

  // bool _isValidPassword(String password) {
  //   return RegExp(
  //     r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$',
  //   ).hasMatch(password);
  // }

  bool validateFields(String email, String password) {
    bool valid = true;

    emailError.value = null;
    passwordError.value = null;

    if (email.isEmpty) {
      emailError.value = "Email is required";
      valid = false;
    }
    // else if (!_isValidEmail(email)) {
    //   emailError.value = "Enter valid email";
    //   valid = false;
    // }

    if (password.isEmpty) {
      passwordError.value = "Password is required";
      valid = false;
    }
    // else if (!_isValidPassword(password)) {
    //   passwordError.value =
    //   "Password must contain upper, lower & number";
    //   valid = false;
    // }

    return valid;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (!validateFields(email, password)) return;

    isLoading.value = true;

    try {
      final response = await _repository.login(
        LoginRequest(
          email: email,
          password: password,
          deviceName: "j8",
        ),
      );

      if (response.success == true) {
        final prefs = await SharedPreferencesService.getInstance();
        if (response.token != null) {
          await prefs.setString(AppKeys.token, response.token!);
        }
        if (response.user?.mobileNumber != null &&
            response.user!.mobileNumber!.isNotEmpty) {
          await prefs.setString(AppKeys.mobileNumber, response.user!.mobileNumber!,);
        }
        await prefs.setBool(AppKeys.isLogin, true);
        ToastUtil.success("Successfully logged in");
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        ToastUtil.error("Invalid email or password");
      }
    } on DioException catch (e) {
      final message = NetworkExceptions.getErrorMessage(e);
      SnackbarUtil.showError("Error", message);
    } catch (e) {
      ToastUtil.error("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}

