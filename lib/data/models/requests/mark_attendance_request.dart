class MarkAttendanceRequest {
  final String rfidNumber;

  MarkAttendanceRequest({
    required this.rfidNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "rfid_number": rfidNumber,
    };
  }
}
