import 'package:flutter/material.dart';
import 'package:schoolmsrfid/widgets/custom_header.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final Color primary = const Color(0xFF00b894);

  final TextEditingController oldPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController =
  TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: TextField(
        controller: controller,
        obscureText: !obscure,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primary, width: 1.6),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      // ================= BODY =================
      body: Column(children: [
        const CustomHeader(title: "Change Password"),
        Expanded(child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5.w, 4.h, 5.w, 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update your password",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2d3436),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                "Choose a strong password to keep your account secure.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
              ),

              SizedBox(height: 3.h),

              _passwordField(
                label: "Current Password",
                controller: oldPasswordController,
                obscure: showOld,
                toggle: () {
                  setState(() => showOld = !showOld);
                },
              ),

              _passwordField(
                label: "New Password",
                controller: newPasswordController,
                obscure: showNew,
                toggle: () {
                  setState(() => showNew = !showNew);
                },
              ),

              _passwordField(
                label: "Confirm New Password",
                controller: confirmPasswordController,
                obscure: showConfirm,
                toggle: () {
                  setState(() => showConfirm = !showConfirm);
                },
              ),

              SizedBox(height: 4.h),

              SizedBox(
                width: double.infinity,
                height: 6.5.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password updated (static)"),
                      ),
                    );
                  },
                  child: Text(
                    "UPDATE PASSWORD",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ))
      ],),
    );
  }
}
