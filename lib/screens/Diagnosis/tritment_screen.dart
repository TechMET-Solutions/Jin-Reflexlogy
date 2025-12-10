import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/screens/Diagnosis/add_diagnosis_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_details_card.dart';
import 'dart:convert';

import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';

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

  DiagnosisListScreen({
    required this.patientName,
    required this.patientId,
    required this.pid,
    required this.diagnosisId,
  });

  @override
  State<DiagnosisListScreen> createState() => _DiagnosisListScreenState();
}

class _DiagnosisListScreenState extends State<DiagnosisListScreen> {
  List<DiagnosisData> diagnosisList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiagnosisList();
  }

  // -------------------------------------------------------
  // API CALL — PERFECT PARSING (HTML → JSON SAFE)
  // -------------------------------------------------------
  Future<void> fetchDiagnosisList() async {
    try {
      final formData = FormData.fromMap({
        "pid": widget.pid,
        "patient_id": widget.patientId,
      });

      final response = await ApiService().postRequest(
        "https://jinreflexology.in/api/list_diagnosis.php",
        formData,
      );

      print("RAW RESPONSE: ${response?.data}");

      dynamic jsonBody;

      // If response comes as HTML string → convert to JSON
      if (response?.data is String) {
        jsonBody = jsonDecode(response?.data);
      } else {
        jsonBody = response?.data;
      }

      if (jsonBody["success"] == 1) {
        final raw = jsonBody["data"] as List;

        setState(() {
          diagnosisList = raw.map((e) => DiagnosisData.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print("Diagnosis API Error: $e");
    }

    setState(() => isLoading = false);
  }

  // -------------------------------------------------------
  // UI
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        label: Text(
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
      backgroundColor: Color(0xFFFDF3DD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- Patient Name -------------------
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Patient Name : ${widget.patientName}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // ----------------- Patient ID + Diagnosis ID -------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  pill("Patient ID : ${widget.patientId}"),
                  SizedBox(width: 10),
                  pill("Diagnosis ID : ${widget.diagnosisId}"),
                ],
              ),
            ),

            SizedBox(height: 20),

            // ----------------- Diagnosis List -------------------
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.orange))
                : Expanded(
                  child: ListView.builder(
                    itemCount: diagnosisList.length,
                    itemBuilder: (context, index) {
                      final item = diagnosisList[index];

                      return InkWell(
                        onTap: () {
                          final parts = item.timestamp.split(" ");
                          final date = parts[0];
                          final time = parts[1];
                          print(item.timestamp);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DiagnosisDetailsCard(
                                    patientId: widget.patientId,
                                    patientName: widget.patientName,
                                    diagnosisId: item.id,
                                    date: date,
                                    time: time,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.id}    Day: ${index + 1}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                item.timestamp,
                                style: TextStyle(
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

            // ----------------- Add Button -------------------
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
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
