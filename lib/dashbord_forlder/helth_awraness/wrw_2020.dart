import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/health_campaign_pdf_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Wrw2020Screen extends StatelessWidget {
  const Wrw2020Screen({super.key});

  static const String _conferenceImageUrl =
      "https://jinreflexology.in/wp-content/uploads/2024/10/IRJA-Jain-Conference.jpg";

  static const List<String> _youtubeUrls = [
    "https://www.youtube.com/watch?v=FEaAQsHvbOY",
    "https://www.youtube.com/watch?v=hwWY5sS6LRs",
    "https://www.youtube.com/watch?v=nBX5Rn0bAic&t=1s",
    "https://www.youtube.com/watch?v=THWDNplvlb8",
    "https://www.youtube.com/watch?v=a64ytxY7v_E",
    "https://www.youtube.com/watch?v=DhsnuE7ZAS8",
    "https://www.youtube.com/watch?v=x-0nZ3Nlhw0",
    "https://www.youtube.com/watch?v=j_NTZbxGHyY",
    "https://www.youtube.com/watch?v=j_NTZbxGHyY",
    "https://www.youtube.com/watch?v=Vea9oZd0vjI",
    "https://www.youtube.com/watch?v=aT43C7dCGWo",
    "https://www.youtube.com/watch?v=w9EcQ7yHLJs",
    "https://www.youtube.com/watch?v=aBEosDKToW4",
    "https://www.youtube.com/watch?v=Qj2A-yahPuc",
    "https://www.youtube.com/watch?v=XTWrGo-Vn_E",
    "https://www.youtube.com/watch?v=8Dk-aNdi7YY",
    "https://www.youtube.com/watch?v=1cmtyffjuAs",
    "https://www.youtube.com/watch?v=MiXxrjxtR08",
    "https://www.youtube.com/watch?v=VSN4iPLTiMU",
    "https://www.youtube.com/watch?v=dagajD_XqU0",
    "https://www.youtube.com/watch?v=gceYwxYrc14",
    "https://www.youtube.com/watch?v=Vo1VWDDw4B8",
    "https://www.youtube.com/watch?v=gIcwE6MOF7g",
    "https://www.youtube.com/watch?v=JYDejjO8m8k&t=4s",
    "https://www.youtube.com/watch?v=PREUwuzI6ug",
    "https://www.youtube.com/watch?v=EVsRmeIsaSI",
    "https://www.youtube.com/watch?v=EYJCA8wDr8I",
    "https://www.youtube.com/watch?v=EYJCA8wDr8I",
    "https://www.youtube.com/watch?v=n8K1em0oW2c",
    "https://www.youtube.com/watch?v=jD-DrV-ReKE",
    "https://www.youtube.com/watch?v=vCOdo3TUbzY",
    "https://www.youtube.com/watch?v=WimcT34Dtkg",
    "https://www.youtube.com/watch?v=qRzjDn6tQ2s",
    "https://www.youtube.com/watch?v=sG5KZ5nFeB0",
    "https://www.youtube.com/watch?v=LCbceYnFeB0",
    "https://www.youtube.com/watch?v=pq9N0Kg9ZKs",
    "https://www.youtube.com/watch?v=x8eWfes7A7M",
    "https://www.youtube.com/watch?v=4As9nhRb3Nw",
    "https://www.youtube.com/watch?v=pq_E05oT-aY",
    "https://www.youtube.com/watch?v=ZB76xY0gW9Q",
  ];

  static String? _extractYoutubeId(String url) {
    try {
      final uri = Uri.parse(url);

      if (uri.host.contains("youtu.be")) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }

      if (uri.host.contains("youtube.com")) {
        if (uri.queryParameters.containsKey("v")) {
          return uri.queryParameters["v"];
        }
        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == "shorts") {
          return uri.pathSegments.length >= 2 ? uri.pathSegments[1] : null;
        }
        if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == "live") {
          return uri.pathSegments.length >= 2 ? uri.pathSegments[1] : null;
        }
      }
    } catch (_) {
      // ignore
    }
    return null;
  }

  static List<String> _dedupeYoutubeUrls(List<String> urls) {
    final seen = <String>{};
    final out = <String>[];
    for (final url in urls) {
      final id = _extractYoutubeId(url);
      if (id == null || id.isEmpty) continue;
      if (seen.add(id)) out.add(url);
    }
    return out;
  }

  static String _youtubeThumbnailUrl(String url) {
    final id = _extractYoutubeId(url);
    if (id == null || id.isEmpty) return "";
    return "https://img.youtube.com/vi/$id/hqdefault.jpg";
  }

  Future<void> _openExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Widget sectionTitle(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFFFF6B0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget buildRow(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFFF9F9F9),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(value),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final youtubeUrls = _dedupeYoutubeUrls(_youtubeUrls);

    return Scaffold(
      appBar: CommonAppBar(title: "WRW - 2020"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () => _openExternal(_conferenceImageUrl),
                borderRadius: BorderRadius.circular(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _conferenceImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Text("Image failed to load"),
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

             const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "YouTube Videos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "(${youtubeUrls.length})",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: youtubeUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 15,
                  childAspectRatio: 18 / 15,
                ),
                itemBuilder: (context, index) {
                  final url = youtubeUrls[index];
                  return InkWell(
                    onTap: () => _openExternal(url),
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: const Color(0xfffff3d6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xfff1cd8f)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(
                                    _youtubeThumbnailUrl(url),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 34,
                                          ),
                                        ),
                                  ),
                                ),
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.45),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                            child: Text(
                              "Video ${index + 1}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
              const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF6A3EB5),
              child: const Text(
                "World Reflexology Week - 21st September to 27th September , 2020",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildRow("Convenor", "JR Anil Jain"),
            buildRow(
              "Advisory Member",
              "Dr. Cyril Antony, Dr. Arve Fahlvik, Prof. P.B. Lohiya, Dr. Sarvdeo Prasad Gupta, Dr. Eduardo Louis",
            ),
            sectionTitle(
              "WRW Inaugural Function - World Reflexology Week Nationwide Free Treatment Mega Event -",
            ),
            buildRow("Date", "21st September 2020"),
            buildRow(
              "Guest",
              "Hon. Rajendra Babuji Darda (Editor in Chief - Lokmat)",
            ),
            buildRow("City", "Aurangabad, Online"),
            buildRow("Organizer", "International Reflexology JIN Association"),
            sectionTitle(
              "WRW Concluding Function - National Conference and Award Presentation Ceremony - 2020",
            ),
            buildRow("Date", "27th September 2020"),
            buildRow(
              "Guest",
              "Dr. Cyril Antony, Dr. Arve Fahlvik, Prof. P.B. Lohiya",
            ),
            buildRow("City", "Aurangabad, Maharashtra, India"),
            buildRow("Organizer", "International Reflexology JIN Association"),
            buildRow("Supported", "JIN Reflexology, Jain Chumbak"),
            buildRow("Media Partner", "Lokmat (Maharashtra's No. Newspaper)"),
            const SizedBox(height: 20),
            const Text(
              "2020 Glimpses PDF",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 560,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const CampaignPdfViewer(year: 2020),
              ),
            ),
            const SizedBox(height: 20),
          
           
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
