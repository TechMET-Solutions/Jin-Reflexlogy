import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class altTreatmentAddV2Screen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String diagnosisId;
  final String id; // treatmentId
  final int day;

  const altTreatmentAddV2Screen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.diagnosisId,
    required this.id,
    required this.day,
  });

  @override
  State<altTreatmentAddV2Screen> createState() =>
      _altTreatmentAddV2ScreenState();
}

class _altTreatmentAddV2ScreenState extends State<altTreatmentAddV2Screen> {
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

  // ================= FETCH EXISTING TREATMENT =================
  Future<void> _fetchTreatment() async {
    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api1/new/view_treatment.php",
        data: {"pid": widget.patientId, "treatmentId": widget.id},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode != 200) {
        setState(() => isLoading = false);
        return;
      }

      final parsed = jsonDecode(response.data);

      if (parsed["success"] == 1) {
        final data = parsed["data"];

        setState(() {
          treatmentDay = data["day"] ?? "-";
          boyleMagnet = data["boyle magnet"] ?? "-";
          chakraMagnet = data["chakra magnet"] ?? "-";
          highPower = data["4g high power magnet"] ?? "-";
          lowPower = data["4g low power magnet"] ?? "-";
          whiteSpinal = data["spinal_white"] ?? "-";
          yellowSpinal = data["spinal_yellow"] ?? "-";
          sufferingProblems = data["suffering_problems"] ?? "-";
          resultController.text = data["result"] ?? "";
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("FETCH ERROR => $e");
      setState(() => isLoading = false);
    }
  }

  // ================= SUBMIT RESULT =================
  Future<void> submitTreatmentResult() async {
    if (resultController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter result")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api1/new/view_treatment.php",
        data: {
          "pid": widget.patientId,
          "treatmentId": widget.id,
          "result": resultController.text.trim(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      );

      debugPrint("SUBMIT RESPONSE => ${response.data}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.data);

        if (decoded["success"] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Treatment updated successfully ✅"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(decoded["message"] ?? "Update failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("SUBMIT ERROR => $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jin Reflexology"),
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

  // ================= UI WIDGETS =================

  Widget _headerCard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
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
                    "Day ${(int.tryParse(treatmentDay) ?? 0) + 1}",
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderYellow),
            ),
            child: Text(value),
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
          const Text("Results", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderYellow),
            ),
            child: TextField(
              controller: resultController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "Enter result",
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
        onPressed: isLoading ? null : submitTreatmentResult,
        child:
            isLoading
                ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
