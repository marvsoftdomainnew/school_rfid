import 'package:get/get.dart';
import 'package:schoolmsrfid/data/models/requests/add_staff_request.dart';
import 'package:schoolmsrfid/data/repositories/add_staff_repository.dart';


class AddStaffController extends GetxController {
  final AddStaffRepository _repository = AddStaffRepository();

  final isLoading = false.obs;

  final nameError = RxnString();
  final fatherError = RxnString();
  final motherError = RxnString();
  // final designationError = RxnString();
  final mobileError = RxnString();
  final rfidError = RxnString();

  bool _validate({
    required String name,
    required String father,
    required String mother,
    // required String designation,
    required String mobile,
    required String rfid,
  }) {
    nameError.value = name.isEmpty ? "Name is required" : null;
    fatherError.value = father.isEmpty ? "Father name is required" : null;
    motherError.value = mother.isEmpty ? "Mother name is required" : null;
    // designationError.value = designation.isEmpty ? "Designation is required" : null;

    if (mobile.isEmpty) {
      mobileError.value = "Mobile number is required";
    } else if (mobile.length != 10) {
      mobileError.value = "Mobile number must be 10 digits";
    } else {
      mobileError.value = null;
    }

    rfidError.value = rfid.isEmpty ? "RFID number is required" : null;

    return [
      nameError,
      fatherError,
      motherError,
      // designationError,
      mobileError,
      rfidError
    ].every((e) => e.value == null);
  }

  Future<void> saveStaff({
    required String name,
    required String father,
    required String mother,
    // required String designation,
    required String mobile,
    required String rfid,
  }) async {
    if (!_validate(
      name: name,
      father: father,
      mother: mother,
      // designation: designation,
      mobile: mobile,
      rfid: rfid,
    )) return;

    isLoading.value = true;

    try {
      final response = await _repository.addStaff(
        AddStaffRequest(
          name: name,
          fatherName: father,
          motherName: mother,
          // designation: designation,
          mobileNumber: mobile,
          rfidNumber: rfid,
        ),
      );

      if (response.success == true) {
        Get.back(result: true); // 🔁 refresh list on previous screen
      }
    } catch (_) {
      // handled globally (Dio interceptor / snackbar util)
    } finally {
      isLoading.value = false;
    }
  }
}
