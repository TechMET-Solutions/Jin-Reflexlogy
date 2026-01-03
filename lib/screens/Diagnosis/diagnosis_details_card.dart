import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_history_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class DiagnosisDetailsCard extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String diagnosisId;
  final String date;
  final String time;
  final String title;

  DiagnosisDetailsCard({
    required this.patientName,
    required this.patientId,
    required this.diagnosisId,
    required this.date,
    required this.time,
    required this.title,
  });

  @override
  State<DiagnosisDetailsCard> createState() => _DiagnosisDetailsCardState();
}

class _DiagnosisDetailsCardState extends State<DiagnosisDetailsCard> {
  Uint8List? lf;
  Uint8List? rf;
  Uint8List? lh;
  Uint8List? rh;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchDiagnosisImages();
  }

  Future<void> fetchDiagnosisImages() async {
    try {
      final formData = FormData.fromMap({
        "pid": AppPreference().getString(PreferencesKey.userId),
        "diagnosisId": widget.diagnosisId,
      });

      final response = await Dio().post(
        diagnosis_images,
        data: formData,
        options: Options(responseType: ResponseType.plain),
      );

      String raw = response.data.toString().trim();

      int start = raw.indexOf("{");
      int end = raw.lastIndexOf("}");

      if (start == -1 || end == -1) {
        throw Exception("No JSON found");
      }

      String jsonString = raw.substring(start, end + 1);
      final jsonBody = jsonDecode(jsonString);

      if (jsonBody["success"] == 1) {
        final data = jsonBody["data"];

        setState(() {
          lf = data["lf"] != null ? base64Decode(data["lf"]) : null;
          rf = data["rf"] != null ? base64Decode(data["rf"]) : null;
          lh = data["lh"] != null ? base64Decode(data["lh"]) : null;
          rh = data["rh"] != null ? base64Decode(data["rh"]) : null;
          loading = false;
        });
      } else {
        loading = false;
      }
    } catch (e) {
      print("ERROR: $e");
      loading = false;
    }

    setState(() {});
  }

  Widget imageBox(Uint8List? image, String label) {
    if (image == null) return SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(image, width: 200, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3DD),
      appBar: CommonAppBar(title: "title"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Patient Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                "Patient Name: ${widget.patientName}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xffF9CF63),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Patient Id: ${widget.patientId}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Diagnosis ID: ${widget.diagnosisId}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Diagnosis Date:\n${widget.date}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Diagnosis Time:\n${widget.time}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// -------- IMAGES (VERTICAL) ----------
            Expanded(
              child:
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        child: Column(
                          children: [
                            imageBox(lf, "Left Foot"),
                            imageBox(rf, "Right Foot"),
                            imageBox(lh, "Left Hand"),
                            imageBox(rh, "Right Hand"),
                          ],
                        ),
                      ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
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
                  child: const Text("UPDATE",style: TextStyle(color:Colors.white),),
                ),
                ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DiagnosisHistoryScreen(
                              patientId: widget.patientId,
                              diagnosisId: widget.diagnosisId,
                              patientName: widget.patientName,
                            ),
                      ),
                    );
                  },
                  child:  Text("TREATMENT" ,style:TextStyle(color:Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
