import 'package:flutter/material.dart';

class ModernDiagnosisScreen extends StatelessWidget {
  const ModernDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        title: const Text(
          "Diagnosis Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------------------------
              // TOP PATIENT INFO CARD
              // ---------------------------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Patient Name", "Sapna Kalpesh Gandhi"),
                    const SizedBox(height: 10),
                    _infoBoxRow("Patient ID: 1012", Colors.orange),
                    const SizedBox(height: 10),
                    _infoBoxRow("Diagnosis ID: 23970", Colors.green),
                    const SizedBox(height: 16),
                    _blueBox(
                      "Diagnosis Date: 21-05-2024",
                      "Diagnosis Time: 16:10:46",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ---------------------------
              // FIRST FOOT IMAGE
              // ---------------------------
              _footImageCard("assets/images/foot_left.png"),

              const SizedBox(height: 20),

              // ---------------------------
              // SECOND FOOT IMAGE
              // ---------------------------
              _footImageCard("assets/images/foot_left.png"),
              const SizedBox(height: 30),

              // ---------------------------
              // ACTION BUTTONS
              // ---------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    label: "UPDATE",
                    color: Colors.green,
                    onTap: () {},
                  ),
                  _actionButton(
                    label: "TREATMENT",
                    color: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // Helper Widgets Below
  // -----------------------------

  Widget _infoRow(String title, String value) {
    return Text(
      "$title: $value",
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }

  Widget _infoBoxRow(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _blueBox(String left, String right) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            right,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footImageCard(String path) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
