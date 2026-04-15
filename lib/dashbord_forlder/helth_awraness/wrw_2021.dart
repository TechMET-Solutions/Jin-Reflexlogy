import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/health_campaign_pdf_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Wrw2021Screen extends StatefulWidget {
  const Wrw2021Screen({super.key});

  @override
  State<Wrw2021Screen> createState() => _Wrw2021ScreenState();
}

class _Wrw2021ScreenState extends State<Wrw2021Screen> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;

  static const String _heroImageUrl =
      "https://jinreflexology.in/wp-content/uploads/2022/02/14-1-jpg.webp";

  static const List<String> _gridImageUrls = [
    "https://jinreflexology.in/wp-content/uploads/2022/02/15-jpg.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/16-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/17-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/18-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/19-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/20-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/21-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/25-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/23-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/24-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/25-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/26-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/27-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/28-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/29-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/30-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/31-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/32-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/33-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/34-jpg-500x269.webp",
    "https://jinreflexology.in/wp-content/uploads/2022/02/35-jpg-500x269.webp",
  ];

  static const String _internationalConferenceUrl =
      "https://www.youtube.com/watch?v=cgAYRcfsqBM";
  static const String _nationalConferenceUrl =
      "https://www.youtube.com/watch?v=D1VART5jbkQ";
  static const String _infoSlideUrl =
      "https://www.youtube.com/watch?v=FNZ5QOLZ3cY";

  static const List<String> _youtubeUrls = [
    _infoSlideUrl,
    "https://www.youtube.com/watch?v=yvJeXJPI_aU",
    "https://www.youtube.com/watch?v=p0RuqtItUBg",
    "https://www.youtube.com/watch?v=9hTg7GE4eWs",
    "https://www.youtube.com/watch?v=YO_vKV5PNmA",
    "https://www.youtube.com/watch?v=B2xA9iE7xbg",
    "https://www.youtube.com/watch?v=KzaFQVR8scA",
    "https://www.youtube.com/watch?v=LLU1MqaS438",
    "https://www.youtube.com/watch?v=ZuvbtOoSbJk",
    "https://www.youtube.com/watch?v=2Ups6hCC4vo",
    "https://www.youtube.com/watch?v=mtzpWq_uGr0",
    "https://www.youtube.com/watch?v=554T1u8Uv4k",
    "https://www.youtube.com/watch?v=d819b1wdgjk",
    "https://www.youtube.com/watch?v=8P_SGGpqGv0",
    "https://www.youtube.com/watch?v=pdUXDgQ-e2c",
    "https://www.youtube.com/watch?v=6E74vsJnsV4",
    "https://www.youtube.com/watch?v=zWsMFBIxKd0",
    "https://www.youtube.com/watch?v=MgCeiUQ6tM4",
    "https://www.youtube.com/watch?v=x9LZteVuysA",
    "https://www.youtube.com/watch?v=v6MTrH1BSZw",
    "https://www.youtube.com/watch?v=v6MTrH1BSZw",
    "https://www.youtube.com/watch?v=ZB76xY0gW9Q",
    _internationalConferenceUrl,
    _nationalConferenceUrl,
  ];

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

  static List<String> _dedupeByKey(
    List<String> items,
    String Function(String) keyOf,
  ) {
    final seen = <String>{};
    final out = <String>[];
    for (final item in items) {
      final key = keyOf(item);
      if (key.isEmpty) continue;
      if (seen.add(key)) out.add(item);
    }
    return out;
  }

  Future<void> _openExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Health Awareness – 2021"),
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
        
                /// 🔹 Expandable Article Title
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded1 = !isExpanded1;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          isExpanded1 ? Icons.remove : Icons.add,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "21 Days Yoga Camp Begins Today",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                /// 🔹 Expanded Content
                if (isExpanded1) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "You will benefit from guidance, lectures, and discussion sessions. Aurangabad,",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
        
                  const SizedBox(height: 12),
        
                  Text("May 31. Lokmat Samachar Seva",style: TextStyle(fontSize: 16,height: 1.6),),
        
                  const SizedBox(height: 12),
                  const Text(
                    "As in previous years, a 21-day free yoga camp is set to begin tomorrow, "
                    "June 1st, in an effort to boost broken morale and improve health. "
                    "In this camp, guidance lectures and discussion sessions will provide information on yoga.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "The camp was organised under the joint aegis of International Reflexology Jain Association, "
                    "Aurangabad District Automobile and Tyre Dealers Association and Mahavir "
                    "International Metro City from 1st June Jain Reflexology Day to 21st June.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  Text("Kidney patient gets new life in 30 days", textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.6)),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "I, Deependra Singh, am from House No. 240, Street No. 37, PT-II, "
                    "Kaushik Enclave, Burari, North Delhi-110084. Despite numerous kidney treatments,  "
                    "there was no improvement. However, after listening to Dr. Dassan on YouTube,"
                    "I started treatment and my kidneys recovered within just one month.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  Text("Will continue till International Yoga Day.", textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.6)),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "The camp was inaugurated online on Monday at 3 p.m. The camp "
                    "was launched in the august presence of Rajendra Darda, President of the Sakal Jain Samaj, "
                    "Shanti Kumar Jain, International President of Mahavir International, Anil Jain, International General "
                    "Secretary, and Mansingh Pawar, former President of the Maharashtra Chamber of Commerce. Speaking at "
                    "the inauguration, Sakal Jain Samaj President Darda said that physical and mental well-being is essential. ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "Rajkumar Banthia- people Program President Rajendra Darda, JR Anil Jain Jain, "
                    "Inventor of JIN Reflexology, etc. in the inauguration program of Yoga Camp organized "
                    "by International Reflexology Jain Association in Aurangabad on Monday.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  Text("outline of camp organization", textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.6)),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "During the Yoga Festival, there will be practical yoga sessions every day from 7:00 AM to 7:40 PM. "
                    "Yoga expert Manju Thole, director of Fit Way, will guide the participants. "
                    "Five relevant questions will be asked each day. The top three winners will be honored. "
                    "From 7:40 PM to 8:00 PM, experts on various subjects will conduct online discussions. "
                    " The sessions will be broadcast live on YouTube and Facebook.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "This is a good thing for those in distress. Shantilal Jain, International President of Mahavir International, "
                    "said that it is best to make yoga a part of your lifestyle. He added that he "
                    " himself is a yoga and They do Pranayam, which keeps their mental and physical fatigue away. "
                    "India’s biggest health awareness campaign convener JR Anil Jain, Inventor of JIN Reflexology, "
                    " said that this multipurpose program is being organized for the second consecutive "
                    "year in the circumstances of Corona epidemic. He said that those who complete the 21-day camp in the "
                    "event will be rewarded by Lokmat Group and Ratnaprabha Motors. Coordinator Jain, "
                    "co-ordinator Rajkumar Jain, President of Aurangabad District Automobile and Tyre Dealer Association "
                    "Santosh Kawale, President of Mahavir International Metro City Naresh Bothra "
                    "appealed to take maximum benefit of the program.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
        
                const SizedBox(height: 20),
        
                /// 🔹 Second Title
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded2 = !isExpanded2;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          isExpanded2 ? Icons.remove : Icons.add,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "India's Biggest Health Awareness Campaign Free Online Yoga & Interaction Camp",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E75B6), // Blue like screenshot
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                if (isExpanded2) ...[
                  const SizedBox(height: 16),
        
                  const Center(
                    child: Text(
                      "1st June (JIN Reflexology Day) to 21st June (International Yoga Day)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Organized by – International Reflexology JIN Association, Aurangabad District Automobiles "
                    "Tire Dealers Association, Mahavir International Metro City, Aurangabad, Fit Way."
                    "The 21-day free online yoga camp organized by the International Reflexology JIN Association concluded today.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Lokmat Editor-in-Chief Rajendra Darda felicitates the organizers of a free yoga camp at Lokmat Bhavan "
                        "in Aurangabad on Monday. Present on the occasion are, from left, Santosh Kawale, "
                    "Manju Thole, Yatin Thole, convener – JR Anil Jain, Inventor of JIN Reflexology, Rajkumar Banthia, and Naresh Bothra.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The camp, held on June 1st, JIN Reflexology Day, was supported by the Aurangabad District "
                        "Automobile and Tire Dealers Association and Mahavir International Metro City. ",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Rajendra Darda, Editor-in-Chief of Lokmat, presented the ceremony. He honored Manju Thole, "
                        "Yoga instructor and director of Fit Way, and Yatin Thole, Editor, with a shawl. "
                        "Mega event convener and International Reflexology Jain Association president JR Anil Jain was honored with a book."
                    "Co-ordinator Rajkumar Jain Banthia, President of the Aurangabad District Automobile and Tire Dealer Association"
                    "Santosh Kawale, and Mahavir International Metro presented the ceremony.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Representatives of the three organizations jointly honored Rajendra Darda on this occasion. "
                        "The program was broadcast live on YouTube and Facebook. During this yoga festival, "
                        "practical yoga sessions were held daily from 7:00 AM to 7:40 PM. Fit Way director and "
                        "yoga expert Manju Thole provided daily guidance. Similarly, experts on various subjects "
                        "held sessions from 7:40 AM to 8:00 PM.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
        
                  const SizedBox(height: 20),
        
                ],
        
                const SizedBox(height: 12),
        
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded3 = !isExpanded3;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          isExpanded3 ? Icons.remove : Icons.add,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "National and International Online Gathering Organized for International Reflexology Week Conclude",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E75B6), // Blue like screenshot
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                if (isExpanded3) ...[
                  const SizedBox(height: 16),
        
                  Text(
                    "World Reflexology Week 20th to 26th September 2021 Reflexology For Everybody International Reflexology Jain Association",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "JR Shilpa Jain conducting the programme, on the stage from left are Prof. Praveen Vakte, "
                        "JR Anil Jain, Inventor of JIN Reflexology, Prof. Purushottam Lohia, Dr. Md. "
                        "Furkan Amer, in the second picture are JR Sapna Gandhi, JR Anuprita Gandhi, Priyanka Badjate, JR Monica Kathed offering prayers.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Drug-free acupressure, reflexology, sujok, shiatsu, JIN reflexology, reiki, mudra therapy, neuro therapy, etc. "
                        "organized at the conclusion of International Reflexology Week",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The seventh national and second International online meeting of doctors of medical systems was concluded.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "In his introduction, convener JR Anil Jain Inventor of JIN Reflexology stated that working with clinical "
                        "data management could revolutionize the medical field. This year, we also organized "
                        "a continuous online yoga camp and discussion session from JIN Reflexology Day (June 1st) to International "
                        "Yoga Day (June 21st). The session was chaired by Prof. Dr. Praveen Vakte, Pro-Vice Chancellor, "
                        "Dr. Babasaheb Ambedkar Marathwada University, Aurangabad, and Dr. Md. Furqan Amer, Principal, DKMM.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Dr. Praveen, who was present as the chief guest at the Homeopathy Hospital and Medical College, "
                    "said that like developed countries, we too need to work on preventive health.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "This time, on the first day, prominent doctors like Dr. Sarvdev Prasad Gupta, Ajay Prakash Gupta, "
                        "Patna, Dr. Reshma Suryavanshi, Vadodara, Dr. Sudhir Khetawat, Indore, "
                        "Dr. Yogesh Kodakani, Mumbai etc. presented their presentations in the national assembly. On the second day, "
                        "in the international assembly, President of International Council of Reflexologists, Carol Fugi, England gave a congratulatory message and "
                        "appreciated the work of the organization, Prof. Praveen Vakte spoke on Reflexology in the World, "
                    "Prof. Dr. P. B. Lohia on Rest and Ankle Acupuncture, Dr. Cyril Antony, Member of the Board of Governors and Head of the Education "
                    "Committee of the Reflexology Council, on the Role of Reflexology in Covid-19, Dr. Arv Falvik, Norway on The Body as a Hologram, "
                    "Dr. Jyoti Kumbhar, Pune, Medical Officer of National Institute of Naturopathy, Henrik Bergmans, Acupressure, Belgium "
                    "presented on Stress and Trauma Sensitive Reflexology, Murcio Kru Chik, Israel presented on Reflexology for the Treatment of Pain.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The “Mega Event of Free Treatment” campaign was celebrated with great enthusiasm by all physicians "
                        "offering drug-free treatment across the country from September 20th to 26th. "
                    "The organization awarded certificates to all physicians who participated in the campaign.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Doctors who have not received the certificate should send their photo while providing service on the link given below.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The convener and all the office bearers heartily congratulated Shri Rajendra Babuji Darda and all the editors "
                    "for providing important service as Lokmat Media Partner and guide in making "
                    "these side effect free medical methods reach the common people.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Organized by the International Jain Reflexology Association, the entire executive committee, including Convener JR Anil Jain, "
                        "Dr. Antony Cyril, Dr. Lohia, Director Anupama Gandhi, Balasaheb Joshi, and Mrs. Prabha Desarda, played a key role in making "
                        "this gathering a success. The program was successfully hosted by JR Shilpa Jain of Aurangabad. "
                    "broadcast on Facebook, YouTube, and the web page www.jinreflexology.in",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
        
        
                  const SizedBox(height: 20),
        
                ],
        
        
        
                const SizedBox(height: 20),
        
                /// 🔹 Large Image Placeholder
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _imageCard(_heroImageUrl),
                ),
        
                const SizedBox(height: 16),
        
                Center(
                  child: const Text(
                    "Online Interaction and Yoga Camp live on Facebook. Info slide.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
        
                const SizedBox(height: 12),
                _youtubeThumbCard(
                  _infoSlideUrl,
                  title: "Online Interaction and Yoga Camp (Info Slide)",
                ),
        
                const SizedBox(height: 16),
        
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _imageCard(_gridImageUrls.first),
                ),
        
                const SizedBox(height: 16),
        
                /// 🔹 Grid Section
                buildGrid(),
        
                const SizedBox(height: 20),
                const Text(
                  "YouTube Videos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                buildYoutubeGrid(),
        
                const SizedBox(height: 12),
                const Text(
                  "2021 Glimpses PDF",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 560,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const CampaignPdfViewer(year: 2021),
                  ),
                ),
        
                const Text(
                  "World Reflexology Work Event – 2nd International Conference – 2021 – Convener – JR Anil Jain",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        
                const SizedBox(height: 12),
        
                _youtubeThumbCard(
                  _internationalConferenceUrl,
                  title: "2nd International Conference (2021)",
                ),
        
                const SizedBox(height: 12),
        
                const Text(
                  "World Reflexology Work Event – 7th National Conference – 2021 – Convener – JR Anil Jain",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        
                const SizedBox(height: 12),
        
                _youtubeThumbCard(
                  _nationalConferenceUrl,
                  title: "7th National Conference (2021)",
                ),
        
                const SizedBox(height: 12),
        
                const Text(
                  "Glimpses Of Other Health Awareness Campaign – 2021 – Convener – JR Anil Jain",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Simple + Title Row
  Widget buildSimpleTitle(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.add, size: 18, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Grey Placeholder Box
  Widget buildGreyBox({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade400,
    );
  }

  /// 🔹 Grid Builder
  Widget _imageCard(String url, {double borderRadius = 12}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _FullScreenImage(title: "Image", imageUrl: url),
          ),
        );
      },
      borderRadius: BorderRadius.circular(borderRadius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, size: 40),
              ),
        ),
      ),
    );
  }

  Widget _youtubeThumbCard(String url, {required String title}) {
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

  Widget buildGrid() {
    final urls = _dedupeByKey(_gridImageUrls, (u) => u);
    return GridView.builder(
      itemCount: urls.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 16 / 10,
      ),
      itemBuilder: (context, index) => _imageCard(urls[index]),
    );
  }

  Widget buildYoutubeGrid() {
    final urls = _dedupeByKey(_youtubeUrls, (u) => _extractYoutubeId(u) ?? "");
    return GridView.builder(
      itemCount: urls.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 15 / 12,
      ),
      itemBuilder: (context, index) {
        return _youtubeThumbCard(urls[index], title: "Video ${index + 1}");
      },
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: title),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => const Center(child: Text("Image failed to load")),
          ),
        ),
      ),
    );
  }
}
