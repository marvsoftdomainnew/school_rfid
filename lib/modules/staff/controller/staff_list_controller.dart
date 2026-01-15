import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/snackbar_util.dart';
import '../../../data/models/responses/staff_list_response.dart';
import '../../../data/repositories/staff_list_repository.dart';

class StaffListController extends GetxController {
  final StaffListRepository _repository = StaffListRepository();

  // ================= STATE =================
  final isLoading = false.obs;

  /// Full API list
  final staffs = <Map<String, dynamic>>[].obs;

  /// Filtered list (search + dropdown)
  final filteredStaffs = <Map<String, dynamic>>[].obs;

  // ================= API =================
  Future<void> fetchStaffs() async {
    isLoading.value = true;

    try {
      final StaffListResponse response =
      await _repository.fetchStaffList();

      if (response.success == true) {
        final list = response.records.map((StaffRecord r) {
          return {
            'id': r.id,
            'name': r.staffName ?? '',
            'post': r.post ?? '',
            'mobile': r.mobileNumber ?? '',
            'rfid': r.rfidNumber ?? '',
            'avatar': r.avatarUrl,
          };
        }).toList();

        staffs.assignAll(list);
        filteredStaffs.assignAll(list);
      } else {
        SnackbarUtil.showError(
          "Error",
          response.message ?? "Failed to load staff list",
        );
      }
    } on DioException catch (e) {
      SnackbarUtil.showError(
        "Error",
        NetworkExceptions.getErrorMessage(e),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SEARCH + POST FILTER =================
  void applyFilters({
    required String searchQuery,
    required String selectedPost,
  }) {
    final q = searchQuery.toLowerCase().trim();

    filteredStaffs.assignAll(
      staffs.where((s) {
        final matchPost =
            selectedPost == "All" || s['post'] == selectedPost;

        final matchSearch = q.isEmpty ||
            (s['name'] ?? '').toLowerCase().contains(q) ||
            (s['post'] ?? '').toLowerCase().contains(q);

        return matchPost && matchSearch;
      }).toList(),
    );
  }


  // ================= POST DROPDOWN =================
  List<String> getPostList() {
    final posts = staffs
        .map((e) => e['post']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    posts.sort();
    return ["All", ...posts];
  }
}


