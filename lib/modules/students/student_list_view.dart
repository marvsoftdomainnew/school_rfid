import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/modules/students/controller/student_list_controller.dart';
import 'package:schoolmsrfid/modules/students/student_detail_view.dart';
import 'package:schoolmsrfid/theme/app_colors.dart';
import 'package:sizer/sizer.dart';
import '../../core/utils/toast_util.dart';
import 'add_student_view.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  final StudentListController controller = Get.find<StudentListController>();

  String selectedClass = "All";
  String selectedSection = "All";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    controller.fetchStudents();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await controller.fetchStudents();
    ToastUtil.success("List updated");
  }

  // ================= FILTER =================
  void _applyFilters() {
    final query = searchController.text.toLowerCase();

    controller.filteredStudents.assignAll(
      controller.students.where((s) {
        final matchClass =
            selectedClass == "All" || s['class'] == selectedClass;
        final matchSection =
            selectedSection == "All" || s['section'] == selectedSection;
        final matchSearch =
            query.isEmpty || (s['name'] ?? '').toLowerCase().contains(query);

        return matchClass && matchSection && matchSearch;
      }).toList(),
    );
  }

  List<String> _uniqueValues(String key) {
    final values = controller.students
        .map((e) => e[key]?.toString())
        .whereType<String>()
        .toSet()
        .toList();
    values.sort();
    return ["All", ...values];
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= FAB =================
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00b894), Color(0xFF00cec9)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00b894).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.to(() => const AddStudentView(),
                transition: Transition.cupertino);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            "Add Student",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: isSearching
                ? TextField(
              controller: searchController,
              autofocus: true,
              onChanged: (_) {
                setState(() {
                  _applyFilters();
                });
              },
              decoration: InputDecoration(
                hintText: "Search student...",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.grey[500],
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 1.h,
                ),
              ),
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Students",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2d3436),
                  ),
                ),
                Obx(() => Text(
                  "${controller.filteredStudents.length} Total",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                )),
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       if (isSearching) {
          //         isSearching = false;
          //         searchController.clear();
          //         _applyFilters();
          //       } else {
          //         isSearching = true;
          //       }
          //     });
          //   },
          //   child: Container(
          //     padding: EdgeInsets.all(2.5.w),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF00b894).withOpacity(0.1),
          //       shape: BoxShape.circle,
          //     ),
          //     child: Icon(
          //       isSearching ? Icons.close : Icons.search,
          //       color: const Color(0xFF00b894),
          //       size: 5.w,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ================= FILTER ROW =================
  Widget _buildFilters() {
    return Obx(() {
      if (controller.students.isEmpty) return const SizedBox();

      final classes = _uniqueValues('class');
      final sections = _uniqueValues('section');

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Row(
          children: [
            Expanded(
              child: _dropdown(
                label: "Class",
                value: selectedClass,
                items: classes,
                onChanged: (v) {
                  setState(() => selectedClass = v!);
                  _applyFilters();
                },
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _dropdown(
                label: "Section",
                value: selectedSection,
                items: sections,
                onChanged: (v) {
                  setState(() => selectedSection = v!);
                  _applyFilters();
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isDense: true, // height kam karta hai
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: items.map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(
            e,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey[600],
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.6.h, // height control
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF00b894),
            width: 1.4,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 13.sp,
        color: const Color(0xFF2d3436),
        fontWeight: FontWeight.w600,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
    );
  }

  // ================= GRID + ANIMATION =================
  Widget _buildGrid() {
    return Obx(() {
      if (controller.isLoading.value && controller.students.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primary,
          strokeWidth: 2,));
      }

      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              padding: EdgeInsets.all(4.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5.w,
                mainAxisSpacing: 1.h,
                childAspectRatio: 0.75,
              ),
              itemCount: controller.filteredStudents.length,
              itemBuilder: (context, index) {
                final student = controller.filteredStudents[index];

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 15)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: _buildStudentItem(student, index),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      );
    });
  }

  // ================= ITEM (EXACT COPY STYLE) =================
  Widget _buildStudentItem(Map<String, dynamic> student, int index) {
    final ringColor = const Color(0xFF00b894);
    final iconColor = const Color(0xFF00b894);
    final textColor = const Color(0xFF2d3436);

    return GestureDetector(
      onTap: () {
        Get.to(
              () => StudentDetailView(studentData: student),
          transition: Transition.cupertino,
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: ringColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: ringColor.withOpacity(0.35),
                  blurRadius: 7,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.school,
              size: 7.w,
              color: iconColor,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "${student['class']} - ${student['section']}",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.85),
            ),
          ),
          SizedBox(height: 0.4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              student['name'] ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:schoolmsrfid/modules/students/student_detail_view.dart';
// import 'package:sizer/sizer.dart';
//
// import 'add_student_view.dart';
//
// class StudentListView extends StatefulWidget {
//   const StudentListView({super.key});
//
//   @override
//   State<StudentListView> createState() => _StudentListViewState();
// }
//
// class _StudentListViewState extends State<StudentListView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   bool isSearching = false;
//   final TextEditingController searchController = TextEditingController();
//   late List<Map<String, dynamic>> filteredStudentList;
//
//   // ================= STATIC STUDENT DATA (500) =================
//   final List<Map<String, dynamic>> studentList =
//   List.generate(100, (index) {
//     bool isPresent = index % 3 != 0; // demo logic
//
//     return {
//       'id': index + 1,
//       'name': 'Student ${index + 1}',
//       'class': 'Class ${(index % 10) + 1}',
//       'section': ['A', 'B', 'C'][index % 3],
//       'isPresent': isPresent,
//     };
//   });
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//     _animationController.forward();
//     filteredStudentList = List.from(studentList);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   // ================= SEARCH =================
//   void _filterStudents(String query) {
//     final lowerQuery = query.toLowerCase();
//
//     setState(() {
//       filteredStudentList = studentList.where((student) {
//         return student['name'].toLowerCase().contains(lowerQuery) ||
//             student['class'].toLowerCase().contains(lowerQuery) ||
//             student['section'].toLowerCase().contains(lowerQuery);
//       }).toList();
//     });
//   }
//
//   void _onStudentTap(int index) {
//     Get.to(
//           () => StudentDetailView(
//         studentData: filteredStudentList[index],
//       ),
//       transition: Transition.cupertino,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
//
//
//   // ================= BUILD =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // ================= FAB =================
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF00b894), Color(0xFF00cec9)],
//           ),
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF00b894).withOpacity(0.4),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: FloatingActionButton.extended(
//           onPressed: () {
//             Get.to(() => const AddStudentView(),
//                 transition: Transition.cupertino);
//           },
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           icon: const Icon(Icons.add, color: Colors.white),
//           label: Text(
//             "Add Student",
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//
//       body: Column(
//         children: [
//           _buildCustomHeader(),
//           Expanded(child: _buildGrid()),
//         ],
//       ),
//     );
//   }
//
//   // ================= HEADER (EXACT SAME AS STAFF) =================
//   Widget _buildCustomHeader() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             child: isSearching
//                 ? TextField(
//               controller: searchController,
//               autofocus: true,
//               onChanged: _filterStudents,
//               decoration: InputDecoration(
//                 hintText: "Search student...",
//                 border: InputBorder.none,
//                 hintStyle: TextStyle(
//                   fontSize: 17.sp,
//                   color: Colors.grey[400],
//                 ),
//               ),
//               style: TextStyle(
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             )
//                 : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Students",
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF2d3436),
//                   ),
//                 ),
//                 Text(
//                   "${filteredStudentList.where((s) => s['isPresent']).length} Present / ${filteredStudentList.length} Total",
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (isSearching) {
//                   isSearching = false;
//                   searchController.clear();
//                   filteredStudentList = List.from(studentList);
//                 } else {
//                   isSearching = true;
//                 }
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.all(2.5.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF00b894).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 isSearching ? Icons.close : Icons.search,
//                 color: const Color(0xFF00b894),
//                 size: 5.w,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= GRID (SAME CONFIG AS STAFF) =================
//   Widget _buildGrid() {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return GridView.builder(
//           padding: EdgeInsets.all(4.w),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             crossAxisSpacing: 5.w,
//             mainAxisSpacing: 1.h,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: filteredStudentList.length,
//           itemBuilder: (context, index) {
//             final student = filteredStudentList[index];
//             return TweenAnimationBuilder<double>(
//               duration: Duration(milliseconds: 300 + (index * 15)),
//               tween: Tween(begin: 0.0, end: 1.0),
//               builder: (context, animValue, child) {
//                 return Transform.scale(
//                   scale: animValue,
//                   child: Opacity(
//                     opacity: animValue,
//                     child: _buildStudentItem(student, index),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // ================= ITEM (STUDENT VERSION OF STAFF ITEM) =================
//   Widget _buildStudentItem(Map<String, dynamic> student, int index) {
//     final isPresent = student['isPresent'];
//
//     final ringColor =
//     isPresent ? const Color(0xFF00b894) : Colors.grey[400]!;
//     final iconColor =
//     isPresent ? const Color(0xFF00b894) : Colors.grey[600]!;
//     final textColor =
//     isPresent ? const Color(0xFF2d3436) : Colors.grey[700]!;
//
//     return GestureDetector(
//       onTap: () => _onStudentTap(index),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 16.w,
//             height: 16.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               border: Border.all(color: ringColor, width: 2),
//               boxShadow: isPresent
//                   ? [
//                 BoxShadow(
//                   color: ringColor.withOpacity(0.35),
//                   blurRadius: 7,
//                   spreadRadius: 1,
//                 ),
//               ]
//                   : [],
//             ),
//             child: Icon(
//               Icons.school,
//               size: 7.w,
//               color: iconColor,
//             ),
//           ),
//           SizedBox(height: 0.5.h),
//           Text(
//             "${student['class']} - ${student['section']}",
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//               color: textColor.withOpacity(0.85),
//             ),
//           ),
//           SizedBox(height: 0.4.h),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.w),
//             child: Text(
//               student['name'],
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 13.sp,
//                 fontWeight: FontWeight.bold,
//                 color: textColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }







