class AddStudentsRequest {
  final String name;
  final String fatherName;
  final String motherName;
  final String studentClass;
  final String section;
  final String rollNumber;
  final String mobileNumber;
  final String rfidNumber;

  AddStudentsRequest({
    required this.name,
    required this.fatherName,
    required this.motherName,
    required this.studentClass,
    required this.section,
    required this.rollNumber,
    required this.mobileNumber,
    required this.rfidNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "father_name": fatherName,
      "mother_name": motherName,
      "class": studentClass,
      "section": section,
      "roll_number": rollNumber,
      "mobile_number": mobileNumber,
      "rfid_number": rfidNumber,
    };
  }
}
