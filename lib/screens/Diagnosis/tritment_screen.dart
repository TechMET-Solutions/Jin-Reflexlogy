import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/api_state.dart' hide ApiService;
import 'package:jin_reflex_new/main.dart'; // routeObserver
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_details_card.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

/// -------------------------------------------------------
/// MODEL
/// -------------------------------------------------------
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

/// -------------------------------------------------------
/// MAIN SCREEN
/// -------------------------------------------------------
class DiagnosisListScreen extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String pid;
  final String diagnosisId;
  final String? gender;

  const DiagnosisListScreen({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.pid,
    required this.diagnosisId,
    this.gender,
  });

  @override
  State<DiagnosisListScreen> createState() => _DiagnosisListScreenState();
}

class _DiagnosisListScreenState extends State<DiagnosisListScreen>
    with RouteAware {
  List<DiagnosisData> diagnosisList = [];
  bool isLoading = true;
  bool _isSubscribed = false;

  /// -------------------------------------------------------
  /// INIT
  /// -------------------------------------------------------
  @override
  void initState() {
    super.initState();
    debugPrint("👤 DiagnosisListScreen OPENED");
    debugPrint("👤 Gender received => ${widget.gender}");
    fetchDiagnosisList();
  }

  /// -------------------------------------------------------
  /// ROUTE OBSERVER
  /// -------------------------------------------------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute && !_isSubscribed) {
      routeObserver.subscribe(this, route);
      _isSubscribed = true;
    }
  }

  @override
  void didPopNext() {
    fetchDiagnosisList(); // refresh on back
  }

  @override
  void dispose() {
    if (_isSubscribed) {
      routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  /// -------------------------------------------------------
  /// API CALL
  /// -------------------------------------------------------
  Future<void> fetchDiagnosisList() async {
    setState(() => isLoading = true);

    try {
      final formData = FormData.fromMap({
        "pid": widget.pid,
        "patient_id": widget.patientId,
      });

      final response = await ApiService().postRequest(
        "https://jinreflexology.in/api1/new/list_diagnosis.php",
        formData,
      );

      dynamic jsonBody =
          response?.data is String
              ? jsonDecode(response!.data)
              : response?.data;

      if (jsonBody != null && jsonBody["success"] == 1) {
        final List raw = jsonBody["data"];
        diagnosisList = raw.map((e) => DiagnosisData.fromJson(e)).toList();
      } else {
        diagnosisList = [];
      }
    } catch (e) {
      diagnosisList = [];
    }

    setState(() => isLoading = false);
  }

  /// -------------------------------------------------------
  /// UI
  /// -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Treatment"),

      /// ---------------- FAB ----------------
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
                    gender: widget.gender,
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

      /// ---------------- BODY ----------------
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Patient Name
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

            /// Patient ID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: pill("Patient ID : ${widget.patientId}"),
            ),

            const SizedBox(height: 20),

            /// Diagnosis List
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: diagnosisList.length,
                    itemBuilder: (context, index) {
                      final item = diagnosisList[index];
                      final parts = item.timestamp.split(" ");
                      final date = parts[0];
                      final time = parts.length > 1 ? parts[1] : "";

                      return InkWell(
                        onTap: () {
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
                                item.id,
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

  /// -------------------------------------------------------
  /// PILL
  /// -------------------------------------------------------
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
