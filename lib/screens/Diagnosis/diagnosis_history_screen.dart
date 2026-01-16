import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/screens/Diagnosis/alternate_new.dart';
import 'package:jin_reflex_new/screens/Diagnosis/new_treatment.dart';
import 'package:jin_reflex_new/screens/Diagnosis/treatment_click.dart';

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

  // ================= API CALL =================
  Future<void> fetchTreatmentHistory() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final formData = FormData.fromMap({
      "diagnosisId": widget.diagnosisId,
      "pid": AppPreference().getString(PreferencesKey.userId),
    });

    try {
      final response = await ApiService().postRequest(list_treatment, formData);

      if (response != null) {
        Map<String, dynamic> jsonBody =
            response.data is String ? jsonDecode(response.data) : response.data;

        if (jsonBody["success"] == 1) {
          final List dataList = jsonBody["data"] ?? [];

          historyList =
              dataList.map<Map<String, String>>((item) {
                return {
                  "id": item["id"].toString(),
                  "day": "Day ${item["day"]}",
                  "date": item["date"].toString(),
                  "time": item["time"].toString(),
                };
              }).toList();
        }
      }
    } catch (e) {
      debugPrint("API ERROR => $e");
    }

    if (mounted) setState(() => isLoading = false);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: Column(
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
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
                    ? RefreshIndicator(
                      onRefresh: fetchTreatmentHistory,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(child: Text("No Treatment History Found")),
                        ],
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: fetchTreatmentHistory,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyList[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => TreatmentAddV2Screen(
                                        patientId: widget.patientId,
                                        patientName: widget.patientName,
                                        diagnosisId: widget.diagnosisId,
                                        day: index + 1,
                                        id: item["id"]!,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
          ),
        ],
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          final int totalDays = historyList.length;

          if (totalDays == 0 || totalDays >= 8) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => NewTreatment(
                      patientId: widget.patientId,
                      diagnosisId: widget.diagnosisId,
                    ),
              ),
            );
          } else {
            final int nextDay = totalDays + 1;
            final String lastId = historyList.last["id"]!;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => altTreatmentAddV2Screen(
                      patientId: widget.patientId,
                      patientName: widget.patientName,
                      diagnosisId: widget.diagnosisId,
                      day: nextDay,
                      id: lastId,
                    ),
              ),
            );
          }
        },
      ),
    );
  }

  // ---------- HEADER BOX ----------
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