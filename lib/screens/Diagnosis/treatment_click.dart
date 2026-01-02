import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';

class TreatmentAddV2Screen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String diagnosisId;
  final String id; // treatmentId
  final int day;

  const TreatmentAddV2Screen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.diagnosisId,
    required this.id,
    required this.day,
  });

  @override
  State<TreatmentAddV2Screen> createState() => _TreatmentAddV2ScreenState();
}

class _TreatmentAddV2ScreenState extends State<TreatmentAddV2Screen> {
  bool isLoading = true;

  final Color borderYellow = const Color(0xffF3C14B);

  String treatmentDay = "-";
  String boyleMagnet = "-";
  String chakraMagnet = "-";
  String highPower = "-";
  String lowPower = "-";
  String whiteSpinal = "-";
  String yellowSpinal = "-";
  String sufferingProblems = "-";
  String resultText = "-";

  @override
  void initState() {
    super.initState();
    _fetchTreatment();
  }

  // ================= API =================
  Future<void> _fetchTreatment() async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "https://jinreflexology.in/api1/new/view_treatment.php",
        data: {"treatmentId": widget.id, "pid": "22"},
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        setState(() => isLoading = false);
        return;
      }

      final treatment = TreatmentService.parseTreatmentFromHtml(
        response.data.toString(),
      );

      if (treatment != null && treatment.success == 1) {
        final data = treatment.data!;

        setState(() {
          treatmentDay = data.day;
          boyleMagnet = data.boyleMagnet;
          chakraMagnet = data.chakraMagnet;
          highPower = data.highPowerMagnet;
          lowPower = data.lowPowerMagnet;
          whiteSpinal = data.spinalWhite;
          yellowSpinal = data.spinalYellow;
          sufferingProblems = data.sufferingProblems;
          resultText = data.result;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("ERROR => $e");
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Treatment"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    _headerCard(),
                    _outlinedSection("Boyle Magnet", boyleMagnet),
                    _outlinedSection("Chakra Magnet", chakraMagnet),
                    _outlinedSection("4G High Power Magnet", highPower),
                    _outlinedSection("4G Low Power Magnet", lowPower),
                    _outlinedSection("White Spinal", whiteSpinal),
                    _outlinedSection("Yellow Spinal", yellowSpinal),
                    _outlinedSection("Suffering Problems", sufferingProblems),
                    _resultSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  // ================= UI PARTS =================

  Widget _headerCard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderYellow, width: 2),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "View Treatment",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber,
            border: Border.all(color: borderYellow, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Patient Name : ${widget.patientName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Patient ID : ${widget.patientId}"),
                  Text("Diagnosis ID : ${widget.diagnosisId}"),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Treatment ID : ${widget.id}"),
                  Text(
                    "Day ${int.tryParse(treatmentDay) ?? treatmentDay}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _outlinedSection(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border.all(color: borderYellow, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderYellow, width: 1),
            ),
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: borderYellow, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Results",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderYellow, width: 1),
            ),
            child: Text(
              resultText.isEmpty ? "-" : resultText,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
