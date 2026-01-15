// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class AddStudentView extends StatefulWidget {
//   const AddStudentView({super.key});
//
//   @override
//   State<AddStudentView> createState() => _AddStudentViewState();
// }
//
// class _AddStudentViewState extends State<AddStudentView> {
//   final Color primary = const Color(0xFF00b894);
//
//   Widget _inputField(
//       String label,
//       IconData icon, {
//         TextInputType keyboardType = TextInputType.text,
//       }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 2.h),
//       child: TextField(
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: primary),
//           labelStyle: TextStyle(
//             fontSize: 15.sp,
//             color: Colors.grey[500],
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
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Student saved (static)"),
//                 ),
//               );
//             },
//             child: Text(
//               "SAVE STUDENT",
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
//           Container(
//             padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     padding: EdgeInsets.all(2.5.w),
//                     decoration: BoxDecoration(
//                       color: primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: primary,
//                       size: 5.w,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 5.w),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Add Student",
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF2d3436),
//                       ),
//                     ),
//                     Text(
//                       "Enter student details",
//                       style: TextStyle(
//                         fontSize: 13.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // ===== FORM =====
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 10.h),
//               child: Column(
//                 children: [
//                   _inputField("Student Name", Icons.person),
//                   _inputField("Father Name", Icons.person_outline),
//                   _inputField("Mother Name", Icons.person_outline),
//                   _inputField("Class", Icons.class_),
//                   _inputField("Section", Icons.layers),
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
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../core/utils/text_input_formatters.dart';
import '../../widgets/primary_button.dart';
import 'controller/add_student_controller.dart';
import 'package:flutter/services.dart';

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final Color primary = const Color(0xFF00b894);

  final AddStudentController controller = Get.put(AddStudentController());

  final nameCtrl = TextEditingController();
  final fatherCtrl = TextEditingController();
  final motherCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final sectionCtrl = TextEditingController();
  final rollCtrl = TextEditingController();
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
        child: PrimaryButton(
          text: "SAVE STUDENT",
          isLoading: controller.isLoading.value,
          onPressed: () {
            controller.saveStudent(
              name: nameCtrl.text.trim(),
              father: fatherCtrl.text.trim(),
              mother: motherCtrl.text.trim(),
              studentClass: classCtrl.text.trim(),
              section: sectionCtrl.text.trim(),
              rollNumber: rollCtrl.text.trim(),
              mobile: mobileCtrl.text.trim(),
              rfid: rfidCtrl.text.trim(),
            );
          },
        ),
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.arrow_back, color: primary, size: 5.w),
                  ),
                ),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add Student",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2d3436),
                        )),
                    Text("Enter student details",
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 10.h),
              child: Column(
                children: [
                  _inputField("Student Name", Icons.person, nameCtrl, controller.nameError),
                  _inputField("Father Name", Icons.person_outline, fatherCtrl, controller.fatherError),
                  _inputField("Mother Name", Icons.person_outline, motherCtrl, controller.motherError),
                  _inputField("Class", Icons.class_, classCtrl, controller.classError,
                    inputFormatters: [
                    AlphaNumericUpperCaseFormatter(),
                  ],),
                  _inputField("Section", Icons.layers, sectionCtrl, controller.sectionError,
                    inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],),
                  _inputField("Roll Number", Icons.confirmation_number, rollCtrl, controller.sectionError),
                  _inputField("Mobile Number", Icons.phone, mobileCtrl, controller.mobileError, keyboardType: TextInputType.phone,
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


