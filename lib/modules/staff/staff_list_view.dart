import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/modules/staff/controller/staff_list_controller.dart';
import 'package:schoolmsrfid/modules/staff/staff_detail_view.dart';
import 'package:sizer/sizer.dart';
import '../../core/utils/toast_util.dart';
import '../../theme/app_colors.dart';
import 'add_staff_view.dart';

class StaffListView extends StatefulWidget {
  const StaffListView({super.key});

  @override
  State<StaffListView> createState() => _StaffListViewState();
}

class _StaffListViewState extends State<StaffListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final StaffListController controller = Get.find<StaffListController>();

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  String selectedPost = "All";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    controller.fetchStaffs();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }
  Future<void> _onRefresh() async {
    await controller.fetchStaffs();
    ToastUtil.success("List updated");
  }


  // ================= FILTER =================
  void _applyFilters() {
    controller.applyFilters(
      searchQuery: searchController.text,
      selectedPost: selectedPost,
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= FAB (UNCHANGED) =================
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
            Get.to(() => const AddStaffView(),
                transition: Transition.cupertino);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            "Add Staff",
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
          _buildPostFilter(),
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
                hintText: "Search staff...",
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
                  "Staffs",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2d3436),
                  ),
                ),
                Obx(() => Text(
                  "${controller.filteredStaffs.length} Total",
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
          //         controller.applyFilters(
          //           searchQuery: "",
          //           selectedPost: selectedPost,
          //         );
          //       }
          //       else {
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

  // ================= POST DROPDOWN =================
  Widget _buildPostFilter() {
    return Obx(() {
      if (controller.staffs.isEmpty) return const SizedBox();

      final posts = controller.getPostList();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: DropdownButtonFormField<String>(
          value: selectedPost,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: posts
              .map(
                (e) => DropdownMenuItem<String>(
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
          onChanged: (v) {
            setState(() => selectedPost = v!);
            _applyFilters();
          },
          decoration: InputDecoration(
            labelText: "Post / Designation",
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
        ),
      );
    });
  }


  // ================= GRID + ANIMATION =================
  Widget _buildGrid() {
    return Obx(() {
      if (controller.isLoading.value && controller.staffs.isEmpty) {
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
              itemCount: controller.filteredStaffs.length,
              itemBuilder: (context, index) {
                final staff = controller.filteredStaffs[index];

                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 15)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: _buildStaffItem(staff, index),
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

  // ================= STAFF ITEM =================
  Widget _buildStaffItem(Map<String, dynamic> staff, int index) {
    const ringColor = Color(0xFF00b894);
    const iconColor = Color(0xFF00b894);
    const textColor = Color(0xFF2d3436);

    return GestureDetector(
      onTap: () {
        Get.to(
              () => StaffDetailView(staffData: staff),
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
              Icons.person,
              size: 7.w,
              color: iconColor,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            staff['post'] ?? '',
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
              staff['name'] ?? '',
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
// import 'package:schoolmsrfid/modules/staff/controller/staff_list_controller.dart';
// import 'package:schoolmsrfid/modules/staff/staff_detail_view.dart';
// import 'package:sizer/sizer.dart';
// import '../../core/utils/toast_util.dart';
// import 'add_staff_view.dart';
//
// class StaffListView extends StatefulWidget {
//   const StaffListView({super.key});
//
//   @override
//   State<StaffListView> createState() => _StaffListViewState();
// }
//
// class _StaffListViewState extends State<StaffListView>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   bool isSearching = false;
//   final TextEditingController searchController = TextEditingController();
//
//   final StaffAttendanceListController controller = Get.find<StaffAttendanceListController>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..forward();
//
//     controller.fetchStaffs();
//   }
//
//   Future<void> _onRefresh() async {
//     await controller.fetchStaffs();
//     ToastUtil.success("List updated");
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onStaffTap(int index) {
//     Get.to(
//           () => StaffDetailView(
//         staffData: controller.filteredStaffs[index],
//       ),
//       transition: Transition.cupertino,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
//
//   // ================= HEADER =================
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
//               onChanged: controller.filter,
//               decoration: InputDecoration(
//                 hintText: "Search staff...",
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
//                 : Obx(() {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Staffs",
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF2d3436),
//                     ),
//                   ),
//                   Text(
//                     "${controller.filteredStaffs.where((s) => s['isPresent']).length} "
//                         "Present / ${controller.filteredStaffs.length} Total",
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (isSearching) {
//                   isSearching = false;
//                   searchController.clear();
//                   controller.filteredStaffs.assignAll(controller.staffs);
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
//   // ================= GRID =================
//   Widget _buildGrid() {
//     return Obx(() {
//       if (controller.isLoading.value && controller.staffs.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       return RefreshIndicator(
//         color: const Color(0xFF00b894),
//         onRefresh: _onRefresh,
//         child: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return GridView.builder(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: EdgeInsets.all(4.w),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 5.w,
//                 mainAxisSpacing: 1.h,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: controller.filteredStaffs.length,
//               itemBuilder: (context, index) {
//                 final staff = controller.filteredStaffs[index];
//                 return TweenAnimationBuilder<double>(
//                   duration: Duration(milliseconds: 300 + (index * 15)),
//                   tween: Tween(begin: 0.0, end: 1.0),
//                   builder: (context, animValue, child) {
//                     return Transform.scale(
//                       scale: animValue,
//                       child: Opacity(
//                         opacity: animValue,
//                         child: _buildStaffItem(staff, index),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       );
//     });
//   }
//
//   // ================= ITEM =================
//   Widget _buildStaffItem(Map<String, dynamic> staff, int index) {
//     final isPresent = staff['isPresent'];
//
//     final ringColor =
//     isPresent ? const Color(0xFF00b894) : Colors.grey[400]!;
//     final iconColor =
//     isPresent ? const Color(0xFF00b894) : Colors.grey[600]!;
//     final textColor =
//     isPresent ? const Color(0xFF2d3436) : Colors.grey[700]!;
//
//     return GestureDetector(
//       onTap: () => _onStaffTap(index),
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
//               Icons.person,
//               size: 7.w,
//               color: iconColor,
//             ),
//           ),
//           SizedBox(height: 0.5.h),
//           Text(
//             staff['designation'],
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w500,
//               color: textColor.withOpacity(0.85),
//             ),
//           ),
//           SizedBox(height: 0.4.h),
//           Text(
//             staff['name'],
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 13.sp,
//               fontWeight: FontWeight.bold,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
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
//             Get.to(() => const AddStaffView(),
//                 transition: Transition.cupertino);
//           },
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           icon: const Icon(Icons.add, color: Colors.white),
//           label: Text(
//             "Add Staff",
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           _buildCustomHeader(),
//           Expanded(child: _buildGrid()),
//         ],
//       ),
//     );
//   }
// }
