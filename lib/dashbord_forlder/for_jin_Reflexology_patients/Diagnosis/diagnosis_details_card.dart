import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/preference/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/preference/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_history_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

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

      print("RAW RESPONSE: ${response.data}");

      // ------------------- HTML → JSON FIX -------------------
      String raw = response.data.toString().trim();

      int start = raw.indexOf("{");
      int end = raw.lastIndexOf("}");

      if (start == -1 || end == -1) {
        throw Exception("No JSON found inside HTML response");
      }

      String jsonString = raw.substring(start, end + 1);
      print("CLEAN JSON: $jsonString");

      final jsonBody = jsonDecode(jsonString);
      // ---------------------------------------------------------

      if (jsonBody["success"] == 1) {
        final data = jsonBody["data"];

        setState(() {
          lf = base64Decode(data["lf"]);
          rf = base64Decode(data["rf"]);
          lh = base64Decode(data["lh"]);
          rh = base64Decode(data["rh"]);
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF3DD),
      appBar: CommonAppBar(title: "title"),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                "Patient Name: ${widget.patientName}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xffF9CF63),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Patient Id: ${widget.patientId}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Diagnosis ID: ${widget.diagnosisId}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Diagnosis Date:\n${widget.date}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Diagnosis Time:\n${widget.time}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // ------------------ IMAGES -------------------
            loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      lf != null ? Image.memory(lf!) : Container(),
                      rf != null ? Image.memory(rf!) : Container(),
                      lh != null ? Image.memory(lh!) : Container(),
                      rh != null ? Image.memory(rh!) : Container(),
                    ],
                  ),
                ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                  child: Text("UPDATE"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
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
                  child: Text("TREATMENT"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
