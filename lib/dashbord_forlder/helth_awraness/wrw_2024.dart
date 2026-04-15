import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Wrw2024Screen extends StatefulWidget {
  const Wrw2024Screen({super.key});

  @override
  State<Wrw2024Screen> createState() => _Wrw2024ScreenState();
}

class _Wrw2024ScreenState extends State<Wrw2024Screen> {
  bool _expandedSeminars = false;
  bool _expandedLifestyle = false;

  static const String _jalnaFeedbackUrl =
      "https://www.youtube.com/watch?v=-Uz53g4Dvzs";
  static const String _video950Url =
      "https://www.youtube.com/watch?v=950Y5K_xPcg";

  Widget _expandableHeader({
    required bool expanded,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              expanded ? Icons.remove : Icons.add,
              size: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String? _extractYoutubeId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains("youtu.be")) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }
      if (uri.host.contains("youtube.com")) {
        if (uri.queryParameters.containsKey("v")) return uri.queryParameters["v"];
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

  static String _youtubeThumbnailUrl(String url) {
    final id = _extractYoutubeId(url);
    if (id == null || id.isEmpty) return "";
    return "https://img.youtube.com/vi/$id/hqdefault.jpg";
  }

  static Widget _youtubeThumbCard({
    required String title,
    required String url,
  }) {
    return InkWell(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri == null) return;
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                            child: const Icon(Icons.broken_image, size: 34),
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
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seminarsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          "(From L) Sonal Jain, Sangeeta Kotecha, Priya Mutha, Dimple Pagariya, Rajendra Darda, JR Anil Jain, Suganchand Jain and Paras Ostwal release the JIN Reflexology book at the concluding program at Chhatrapati Sambhajinagar on Saturday.",
          style: TextStyle(fontSize: 12, height: 1.5),
        ),
        SizedBox(height: 14),
        Center(
          child: Text(
            "Health awareness seminars in 20 cities across 4 states",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            "These seminars aim to prevent serious future diseases",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 14),
        Text(
          "LOKMAT NEWS NETWORK CHHATRAPATI SAMBHAJINAGAR – The International Reflexology JIN Association, known for organizing various health awareness program from JIN Reflexology Day to International Yoga Day, concluded its latest initiative with great success. The association conducted 20 health awareness seminars in 20 cities across four states from June 1 to June 21. The concluding event was graced by Chief Guest Editor-in-Chief of the Lokmat Group Rajendra Darda in the city on Sunday.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "The programme, led by the JITO Ladies Wing, was inaugurated with an assertion on the importance of health by the Wing President.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "JR Anil Jain, Inventer of JIN Reflexology, was the keynote speaker. He highlighted the characteristics of JIN Reflexology, a globally popular medical system that diagnoses diseases without asking any questions from the patient. This system, with over 200 healing styles, is second only to Ayurveda.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "During the JIN Reflexology book release, Rajendra Darda released the fourth edition of the book on JIN Reflexology. This book is more than a resource; it's a living guide. Each lesson includes a QR code that provides detailed and practical information through videos. Covering topics like nutrition, physiology, and micromagnets, this book is designed to help every person lead a healthy life.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "Health awareness seminars are crucial, given that 61 percent of annual deaths in India are due to non-communicable diseases. Public awareness efforts are minimal, despite research indicating that most diseases, such as heart attacks, kidney failure, panic spondylitis and Parkinson's disease, are linked to disordered lifestyles. These seminars aim to prevent serious future diseases and bring smiles to people's faces.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "The International Reflexology JIN Association celebrates June 1 as JIN Reflexology Day annually. Over the past three years, 101 seminars have been organized, covering topics like JIN Reflexology, healthy lifestyles and life-changing factors through computerized presentations. Thousands of people have benefited from these seminars.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "This campaign, launched three years ago under the guidance of Rajendra Darda, has seen significant contributions from individuals like JR Anil Jain, Dr. Sapna Patani (Dhule) and Mahveer Banthia (Sindhanur). The Jeeto Ladies Wing, led by president Dimple Pagariya and supported by secretary Priya Mutha, Sangeeta Kotecha and Sonal Jain, played a vital role in the success of the closing event.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 14),
        Text(
          "REFLEXOLOGY AND  1st JUNE  HEALTHY & NATURAL LIFE",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        Text(
          "Media Partner – Lokmat, Lokmat Samachar, LOKMATTIMES",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _lifestyleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          "Change lifestyle to enjoy life JR Anil Jain's appeal",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Nagar- Our lifestyle should be in harmony with nature. In today's hectic life, despite running around a lot, we face stress and depression. To avoid that, we can benefit from a happy life by changing our daily routine a little, asserted JR Anil Jain, Inventor of JIN Reflexology (Aurangabad).",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "He was speaking at a seminar organized by Mahavir International here at Badisajan Mangal Office. Dr. Sudha Kankaria and Sanjay Gugle were the chief guests on the dais. Rajendra Bothra, Secretary of Mahavir International, welcomed the gathering.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "While giving the introduction, Arun Parakh, President of Mahavir International, said, \"Mahavir International's work has been flourishing in the city since 2000. Mahavir International has made its mark of distinction with various innovative initiatives in the social and educational fields.\"",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "JR Vir Anil Jain speaking at a seminar organized by Mahavir International.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Text(
          "It is intended to implement new initiatives in the future that will be beneficial to the social and educational sectors.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "JR Anil Jain further said, \"Our ancestors used to say that early to bed and early to rise brings good health. It is absolutely true and has a scientific basis. We must wake up before sunrise. Only if we sleep for 6 to 8 hours continuously can we experience the joy of being refreshed. We should take at least 10 to 15 minutes of sleep at any time during the day at our convenience. In today's computer age, we spend hours and hours in air-conditioned rooms.\"",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "It is a situation where the body of highly educated people who sit still does not get any sun. One must walk barefoot on the ground or on the grass for some time every day. Being in the open air allows one to get plenty of oxygen. Light exercises and yoga should be done regularly. There is no need to go to the gym and strain oneself. While relaxing at home, one should watch only humorous and funny series. Watching series with fights and tension creates unnecessary mental stress and adversely affects our lifestyle. Our life is precious.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "Moments do not come back. Always be happy, smiling, and cheerful. Be careful that no one is unhappy with your behavior. Give happiness to others without causing trouble. This life is not repeated. While you are happy, you should think about how others will also be happy. Positive thinking changes your lifestyle and doubles the joy of living, said Dr. Jain.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "Dr. Sudha Kankaria spoke about the importance of eye donation. Sanjay Gugle said, Dr. Jain has told us through various examples how important it is to change our lifestyle for good health. If we try to change accordingly, we can enjoy life.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 10),
        Text(
          "Ramesh Bafna, Babusheth Lodha, Dr. Suresh Surana, Gautam Barmecha, Dilip Karnawat, Gautam Parakh, Manakchand Kataria, Narendra Bafna, Varsha Bafna, Manisha Gugle, Vaishali Shetia etc. worked hard to make the program a success. Manoj Shetia moderated the program. Dhanraj Sancheti proposed the vote of thanks.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, height: 1.6),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Health Awareness – 2024"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _expandableHeader(
                  expanded: _expandedSeminars,
                  title: "Health Awareness Seminars in 20 cities across 4 states",
                  onTap: () =>
                      setState(() => _expandedSeminars = !_expandedSeminars),
                ),
                if (_expandedSeminars) _seminarsSection(),
                const SizedBox(height: 20),
                _expandableHeader(
                  expanded: _expandedLifestyle,
                  title: "Change lifestyle to enjoy life - JR Anil Jain's appeal",
                  onTap: () =>
                      setState(() => _expandedLifestyle = !_expandedLifestyle),
                ),
                if (_expandedLifestyle) _lifestyleSection(),
                const SizedBox(height: 24),
                const Text(
                  "Feedback about Health Awareness Seminar, Jalna",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _youtubeThumbCard(
                  title: "Feedback Video (Jalna)",
                  url: _jalnaFeedbackUrl,
                ),
                const SizedBox(height: 12),
                _youtubeThumbCard(
                  title: "Seminar Video",
                  url: _video950Url,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

