class PatientData {
  final String id;
  final String name;
  final String gender;
  final String mobile;

  PatientData({
    required this.id,
    required this.name,
    required this.gender,
    required this.mobile,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'].toString(), // 👍 FIX
      name: json['name'] ?? "",
      gender: json['gender'] ?? "",
      mobile: json['mobile'].toString(),
    );
  }
}
