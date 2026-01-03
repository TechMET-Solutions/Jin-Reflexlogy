import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/left_foot_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/left_hand_sc.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/right_hand_sc.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/right_screen.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({
    super.key,
    this.patient_id,
    this.name,
    this.diagnosis_id,
  });

  // keep dynamic for flexibility (int or String)
  final dynamic patient_id;
  final dynamic name;
  final dynamic diagnosis_id;

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String? satisfaction = "Yes";
  final TextEditingController matchedProblem = TextEditingController();
  final TextEditingController notDetected = TextEditingController();

  // Track which parts are completed
  bool lfSaved = false;
  bool rfSaved = false;
  bool lhSaved = false;
  bool rhSaved = false;

  // Store results
  String? lfData;
  String? lfImg64;
  String? lfResult;
  String? rfData;
  String? rfResult;
  String? rfImg;
  String? rhData;
  String? rhResult;
  String? rhImg;
  String? lhData;
  String? lhResult;
  String? lhImg;

  bool isLoading = false;

  final List<Map<String, dynamic>> diagnosisOptions = [
    {
      "title": "Diagnose Left Foot",
      "type": "lf",
      "screen": LeftFootScreenNew(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
    {
      "title": "Diagnose Right Foot",
      "type": "rf",
      "screen": RightFootScreenNew(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
    {
      "title": "Diagnose Left Hand",
      "type": "lh",
      "screen": LeftHandScreen(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
    {
      "title": "Diagnose Right Hand",
      "type": "rh",
      "screen": RightHandScreen(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void showSnack(BuildContext context, String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Check if all four parts are completed
  bool get allPartsCompleted {
    return lfSaved && rfSaved && lhSaved && rhSaved;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3EB),
      appBar: CommonAppBar(title: "Diagnosis"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xffF9CF63),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient ID : ${widget.patient_id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Patient Name : ${widget.name}",
                    style: const TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Diagnosis Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xffF9CF63),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: const Center(
                child: Text(
                  "Diagnosis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Diagnosis Options with status indicators
            ...diagnosisOptions.map((option) {
              String type = option["type"];
              bool isCompleted = false;
              String result = "";

              switch (type) {
                case "lf":
                  isCompleted = lfSaved;
                  result = lfResult ?? "";
                  break;
                case "rf":
                  isCompleted = rfSaved;
                  result = rfResult ?? "";
                  break;
                case "lh":
                  isCompleted = lhSaved;
                  result = lhResult ?? "";
                  break;
                case "rh":
                  isCompleted = rhSaved;
                  result = rhResult ?? "";
                  break;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted ? Colors.green : const Color(0xffF9CF63),
                    width: isCompleted ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          isCompleted ? Colors.green : const Color(0xffF9CF63),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    option["title"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  subtitle:
                      isCompleted && result.isNotEmpty
                          ? Text(
                            "Result: $result",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                          : null,
                  trailing: Icon(
                    isCompleted ? Icons.check_circle : Icons.arrow_forward_ios,
                    color: isCompleted ? Colors.green : Colors.grey,
                    size: 20,
                  ),
                  onTap: () async {
                    dynamic result;

                    if (type == "lf") {
                      result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => LeftFootScreenNew(
                                pid: widget.patient_id.toString(),
                                diagnosisId: widget.diagnosis_id.toString(),
                              ),
                        ),
                      );
                    } else if (type == "rf") {
                      result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => RightFootScreenNew(
                                pid: widget.patient_id.toString(),
                                diagnosisId: widget.diagnosis_id.toString(),
                              ),
                        ),
                      );
                    } else if (type == "rh") {
                      result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => RightHandScreen(
                                pid: widget.patient_id.toString(),
                                diagnosisId: widget.diagnosis_id.toString(),
                              ),
                        ),
                      );
                    } else if (type == "lh") {
                      result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => LeftHandScreen(
                                pid: widget.patient_id.toString(),
                                diagnosisId: widget.diagnosis_id.toString(),
                              ),
                        ),
                      );
                    }

                    if (result != null && result is Map) {
                      debugPrint("⬅️ Data received from $type: $result");

                      setState(() {
                        switch (type) {
                          case "lf":
                            lfSaved = true;
                            lfResult = result['if_result'];
                            lfData = result['if_data'];
                            lfImg64 = result['screenshot_base64'];
                            debugPrint("LF RESULT => $lfResult");
                            break;
                          case "rf":
                            rfSaved = true;
                            rfData = result["rf_data"];
                            rfResult = result["rf_result"];
                            rfImg = result["rf_img"];
                            break;
                          case "rh":
                            rhSaved = true;
                            rhData = result["rh_data"];
                            rhResult = result["rh_result"];
                            rhImg = result["rh_img"];
                            break;
                          case "lh":
                            lhSaved = true;
                            lhData = result["lh_data"];
                            lhResult = result["lh_result"];
                            lhImg = result["lh_img"];
                            break;
                        }
                      });

                      // Show success message
                      if (mounted) {
                        showSnack(
                          context,
                          "${option["title"]} completed successfully!",
                        );
                      }
                    }
                  },
                ),
              );
            }),

            // Status Summary
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusIndicator("LF", lfSaved),
                  _statusIndicator("RF", rfSaved),
                  _statusIndicator("LH", lhSaved),
                  _statusIndicator("RH", rhSaved),
                ],
              ),
            ),

            // Satisfaction Section
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Are You Satisfied with the Diagnosis?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: "Yes",
                          groupValue: satisfaction,
                          title: const Text("Yes"),
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            setState(() => satisfaction = value);
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: "No",
                          groupValue: satisfaction,
                          title: const Text("No"),
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            setState(() => satisfaction = value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  _textInput(
                    "Which of the Diagnosis points match your problem?",
                    matchedProblem,
                  ),

                  const SizedBox(height: 12),

                  _textInput("Which problems were not detected?", notDetected),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button(
              "Cancel",
              Colors.black87,
              () => Navigator.pop(context),
              isEnabled: true,
            ),
            _button(
              "Submit",
              allPartsCompleted ? Colors.green : Colors.grey,
              allPartsCompleted
                  ? () async {
                    await submitDiagnosis();
                  }
                  : () {
                    showSnack(
                      context,
                      "Please complete all 4 diagnosis parts first!",
                      error: true,
                    );
                  },
              isEnabled: allPartsCompleted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIndicator(String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? Colors.green.shade800 : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isCompleted ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isCompleted ? "✓ Done" : "Pending",
          style: TextStyle(
            color: isCompleted ? Colors.green : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _textInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
    );
  }

  Widget _button(
    String label,
    Color color,
    VoidCallback onTap, {
    bool isEnabled = true,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? color : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isEnabled ? Colors.white : Colors.grey,
          fontSize: 15,
        ),
      ),
    );
  }

  Future<void> submitDiagnosis() async {
    setState(() {
      isLoading = true;
    });

    try {
      FormData formData = FormData.fromMap({
        "lf_data": lfData ?? "",
        "lf_img": lfImg64 ?? "",
        "lf_result": lfResult ?? "",
        "rf_data": rfData ?? "",
        "rf_img": rfImg ?? "",
        "rf_result": rfResult ?? "",
        "lh_data": lhData ?? "",
        "lh_img": lhImg ?? "",
        "lh_result": lhResult ?? "",
        "rh_data": rhData ?? "",
        "rh_img": rhImg ?? "",
        "rh_result": rhResult ?? "",
        "problems_matched": matchedProblem.text,
        "not_detected": notDetected.text,
        "patient_id": widget.patient_id,
        "pid": widget.patient_id,
        "diagnosis_id": widget.diagnosis_id,
        "is_satisfied": satisfaction ?? "Yes",
        "timestamp": DateTime.now().toString().replaceAll(" ", "+"),
      });

      final response = await Dio().post(
        add_diagnosis,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
          responseType: ResponseType.plain,
        ),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY:\n${response.data}");

      if (response.statusCode == 200) {
        showSnack(context, "Diagnosis Submitted Successfully!");

        // Navigate back or show success screen
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        showSnack(context, "Something went wrong!", error: true);
      }
    } catch (e) {
      debugPrint("API ERROR: $e");
      showSnack(context, "API ERROR: $e", error: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
