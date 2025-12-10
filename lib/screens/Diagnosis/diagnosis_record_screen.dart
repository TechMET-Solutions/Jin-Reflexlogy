import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/Diagnosis/left_foot_screen.dart';
import 'package:jin_reflex_new/screens/left_foot_screen.dart';
import 'package:jin_reflex_new/screens/right_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({
    super.key,
    this.patient_id,
    this.name,
    this.diagnosis_id,
  });
  final patient_id;
  final name;
  final diagnosis_id;

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String? satisfaction = "Yes";
  final TextEditingController matchedProblem = TextEditingController();
  final TextEditingController notDetected = TextEditingController();

  final List<String> diagnosisOptions = [
    "Diagnose Left Foot",
    "Diagnose Right Foot",
    "Diagnose Left Hand",
    "Diagnose Right Hand",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3EB),

      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Diagnosis",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔶 Patient Header Bar
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
                    "Patient ID : ${widget.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Patient Name : ${widget.name}",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔶 DIAGNOSIS TITLE BAR
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

            /// 🔘 DIAGNOSIS OPTIONS LIST
            ...diagnosisOptions.map((option) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xffF9CF63), width: 2),
                ),
                child: ListTile(
                  title: Center(
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  onTap: () {
                    print(option);
                    if (option == "Diagnose Left Foot") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LeftFootScreenNew(
                                pid: widget.patient_id,
                                diagnosisId: widget.diagnosis_id,
                              ),
                        ),
                      );
                    } else if (option == "Diagnose Right Foot") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => rightFootScreenNew(
                                pid: widget.patient_id,
                                diagnosisId: widget.diagnosis_id,
                              ),
                        ),
                      );
                    } else {}
                  },
                ),
              );
            }),
            SizedBox(height: 10),
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
                        child: RadioListTile(
                          value: "Yes",
                          groupValue: satisfaction,
                          title: const Text("Yes"),
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            setState(() => satisfaction = value.toString());
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "No",
                          groupValue: satisfaction,
                          title: const Text("No"),
                          activeColor: Colors.orange,
                          onChanged: (value) {
                            setState(() => satisfaction = value.toString());
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
            _button("Cancel", Colors.black87, () {
              Navigator.pop(context);
            }),
            _button("Submit", Colors.green, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Diagnosis Submitted Successfully"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------
  // INPUT FIELD
  // ---------------------------------------
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

  // ---------------------------------------
  // CUSTOM BUTTON
  // ---------------------------------------
  Widget _button(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
