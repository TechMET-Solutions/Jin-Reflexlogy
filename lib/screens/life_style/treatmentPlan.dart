import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:page_flip/page_flip.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool showFlipBook = false; // To toggle flip book visibility

  // सर्व PDF pages ची images list
  final List<String> pdfImages = [
    'assets/images/diagnosis1.png',
    'assets/images/diagnosis2.png',
    'assets/images/diagnosis3.png',
    'assets/images/diagnosis4.png',
    'assets/images/diagnosis5.png',
    'assets/images/diagnosis6.png',
    'assets/images/diagnosis7.png',
    'assets/images/diagnosis8.png',
    'assets/images/diagnosis9.png',
    'assets/images/diagnosis10.png',
    'assets/images/diagnosis11.png',
    'assets/images/diagnosis12.png',
  ];

  Future<void> submitTreatmentEnquiry() async {
    if (firstNameCtrl.text.isEmpty ||
        lastNameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        detailsCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isSubmitting = true);
    try {
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit enquiry")),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: CommonAppBar(title: "Treatment Plan"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between normal view and flip book
            if (!showFlipBook) _buildNormalView(),
            if (showFlipBook) _buildFlipBookView(),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
     youtubeCard(
  "https://www.youtube.com/watch?v=950Y5K_xPcg",
  "JIN Reflexology Therapy",
),

const SizedBox(height: 20),

youtubeCard(
  "https://www.youtube.com/watch?v=TmD0Eapbzzg",
  "Foot Pressure Points",
),

const SizedBox(height: 20),

youtubeCard(
  "https://www.youtube.com/watch?v=fA8uEVODBVA",
  "Body Healing Method",
),


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
            child: isSubmitting
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
        const SizedBox(height: 15),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 0),
        //   child: Row(
        //     children: [
        //       Expanded(child: Image.asset('assets/images/treatement7.png')),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 20),

        /// View PDF/Flip Book Button
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 0),
    //       child: SizedBox(
    //         width: double.infinity,
    //         height: 50,
    //         child: ElevatedButton.icon(
    //           onPressed: () {
    //             setState(() {
    //               //showFlipBook = true;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const PdfBookScreen(
         
    //     ),
    //   ),
    // );

                  
    //             });
    //           },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.blue,
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8),
    //             ),
    //           ),
    //           icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
    //           label: const Text(
    //             "View Diagnosis Details (Flip Book)",
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
SizedBox(
  height: 500,
  child: PdfBookScreen()),
        const SizedBox(height: 60),
      ],
    );
  }

Widget youtubeCard(String url, String title) {

  final thumbUrl = getYoutubeThumbnail(url);

  return GestureDetector(
    onTap: () async {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    },

    child: Container(
      height: 180,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          )
        ],
      ),

      child: Column(
        children: [

          // ✅ Thumbnail Image
          Expanded(
            child: Stack(
              alignment: Alignment.center,

              children: [

                Image.network(
                  thumbUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: Colors.black12,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                      ),
                    );
                  },
                ),

                const Icon(
                  Icons.play_circle_fill,
                  size: 60,
                  color: Colors.red,
                ),
              ],
            ),
          ),

          // Title
          Container(
            height: 40,
            alignment: Alignment.center,
            color: const Color(0xfff7eed6),

            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildFlipBookView() {
    return Column(
      children: [
        // Back Button
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 30),
                onPressed: () {
                  setState(() {
                    showFlipBook = false;
                  });
                },
              ),
              const SizedBox(width: 10),
              const Text(
                "Diagnosis Details PDF",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              // Page Counter
           
            ],
          ),
        ),

        // Flip Book
        SizedBox(
          height: 600,
          width: double.infinity,
          child: PageFlipWidget(
            backgroundColor: Colors.black,
            key: const Key('pdf_flip_book'),
            lastPage: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 80, color: Colors.green),
                    const SizedBox(height: 20),
                    const Text(
                      "End of Document",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "JIN Reflexology - Perfect Diagnosis",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showFlipBook = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: const Text(
                        "Back to Form",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            children: pdfImages.map((imagePath) {
              return Container(
                color: Colors.white,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            const SizedBox(height: 10),
                            const Text(
                              "Image not found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        // Page Indicator
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.grey[100],
          child: Column(
            children: [
              const Text(
                "Swipe left/right to flip pages",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, color: Colors.grey),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${pdfImages.length} Pages",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.arrow_forward, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
      ],
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
            decoration: const InputDecoration(
              isDense: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black45),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
String getYoutubeThumbnail(String url) {
  try {
    final uri = Uri.parse(url);
    String? videoId;

    if (uri.host.contains("youtu.be")) {
      if (uri.pathSegments.isNotEmpty) {
        videoId = uri.pathSegments.first;
      }
    } 
    else if (uri.host.contains("youtube.com")) {
      videoId = uri.queryParameters['v'];
    }

    if (videoId == null || videoId.isEmpty) return "";

    return "https://img.youtube.com/vi/$videoId/0.jpg";
  } catch (e) {
    return "";
  }
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
            child: const Text(
              "JIN Reflexology Feedback",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
        child: Image.asset(
          img,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }
}






class PdfBookScreen extends StatelessWidget {
  const PdfBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SfPdfViewer.asset(
        'assets/Diagnosisdetails12Page.pdf',
        pageLayoutMode: PdfPageLayoutMode.single,
        scrollDirection: PdfScrollDirection.horizontal, // 📖 BOOK SLIDE
        enableDoubleTapZooming: true,
      );
  }
}
