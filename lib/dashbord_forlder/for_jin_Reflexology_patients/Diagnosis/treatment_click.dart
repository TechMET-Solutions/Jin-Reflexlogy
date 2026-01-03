import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController resultController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _fetchTreatment();
  }

  // ================= API INTEGRATION =================

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
          validateStatus: (status) => true,
        ),
      );

      debugPrint("========== RAW RESPONSE ==========");
      debugPrint(response.data.toString());
      debugPrint("STATUS CODE => ${response.statusCode}");
      debugPrint("=================================");

      if (response.statusCode != 200) {
        debugPrint("❌ SERVER ERROR");
        setState(() => isLoading = false);
        return;
      }

      final treatment = TreatmentService.parseTreatmentFromHtml(
        response.data.toString(),
      );

      if (treatment != null && treatment.success == 1) {
        final data = treatment.data!;

        // 🔥🔥🔥 MAIN FIX — UI UPDATE 🔥🔥🔥
        setState(() {
          treatmentDay = data.day;
          boyleMagnet = data.boyleMagnet;
          chakraMagnet = data.chakraMagnet;
          highPower = data.highPowerMagnet;
          lowPower = data.lowPowerMagnet;
          whiteSpinal = data.spinalWhite;
          yellowSpinal = data.spinalYellow;
          sufferingProblems = data.sufferingProblems;
          resultController.text = data.result;
          isLoading = false;
        });

        debugPrint("✅ UI UPDATED");
      } else {
        debugPrint("❌ NO DATA");
        debugPrint(treatment?.message ?? "Treatment Details Not Available!");
        setState(() => isLoading = false);
      }
    } catch (e, stack) {
      debugPrint("🔥 ERROR OCCURRED");
      debugPrint("ERROR : $e");
      debugPrint("STACK : $stack");
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
                    _resultsSection(),
                    const SizedBox(height: 20),
                    _submitButton(),
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
                    "Day $treatmentDay",
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
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderYellow, width: 1),
            ),
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _resultsSection() {
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderYellow, width: 1),
            ),
            child: TextField(
              controller: resultController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "-",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
