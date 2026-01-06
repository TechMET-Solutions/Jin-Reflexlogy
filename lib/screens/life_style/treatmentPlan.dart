import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_flip/page_flip.dart';

class TreatmentPlanScreen extends StatefulWidget {
  const TreatmentPlanScreen({super.key});

  @override
  State<TreatmentPlanScreen> createState() => _TreatmentPlanScreenState();
}

class _TreatmentPlanScreenState extends State<TreatmentPlanScreen> {
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController detailsCtrl = TextEditingController();

  bool isSubmitting = false;
  Future<void> submitTreatmentEnquiry() async {
    if (firstNameCtrl.text.isEmpty ||
        lastNameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        detailsCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isSubmitting = true);
    final response = await http.post(
      Uri.parse("https://admin.jinreflexology.in/api/treatment-enquiry"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "first_name": firstNameCtrl.text,
        "last_name": lastNameCtrl.text,
        "email": emailCtrl.text,
        "phone": phoneCtrl.text,
        "details": detailsCtrl.text,
      }),
    );

    setState(() => isSubmitting = false);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      if (res['success'] == true) {
        firstNameCtrl.clear();
        lastNameCtrl.clear();
        emailCtrl.clear();
        phoneCtrl.clear();
        detailsCtrl.clear();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res['message'])));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit enquiry")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: const Color(0xff101926),
        foregroundColor: Colors.white,
        title: const Text("Treatment Plan"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _feedbackImageBox(),
            const SizedBox(height: 20),
            _feedbackImageBox(),
            const SizedBox(height: 20),

            /// ---------------------------
            /// FORM FIELDS
            /// ---------------------------
            _textField("First Name", firstNameCtrl),
            _textField("Last Name", lastNameCtrl),
            _textField("Email", emailCtrl),
            _textField("Phone", phoneCtrl),
            _textField("Details", detailsCtrl, maxLines: 4),

            const SizedBox(height: 20),

            /// ---------------------------
            /// SUBMIT BUTTON
            /// ---------------------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff101926),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isSubmitting ? null : submitTreatmentEnquiry,
                child:
                    isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "SUBMIT ENQUIRY",
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),

            const SizedBox(height: 25),

            /// ---------------------------
            /// IMAGES SECTION WITH PADDING
            /// ---------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(child: _imageCard("assets/images/treatement1.png")),
                  const SizedBox(width: 15),
                  Expanded(child: _imageCard("assets/images/treatement2.png")),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(child: _imageCard("assets/images/treatement3.png")),
                  const SizedBox(width: 15),
                  Expanded(child: _imageCard("assets/images/treatement4.png")),
                ],
              ),
            ),

            const SizedBox(height: 25),

            _yellowTitle("PREVENTIVE HEALTH CARE CAMPAIGN"),
            const SizedBox(height: 20),

            _yellowHeader("WHAT IS PREVENTIVE HEALTH CARE PROGRAM?"),
            _yellowTextContainer(
              "The main holistic therapist experts of the country have outlined "
              "this to keep our body from preventing diseases & keeping it healthy.",
            ),

            const SizedBox(height: 20),

            _yellowHeader("WHY IS IT NECESSARY AT PRESENT TIME?"),
            _yellowTextContainer(
              "Lifestyle diseases including diabetes, hypertension, cancer "
              "and cardiac problems are more common today.",
            ),

            const SizedBox(height: 20),

            _yellowHeader("BENEFITS FROM PREVENTIVE HEALTH CARE PROGRAM?"),
            _yellowTextContainer(
              "Millions of people in India and abroad are living a healthy life.",
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(child: _imageCard("assets/images/treatement5.png")),
                  const SizedBox(width: 15),
                  Expanded(child: _imageCard("assets/images/treatement6.png")),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                 // const SizedBox(height: 30),
                 
                  Expanded(child: Image.asset('assets/images/treatement7.png')),
                  //const SizedBox(height: 15),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Flip Book with Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SizedBox(
                height: 600,
                width: double.infinity,
                child: PageFlipWidget(
                  children: [
                    Image.asset('assets/images/treatement2.png'),
                    Image.asset('assets/images/treatement3.png'),
                    Image.asset('assets/images/treatement2.png'),
                    Image.asset('assets/images/treatement3.png'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              isDense: true,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black45),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- FEEDBACK IMAGE ----------------
  Widget _feedbackImageBox() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          const Expanded(
            child: Center(child: Icon(Icons.image_not_supported, size: 40)),
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            color: const Color(0xfff7eed6),
            child: const Text("JIN Reflexology Feedback"),
          ),
        ],
      ),
    );
  }

  Widget _imageCard(String img) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(img, fit: BoxFit.cover),
      ),
    );
  }

  Widget _yellowTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffffd56b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _yellowHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffffefd5),
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _yellowTextContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
    );
  }
}