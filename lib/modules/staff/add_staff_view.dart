import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_header.dart';
import 'controller/add_staff_controller.dart';

class AddStaffView extends StatefulWidget {
  const AddStaffView({super.key});

  @override
  State<AddStaffView> createState() => _AddStaffViewState();
}

class _AddStaffViewState extends State<AddStaffView> {
  final Color primary = const Color(0xFF00b894);

  final AddStaffController controller = Get.put(AddStaffController());

  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final motherCtrl = TextEditingController();
  final designationCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final rfidCtrl = TextEditingController();

  /// 🔥 RFID specific focus
  final FocusNode rfidFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    /// ✅ Auto focus RFID field (for scanner input)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        rfidFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    rfidFocus.dispose();
    super.dispose();
  }

  Widget _inputField(
      String label,
      IconData icon,
      TextEditingController ctrl,
      RxnString error, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        FocusNode? focusNode, // 👈 added (no UI impact)
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: ctrl,
            focusNode: focusNode, // 👈 only used for RFID
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: primary),
              labelStyle:
              TextStyle(fontSize: 15.sp, color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: primary, width: 1.6),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          Obx(() {
            if (error.value == null) return const SizedBox();
            return Padding(
              padding: EdgeInsets.only(top: 0.6.h, left: 2.w),
              child: Text(
                error.value!,
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          4.w,
          1.h,
          4.w,
          MediaQuery.of(context).padding.bottom + 2.h,
        ),
        child: Obx(
              () => PrimaryButton(
            text: "SAVE STAFF",
            isLoading: controller.isLoading.value,
            onPressed: () {
              controller.saveStaff(
                name: nameCtrl.text.trim(),
                father: fatherCtrl.text.trim(),
                mother: motherCtrl.text.trim(),
                designation: designationCtrl.text.trim(),
                mobile: mobileCtrl.text.trim(),
                rfid: rfidCtrl.text.trim(),
              );
            },
          ),
        ),
      ),

      body: Column(
        children: [
          const CustomHeader(
            title: "Add Staff",
            subtitle: "Enter staff details",
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 10.h),
              child: Column(
                children: [
                  _inputField(
                      "Staff Name",
                      Icons.person,
                      nameCtrl,
                      controller.nameError),
                  _inputField(
                      "Post/Designation",
                      Icons.work_outline,
                      designationCtrl,
                      controller.designationError),
                  _inputField(
                      "Father Name",
                      Icons.person_outline,
                      fatherCtrl,
                      controller.fatherError),
                  _inputField(
                      "Mother Name",
                      Icons.person_outline,
                      motherCtrl,
                      controller.motherError),
                  _inputField(
                    "Mobile Number",
                    Icons.phone,
                    mobileCtrl,
                    controller.mobileError,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),

                  /// 🔥 RFID FIELD (scanner will fill this only)
                  _inputField(
                    "RFID Number",
                    Icons.nfc,
                    rfidCtrl,
                    controller.rfidError,
                    focusNode: rfidFocus,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
