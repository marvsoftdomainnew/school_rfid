import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:schoolmsrfid/data/models/requests/add_students_request.dart';
import '../../../core/services/network_exceptions.dart';
import '../../../core/utils/toast_util.dart';
import '../../../data/repositories/add_student_repository.dart';
import '../../students/controller/student_attendance_list_controller.dart';

class AddStudentController extends GetxController {
  final AddStudentRepository _repository = AddStudentRepository();

  final isLoading = false.obs;

  // Field errors
  final nameError = RxnString();
  final fatherError = RxnString();
  final motherError = RxnString();
  final classError = RxnString();
  final sectionError = RxnString();
  final mobileError = RxnString();
  final rfidError = RxnString();

  bool _validate({
    required String name,
    required String father,
    required String mother,
    required String studentClass,
    required String section,
    required String mobile,
    required String rfid,
  }) {
    nameError.value = null;
    fatherError.value = null;
    motherError.value = null;
    classError.value = null;
    sectionError.value = null;
    mobileError.value = null;
    rfidError.value = null;

    bool valid = true;

    if (name.isEmpty) {
      nameError.value = "Student name is required";
      valid = false;
    }
    if (father.isEmpty) {
      fatherError.value = "Father name is required";
      valid = false;
    }
    if (mother.isEmpty) {
      motherError.value = "Mother name is required";
      valid = false;
    }
    if (studentClass.isEmpty) {
      classError.value = "Class is required";
      valid = false;
    }
    if (section.isEmpty) {
      sectionError.value = "Section is required";
      valid = false;
    }
    if (mobile.isEmpty || mobile.length != 10) {
      mobileError.value = "Enter valid 10 digit number";
      valid = false;
    }
    if (rfid.isEmpty) {
      rfidError.value = "RFID is required";
      valid = false;
    }

    return valid;
  }

  Future<void> saveStudent({
    required String name,
    required String father,
    required String mother,
    required String studentClass,
    required String section,
    required String mobile,
    required String rfid,
  }) async {
    if (!_validate(
      name: name,
      father: father,
      mother: mother,
      studentClass: studentClass,
      section: section,
      mobile: mobile,
      rfid: rfid,
    )) return;

    isLoading.value = true;

    try {
      final response = await _repository.addStudent(
        AddStudentsRequest(
          name: name,
          fatherName: father,
          motherName: mother,
          studentClass: studentClass,
          section: section,
          mobileNumber: mobile,
          rfidNumber: rfid,
        ),
      );

      if (response.success == true) {
        ToastUtil.success(response.message ?? "Student added");
        // 🔄 Refresh list
        Get.find<StudentAttendanceListController>().fetchStudents();

        Get.back();
      } else {
        ToastUtil.error(response.message ?? "Failed to add student");
      }
    } on DioException catch (e) {
      ToastUtil.error(NetworkExceptions.getErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
}
