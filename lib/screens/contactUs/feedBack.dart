// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class FeedBack extends StatelessWidget {
//   const FeedBack({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [

//               _titleText("Video Gallery"),

//               _section(
//                 title: "1. JIN Reflexology Advanced Info (English)",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_1",
//               ),

//               _section(
//                 title:
//                     "2. JIN Reflexology Diagnosis - Feedback By JR Varsha Lohade (English)",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_2",
//               ),

//               _section(
//                 title: "3. Magnet Therapy - JR Anil JIN",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_3",
//               ),

//               _section(
//                 title:
//                     "4. History and Advantage of JIN Reflexology (Hindi ) - JR Anil JIN",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_4",
//               ),

//               _section(
//                 title:
//                     "5. Amazing feature of JIN Reflexology - Perfect Diagnosis",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_5",
//               ),

//               _section(
//                 title: "6. JIN Reflexology Song",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_6",
//                 subtitle: "JIN Reflexology Song",
//               ),

//               _section(
//                 title:
//                     "7. JIN Reflexology workshop at Nashik - Feedback",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_7",
//                 subtitle:
//                     "JIN Reflexology Acupressure awareness workshop at Nashik",
//               ),

//               _section(
//                 title: "8. Training – JIN Reflexology FeedBack",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_8",
//                 subtitle:
//                     "JIN Reflexology Acupressure Advanced training programme",
//               ),

//               _section(
//                 title: "9. Immunity Power – JIN Reflexology FeedBack",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_9",
//                 subtitle:
//                     "Increased Immunity Power – Through JIN Reflexology Acupressure",
//               ),

//               _section(
//                 title: "10. Workshop – JIN Reflexology FeedBack",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_10",
//                 subtitle:
//                     "JIN Reflexology Acupressure two days workshop in Jabalpur (MP)",
//               ),

//               _section(
//                 title: "11. Thyroid – JIN Reflexology FeedBack",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_11",
//                 subtitle:
//                     "Thyroid cure through JIN Reflexology Acupressure",
//               ),

//               _section(
//                 title: "12. Cervical – JIN Reflexology FeedBack",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_12",
//                 subtitle:
//                     "Cervical spondylitis cure through JIN Reflexology Acupressure",
//               ),

//               _section(
//                 title:
//                     "13. Prostate Gland – JIN Reflexology Feedback",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_13",
//                 subtitle:
//                     "Prostate Gland Relief by JIN Reflexology Acupressure",
//               ),

//               _section(
//                 title: "14. Stress – JIN Reflexology Feedback",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_14",
//                 subtitle:
//                     "Stress control by JIN Reflexology Acupressure",
//               ),

//               _section(
//                 title: "15. JIN Reflexology Book Releasing",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_15",
//                 subtitle:
//                     "Hon’ble Rajendra Babuji Darda (Minister for Industry) Releasing the book Indian life Style Acupressure (JIN Reflexology)",
//               ),

//               _section(
//                 title:
//                     "16. JIN Reflexology Acupressure Content for Beginners",
//                 url: "https://www.youtube.com/embed/VIDEO_ID_16",
//                 subtitle:
//                     "Reflexology is a holistic treatment based on the principle that there are areas and points on the feet, hands, and ears...",
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔹 Widgets

//   Widget _titleText(String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _section({
//     required String title,
//     required String url,
//     String? subtitle,
//   }) {
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         _staticTitle(title),
//         const SizedBox(height: 8),
//         _webView(url),
//         if (subtitle != null) ...[
//           const SizedBox(height: 6),
//           _staticSubtitle(subtitle),
//         ],
//       ],
//     );
//   }

//   Widget _staticTitle(String text) {
//     return Text(
//       text,
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//       ),
//     );
//   }

//   Widget _staticSubtitle(String text) {
//     return Text(
//       text,
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.white70,
//       ),
//     );
//   }

//   Widget _webView(String url) {
//     return SizedBox(
//       height: 200,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: WebViewWidget(
//           controller: WebViewController()
//             ..setJavaScriptMode(JavaScriptMode.unrestricted)
//             ..loadRequest(Uri.parse(url)),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController enquiryController = TextEditingController();

  bool isSubmitting = false;

  // ===============================
  // SUBMIT FEEDBACK API
  // ===============================
  Future<void> submitFeedback() async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();
    final feedback = enquiryController.text.trim();

    if (name.isEmpty || mobile.isEmpty || feedback.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10 digit mobile number")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse("https://admin.jinreflexology.in/api/customer-feedback"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "mobile": mobile,
          "feedback": feedback,
        }),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        /// ✅ FORCE CLEAR (most reliable way)
        setState(() {
          nameController.text = "";
          mobileController.text = "";
          enquiryController.text = "";
        });

        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Feedback submitted successfully ✅"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(decoded["message"] ?? "Something went wrong"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Network error, please try again"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isSubmitting = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    enquiryController.dispose();
    super.dispose();
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Feedback") ,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Name"),
            _input(
              controller: nameController,
              hint: "Enter your name",
              keyboardType: TextInputType.name,
            ),

            const SizedBox(height: 16),

            _label("Mobile Number"),
            _input(
              controller: mobileController,
              hint: "Enter mobile number",
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),

            const SizedBox(height: 16),

            _label("Feedback"),
            _input(
              controller: enquiryController,
              hint: "Write your feedback here...",
              maxLines: 5,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isSubmitting ? null : submitFeedback,
                child:
                    isSubmitting
                        ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                        : const Text(
                          "Submit",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // REUSABLE UI WIDGETS
  // ===============================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
