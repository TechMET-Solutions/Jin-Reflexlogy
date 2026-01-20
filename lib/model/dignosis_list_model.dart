class PatientData {
  final String id;
  final String name;
  final String mobile;
  final String registerationDate;
  final String? gender; // 👈 ADD THIS

  PatientData({
    required this.id,
    required this.name,
    required this.mobile,
    required this.registerationDate,
    this.gender,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      registerationDate: json['registeration_date'] ?? '',
      gender: json['gender'], 
    );
  }
}
