import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/preference/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/preference/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/new_treatment.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/treatment_click.dart';

class DiagnosisHistoryScreen extends StatefulWidget {
  final String patientId;
  final String diagnosisId;
  final String patientName;

  const DiagnosisHistoryScreen({
    super.key,
    required this.patientId,
    required this.diagnosisId,
    required this.patientName,
  });

  @override
  State<DiagnosisHistoryScreen> createState() => _DiagnosisHistoryScreenState();
}

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen> {
  bool isLoading = true;

  List<Map<String, String>> historyList = [];

  @override
  void initState() {
    super.initState();
    fetchTreatmentHistory();
  }

  // ---------------- API CALL ----------------
  Future<void> fetchTreatmentHistory() async {
    debugPrint("========== FETCH TREATMENT HISTORY START ==========");

    setState(() => isLoading = true);

    final String url = "${list_treatment}";

    final formData = FormData.fromMap({
      "diagnosisId": widget.diagnosisId,
      "pid": AppPreference().getString(PreferencesKey.userId), 
    });

    debugPrint("📤 API REQUEST");
    debugPrint("➡️ URL: $url");
    debugPrint("➡️ FORM DATA: ${formData.fields}");

    try {
      final response = await ApiService().postRequest(url, formData);

      if (response == null) {
        debugPrint("❌ RESPONSE NULL");
        setState(() => isLoading = false);
        return;
      }

      debugPrint("📥 STATUS CODE: ${response.statusCode}");
      debugPrint("📥 RAW RESPONSE DATA: ${response.data}");
      debugPrint("📥 RESPONSE TYPE: ${response.data.runtimeType}");

      /// 🔥 STEP 1: Convert HTTP String → JSON Map
      Map<String, dynamic> jsonBody;

      if (response.data is String) {
        jsonBody = jsonDecode(response.data);
        debugPrint("✅ STRING → JSON CONVERTED");
      } else if (response.data is Map) {
        jsonBody = Map<String, dynamic>.from(response.data);
        debugPrint("✅ MAP RECEIVED DIRECTLY");
      } else {
        debugPrint("❌ UNKNOWN RESPONSE FORMAT");
        setState(() => isLoading = false);
        return;
      }

      debugPrint("📥 FINAL JSON: $jsonBody");

      /// 🔥 STEP 2: Read JSON
      if (jsonBody["success"] == 1) {
        final List dataList = jsonBody["data"] ?? [];

        debugPrint("📦 DATA LIST LENGTH: ${dataList.length}");

        /// 🔥 STEP 3: JSON → Dart
        historyList =
            dataList.map<Map<String, String>>((item) {
              debugPrint("➡️ ITEM: $item");

              return {
                "id": item["id"].toString(),
                "day": "Day ${item["day"]}",
                "date": item["date"].toString(),
                "time": item["time"].toString(),
              };
            }).toList();

        debugPrint("✅ FINAL HISTORY LIST SIZE: ${historyList.length}");
      } else {
        debugPrint("❌ API SUCCESS = 0");
      }
    } catch (e, stack) {
      debugPrint("🔥 API ERROR: $e");
      debugPrint("🔥 STACK TRACE: $stack");
    }

    setState(() => isLoading = false);
    debugPrint("========== FETCH TREATMENT HISTORY END ==========");
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),

          Row(
            children: [
              _buildHeaderBox("Patient Id: ${widget.patientId}", Colors.orange),
              _buildHeaderBox(
                "Diagnosis Id: ${widget.diagnosisId}",
                Colors.blue,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Patient Name: ${widget.patientName}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : historyList.isEmpty
                    ? const Center(child: Text("No Treatment History Found"))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final item = historyList[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            final int nextDay = historyList.length + 1;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TreatmentAddV2Screen(
                                      patientId: widget.patientId,
                                      patientName: widget.patientName,
                                      diagnosisId: widget.diagnosisId,
                                      day: nextDay,
                                      id: item["id"]!, // ✅ int
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // LEFT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["id"]!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item["day"]!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // RIGHT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        item["date"]!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item["time"]!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          final int nextDay = historyList.length + 1;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTreatment(patientId: widget.patientId),
            ),
          );
        },
      ),
    );
  }

  // ------- Header Widget -------
  Widget _buildHeaderBox(String title, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
