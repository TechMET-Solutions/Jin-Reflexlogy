class TreatmentResponse {
  final int success;
  final TreatmentData? data; // 🔥 nullable
  final String? message; // 🔥 for success = 0 case

  TreatmentResponse({required this.success, this.data, this.message});

  factory TreatmentResponse.fromJson(Map<String, dynamic> json) {
    return TreatmentResponse(
      success: json['success'] ?? 0,

      // success = 1 → data object
      data:
          json['data'] is Map<String, dynamic>
              ? TreatmentData.fromJson(json['data'])
              : null,

      // success = 0 → message string
      message: json['data'] is String ? json['data'] : null,
    );
  }
}

class TreatmentData {
  final String day;
  final String boyleMagnet;
  final String chakraMagnet;
  final String highPowerMagnet;
  final String lowPowerMagnet;
  final String spinalWhite;
  final String spinalYellow;
  final String sufferingProblems;
  final String result;

  TreatmentData({
    required this.day,
    required this.boyleMagnet,
    required this.chakraMagnet,
    required this.highPowerMagnet,
    required this.lowPowerMagnet,
    required this.spinalWhite,
    required this.spinalYellow,
    required this.sufferingProblems,
    required this.result,
  });

  factory TreatmentData.fromJson(Map<String, dynamic> json) {
    return TreatmentData(
      day: json['day']?.toString() ?? "",
      boyleMagnet: json['boyle magnet'] ?? "-",
      chakraMagnet: json['chakra magnet'] ?? "-",
      highPowerMagnet: json['4g high power magnet'] ?? "-",
      lowPowerMagnet: json['4g low power magnet'] ?? "-",
      spinalWhite: json['spinal_white'] ?? "-",
      spinalYellow: json['spinal_yellow'] ?? "-",
      sufferingProblems: json['suffering_problems'] ?? "-",
      result: json['result'] ?? "",
    );
  }
}
