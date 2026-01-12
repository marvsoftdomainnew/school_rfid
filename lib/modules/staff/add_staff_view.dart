// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../widgets/custom_header.dart';
//
// class AddStaffView extends StatefulWidget {
//   const AddStaffView({super.key});
//
//   @override
//   State<AddStaffView> createState() => _AddStaffViewState();
// }
//
// class _AddStaffViewState extends State<AddStaffView> {
//   final Color primary = const Color(0xFF00b894);
//
//   Widget _inputField(String label, IconData icon,
//       {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 2.h),
//       child: TextField(
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: primary),
//           labelStyle: TextStyle(
//             color: Colors.grey[500],
//             fontSize: 15.sp,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(color: Colors.grey[300]!),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide(color: primary, width: 1.6),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // ===== FIXED SAVE BUTTON =====
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 15,
//               offset: Offset(0, -4),
//             ),
//           ],
//         ),
//         child: SizedBox(
//           height: 6.5.h,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 0,
//             ),
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Staff saved (static)"),
//                 ),
//               );
//             },
//             child: Text(
//               "SAVE STAFF",
//               style: TextStyle(
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//
//       body: Column(
//         children: [
//           // ===== CUSTOM HEADER =====
//           CustomHeader(title: "Add Staff", subtitle: "Enter staff details",),
//           // ===== FORM =====
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 10.h),
//               child: Column(
//                 children: [
//                   _inputField("Staff Name", Icons.person),
//                   _inputField("Father Name", Icons.person_outline),
//                   _inputField("Mother Name", Icons.person_outline),
//                   _inputField("Designation", Icons.work_outline),
//                   _inputField(
//                     "Mobile Number",
//                     Icons.phone,
//                     keyboardType: TextInputType.phone,
//                   ),
//                   _inputField("RFID Number", Icons.nfc),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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

  Widget _inputField(
      String label,
      IconData icon,
      TextEditingController ctrl,
      RxnString error, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: primary),
              labelStyle: TextStyle(fontSize: 15.sp, color: Colors.grey[500]),
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
        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, MediaQuery.of(context).padding.bottom + 2.h,),
        child: Obx(() => PrimaryButton(
          text: "SAVE STAFF",
          isLoading: controller.isLoading.value,
          onPressed: () {
            controller.saveStaff(
              name: nameCtrl.text.trim(),
              father: fatherCtrl.text.trim(),
              mother: motherCtrl.text.trim(),
              // designation: designationCtrl.text.trim(),
              mobile: mobileCtrl.text.trim(),
              rfid: rfidCtrl.text.trim(),
            );
          },
        )),
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
                  _inputField("Staff Name", Icons.person, nameCtrl, controller.nameError),
                  _inputField("Father Name", Icons.person_outline, fatherCtrl, controller.fatherError),
                  _inputField("Mother Name", Icons.person_outline, motherCtrl, controller.motherError),
                  // _inputField("Designation", Icons.work_outline, designationCtrl, controller.designationError),
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
                  _inputField("RFID Number", Icons.nfc, rfidCtrl, controller.rfidError),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
