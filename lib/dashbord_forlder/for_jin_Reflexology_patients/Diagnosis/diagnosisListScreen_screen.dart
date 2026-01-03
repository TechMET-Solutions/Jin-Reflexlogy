import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/main.dart'; // 🔥 routeObserver
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_details_card.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

// -------------------------------------------------------
// MODEL
// -------------------------------------------------------
class DiagnosisData {
  final String id;
  final String timestamp;

  DiagnosisData({required this.id, required this.timestamp});

  factory DiagnosisData.fromJson(Map<String, dynamic> json) {
    return DiagnosisData(
      id: json['id'].toString(),
      timestamp: json['timestamp'] ?? "",
    );
  }
}

// -------------------------------------------------------
// MAIN SCREEN
// -------------------------------------------------------
class DiagnosisListScreen extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String pid;
  final String diagnosisId;

  const DiagnosisListScreen({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.pid,
    required this.diagnosisId,
  });

  @override
  State<DiagnosisListScreen> createState() => _DiagnosisListScreenState();
}

class _DiagnosisListScreenState extends State<DiagnosisListScreen>
    with RouteAware {
  List<DiagnosisData> diagnosisList = [];
  bool isLoading = true;

  // -------------------------------------------------------
  // INIT
  // -------------------------------------------------------
  @override
  void initState() {
    super.initState();
    fetchDiagnosisList(); // first time
  }

  // -------------------------------------------------------
  // ROUTE AWARE (AUTO REFRESH)
  // -------------------------------------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    // 🔥 Jab bhi kisi screen se BACK aaye
    fetchDiagnosisList();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // -------------------------------------------------------
  // API CALL — POST + HTML/JSON SAFE
  // -------------------------------------------------------
  Future<void> fetchDiagnosisList() async {
    setState(() => isLoading = true);

    try {
      final formData = FormData.fromMap({
        "pid": widget.pid,
        "patient_id": widget.patientId,
      });

      for (var field in formData.fields) {
        debugPrint("FIELD => ${field.key} : ${field.value}");
      }

      final response = await ApiService().postRequest(
        "https://jinreflexology.in/api/list_diagnosis.php",
        formData,
      );

      debugPrint("RAW RESPONSE => ${response?.data}");

      dynamic jsonBody;

      if (response?.data is String) {
        jsonBody = jsonDecode(response?.data);
      } else {
        jsonBody = response?.data;
      }

      if (jsonBody != null && jsonBody["success"] == 1) {
        final raw = jsonBody["data"] as List;

        setState(() {
          diagnosisList = raw.map((e) => DiagnosisData.fromJson(e)).toList();
        });
      } else {
        diagnosisList = [];
      }
    } catch (e) {
      debugPrint("Diagnosis API Error: $e");
      diagnosisList = [];
    }

    setState(() => isLoading = false);
  }

  // -------------------------------------------------------
  // UI
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Treatment"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DiagnosisScreen(
                    patient_id: widget.patientId,
                    name: widget.patientName,
                    diagnosis_id: widget.diagnosisId,
                  ),
            ),
          );
        },
        backgroundColor: Colors.orange.shade300,
        label: const Text(
          "Add +",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: const Color(0xFFFDF3DD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- Patient Name -------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Patient Name : ${widget.patientName}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ----------------- IDs -------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  pill("Patient ID : ${widget.patientId}"),
                  const SizedBox(width: 10),
                  pill("Diagnosis ID : ${widget.diagnosisId}"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ----------------- Diagnosis List -------------------
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: diagnosisList.length,
                    itemBuilder: (context, index) {
                      final item = diagnosisList[index];

                      return InkWell(
                        onTap: () {
                          final parts = item.timestamp.split(" ");
                          final date = parts[0];
                          final time = parts.length > 1 ? parts[1] : "";

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => DiagnosisDetailsCard(
                                    patientId: widget.patientId,
                                    patientName: widget.patientName,
                                    diagnosisId: item.id,
                                    date: date,
                                    time: time,
                                    title: "Day: ${index + 1}",
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.id}    Day: ${index + 1}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.timestamp,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
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
      ),
    );
  }

  // -------------------------------------------------------
  // Pill Design
  // -------------------------------------------------------
  Widget pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}