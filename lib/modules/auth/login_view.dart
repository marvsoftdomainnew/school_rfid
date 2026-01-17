import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/modules/auth/forgot_password_view.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/login_text_field.dart';
import '../../widgets/primary_button.dart';
import 'controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final LoginController loginController = Get.find<LoginController>();


  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00b894),
              Color(0xFF00cec9),
              Color(0xFF55efc4),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with scale animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            size: 16.w,
                            color: const Color(0xFF00b894),
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Title
                      Text(
                        "School Management",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      Text(
                        "RFID Attendance System",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.2,
                        ),
                      ),

                      SizedBox(height: 5.h),

                      // Login Card
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back!",
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2d3436),
                              ),
                            ),

                            // SizedBox(height: 0.5.h),

                            Text(
                              "Sign in to continue",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),

                            SizedBox(height: 3.h),

                            // Username Field
                            Obx(() {
                              return LoginTextField(
                                controller: _usernameController,
                                label: "Email",
                                prefixIcon: Icons.person_outline,
                                errorText: loginController.emailError.value,
                              );
                            }),

                            SizedBox(height: 2.h),

                            // Password Field
                            Obx(() {
                              return LoginTextField(
                                controller: _passwordController,
                                label: "Password",
                                prefixIcon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                errorText: loginController.passwordError.value,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF00b894),
                                    size: 5.w,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              );
                            }),

                            SizedBox(height: 1.h),

                            // Forgot Password
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: TextButton(
                            //     onPressed: () {
                            //       Get.to(
                            //             () => const ForgotPasswordView(),
                            //         transition: Transition.cupertino,
                            //       );
                            //     },
                            //     child: Text(
                            //       "Forgot Password?",
                            //       style: TextStyle(
                            //         color: const Color(0xFF00b894),
                            //         fontSize: 14.sp,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            SizedBox(height: 2.h),

                            // Login Button
                        Obx(() {
                          return PrimaryButton(
                            text: "LOGIN",
                            isLoading: loginController.isLoading.value,
                            onPressed: () {
                              loginController.login(
                                email: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            },
                          );
                        }),
                        ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "Secure RFID Authentication",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}