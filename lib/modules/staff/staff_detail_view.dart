import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/custom_header.dart';

class StaffDetailView extends StatelessWidget {
  final Map<String, dynamic> staffData;

  const StaffDetailView({
    super.key,
    required this.staffData,
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
            title: "Staff Details",
            subtitle: "Staff profile & attendance",
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  // ===== PROFILE =====
                  SizedBox(height: 4.h),
                  Column(
                    children: [
                      Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primary, width: 2),
                        ),
                        child:
                        Icon(Icons.person, size: 9.w, color: primary),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        staffData['name'] ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        staffData['post'] ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // ===== DETAILS (API DATA) =====
                  _infoTile(
                    "Father Name",
                    staffData['father_name'] ?? '',
                  ),
                  _infoTile(
                    "Mother Name",
                    staffData['mother_name'] ?? '',
                  ),
                  _infoTile(
                    "Mobile Number",
                    staffData['mobile'] ?? '',
                  ),
                  _infoTile(
                    "RFID Number",
                    staffData['rfid'] ?? '',
                  ),
                  // _infoTile(
                  //   "Attendance Status",
                  //   staffData['attendance_status'] ?? 'N/A',
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
