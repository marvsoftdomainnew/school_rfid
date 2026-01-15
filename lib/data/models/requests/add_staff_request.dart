class AddStaffRequest {
  final String name;
  final String fatherName;
  final String motherName;
  final String mobileNumber;
  final String post;
  final String rfidNumber;

  AddStaffRequest({
    required this.name,
    required this.fatherName,
    required this.motherName,
    required this.mobileNumber,
    required this.post,
    required this.rfidNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "father_name": fatherName,
      "mother_name": motherName,
      "mobile_number": mobileNumber,
      "post": mobileNumber,
      "rfid_number": rfidNumber,
    };
  }
}
