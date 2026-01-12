import 'package:get/get.dart';
import 'package:schoolmsrfid/modules/auth/login_binding.dart';
import 'package:schoolmsrfid/modules/dashboard/dashboard_shell.dart';
import 'package:schoolmsrfid/modules/dashboard/dashboard_view.dart';
import 'package:schoolmsrfid/splash_view.dart';
import '../../modules/auth/login_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const _defaultTransition = Transition.cupertino;
  static const _transitionDuration = Duration(milliseconds: 450);

  static GetPage _buildPage({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
  }) {
    return GetPage(
      name: name,
      page: page,
      binding: binding,
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    );
  }

  static List<GetPage> getRoutes() {
    return [
      _buildPage(name: AppRoutes.splash, page: () => SplashView()),
      _buildPage(name: AppRoutes.login, page: () => LoginView(),binding: LoginBinding()),
      _buildPage(name: AppRoutes.dashboard, page: () => DashboardShell(),binding: DashboardBinding(),),

    ];
  }
}
