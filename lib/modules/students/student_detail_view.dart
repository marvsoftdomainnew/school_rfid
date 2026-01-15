import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/custom_header.dart';

class StudentDetailView extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const StudentDetailView({
    super.key,
    required this.studentData,
  });

  static const Color primary = Color(0xFF00b894);

  Widget _infoTile(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2d3436),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(
            title: "Student Details",
            subtitle: "Complete profile information",
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  // ===== PROFILE =====
                  Column(
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primary, width: 2),
                        ),
                        child:
                        Icon(Icons.school, size: 9.w, color: primary),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        studentData['name'] ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${studentData['class'] ?? ''} - ${studentData['section'] ?? ''}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // ===== DETAILS (API DATA) =====
                  _infoTile(
                    "Father Name",
                    studentData['father_name'] ?? '',
                  ),
                  _infoTile(
                    "Mother Name",
                    studentData['mother_name'] ?? '',
                  ),
                  _infoTile(
                    "Mobile Number",
                    studentData['mobile'] ?? '',
                  ),
                  _infoTile(
                    "RFID Number",
                    studentData['rfid'] ?? '',
                  ),
                  _infoTile(
                    "Attendance Status",
                    studentData['attendance_status'] ?? 'N/A',
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
