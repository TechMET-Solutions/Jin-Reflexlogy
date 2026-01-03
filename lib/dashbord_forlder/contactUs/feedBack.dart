import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              _titleText("Video Gallery"),

              _section(
                title: "1. JIN Reflexology Advanced Info (English)",
                url: "https://www.youtube.com/embed/VIDEO_ID_1",
              ),

              _section(
                title:
                    "2. JIN Reflexology Diagnosis - Feedback By JR Varsha Lohade (English)",
                url: "https://www.youtube.com/embed/VIDEO_ID_2",
              ),

              _section(
                title: "3. Magnet Therapy - JR Anil JIN",
                url: "https://www.youtube.com/embed/VIDEO_ID_3",
              ),

              _section(
                title:
                    "4. History and Advantage of JIN Reflexology (Hindi ) - JR Anil JIN",
                url: "https://www.youtube.com/embed/VIDEO_ID_4",
              ),

              _section(
                title:
                    "5. Amazing feature of JIN Reflexology - Perfect Diagnosis",
                url: "https://www.youtube.com/embed/VIDEO_ID_5",
              ),

              _section(
                title: "6. JIN Reflexology Song",
                url: "https://www.youtube.com/embed/VIDEO_ID_6",
                subtitle: "JIN Reflexology Song",
              ),

              _section(
                title:
                    "7. JIN Reflexology workshop at Nashik - Feedback",
                url: "https://www.youtube.com/embed/VIDEO_ID_7",
                subtitle:
                    "JIN Reflexology Acupressure awareness workshop at Nashik",
              ),

              _section(
                title: "8. Training – JIN Reflexology FeedBack",
                url: "https://www.youtube.com/embed/VIDEO_ID_8",
                subtitle:
                    "JIN Reflexology Acupressure Advanced training programme",
              ),

              _section(
                title: "9. Immunity Power – JIN Reflexology FeedBack",
                url: "https://www.youtube.com/embed/VIDEO_ID_9",
                subtitle:
                    "Increased Immunity Power – Through JIN Reflexology Acupressure",
              ),

              _section(
                title: "10. Workshop – JIN Reflexology FeedBack",
                url: "https://www.youtube.com/embed/VIDEO_ID_10",
                subtitle:
                    "JIN Reflexology Acupressure two days workshop in Jabalpur (MP)",
              ),

              _section(
                title: "11. Thyroid – JIN Reflexology FeedBack",
                url: "https://www.youtube.com/embed/VIDEO_ID_11",
                subtitle:
                    "Thyroid cure through JIN Reflexology Acupressure",
              ),

              _section(
                title: "12. Cervical – JIN Reflexology FeedBack",
                url: "https://www.youtube.com/embed/VIDEO_ID_12",
                subtitle:
                    "Cervical spondylitis cure through JIN Reflexology Acupressure",
              ),

              _section(
                title:
                    "13. Prostate Gland – JIN Reflexology Feedback",
                url: "https://www.youtube.com/embed/VIDEO_ID_13",
                subtitle:
                    "Prostate Gland Relief by JIN Reflexology Acupressure",
              ),

              _section(
                title: "14. Stress – JIN Reflexology Feedback",
                url: "https://www.youtube.com/embed/VIDEO_ID_14",
                subtitle:
                    "Stress control by JIN Reflexology Acupressure",
              ),

              _section(
                title: "15. JIN Reflexology Book Releasing",
                url: "https://www.youtube.com/embed/VIDEO_ID_15",
                subtitle:
                    "Hon’ble Rajendra Babuji Darda (Minister for Industry) Releasing the book Indian life Style Acupressure (JIN Reflexology)",
              ),

              _section(
                title:
                    "16. JIN Reflexology Acupressure Content for Beginners",
                url: "https://www.youtube.com/embed/VIDEO_ID_16",
                subtitle:
                    "Reflexology is a holistic treatment based on the principle that there are areas and points on the feet, hands, and ears...",
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widgets

  Widget _titleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String url,
    String? subtitle,
  }) {
    return Column(
      children: [
        const SizedBox(height: 12),
        _staticTitle(title),
        const SizedBox(height: 8),
        _webView(url),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          _staticSubtitle(subtitle),
        ],
      ],
    );
  }

  Widget _staticTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _staticSubtitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    );
  }

  Widget _webView(String url) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(url)),
        ),
      ),
    );
  }
}
