import 'package:flutter/material.dart';
import 'package:jin_reflex_new/marking_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Function to launch YouTube video
  Future<void> _launchYouTubeVideo() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=vpCIft15u2Y');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Helper function to extract YouTube thumbnail URL
  String getYoutubeThumbnail(String youtubeLink) {
    // Extract video ID from YouTube URL
    final videoId = _extractVideoId(youtubeLink);
    if (videoId.isNotEmpty) {
      // Return high quality thumbnail URL
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    // Return a default thumbnail if video ID not found
    return 'https://img.youtube.com/vi/vpCIft15u2Y/hqdefault.jpg';
  }

  String _extractVideoId(String url) {
    try {
      // Extract video ID from various YouTube URL formats
      final uri = Uri.parse(url);
      if (uri.host.contains('youtube.com')) {
        final videoId = uri.queryParameters['v'];
        return videoId ?? 'vpCIft15u2Y';
      } else if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty
            ? uri.pathSegments.first
            : 'vpCIft15u2Y';
      }
    } catch (e) {
      print('Error extracting video ID: $e');
    }
    return 'vpCIft15u2Y';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: CommonAppBar(title: "About Us"),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 10 : 16),
              child: Column(
                children: [
                  Container(
                    height: isMobile ? 90 : (isTablet ? 120 : 150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/about_bannar.png"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _videoSectionWithThumbnail(
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                  const SizedBox(height: 12),

                  // Director's Message
                  _directorsMessage(),

                  _sectionTile("Our Mission", ["Your Health is Our Priority"]),
                  _sectionTile("Our Vision", [
                    "Healthy Life without Medicine - 100%",
                  ]),

                  _sectionTile("Our Management Team", []),
                    _teamCard(
                      image: "assets/images/suganchand_Jain.png",
                  
                    name: "Suganchand Jain",
                    role: "Director",
                    desc: "",
                  ),
                  _teamCard(
                     image: "assets/images/manoj_kumar_jain.png",
                    name: "Manoj Kumar Jain",
                    role: "Director",
                    desc: "",
                  ),
                  _teamCard(
                    image: "assets/images/anil_jain.png",
                    name: "JR Anil Suganchand Jain",
                    role: "Inventor of JIN Reflexology",
                    desc:
                        "President- International Reflexology JIN Association",
                  ),
                

                  _teamCard(
                    image: "assets/images/harshit.jpeg",
                    name: "JR Harshit Jain",
                    role: "Director",
                    desc: "",
                  ),

                  // Research Section
                  _researchSection(),

                  // National & International Conferences
                  _conferencesSection(),

                  // JIN Day Events
                  _jinDayEvents(),

                  _sectionTile("Manufacturer", [
                    "Manufacturing world-class 4G Super Magnet, 4G Low Power and 4G Spectacles Magnet JIN Reflexology Therapy related tools.",
                  ]),

                  _sectionTile("Exporter", [
                    "We also exports JIN Reflexology Book, 4G Series Magnet, All type of acupressure reflexology related equipment.",
                  ]),

                  _sectionTile("Publisher", [
                    "Published Foot and Hand JIN Reflexology Chart – an easy way for locating points and treatment of various ailments.",
                    "Published award winning book – Bhartiya Jivan Padhati – Acupressure (Hindi) (Released by Honorable Rajendraji Darda, Education Minister, Maharashtra).",
                    "Released book – Indian Life Style – Acupressure (English) (Released by Honorable Ghulam Nabi Azad, Union Health and Family Planning Minister) Honorable Vijay Darda (MP).",
                    "Published book – JIN Reflexology – (With DVD) (Released by Honorable Prithaviraj Chavhan, Chief Minister, Maharashtra, Hon'ble Rajendra Darda (Education Minister), Hon'ble Balasaheb Thorat (Palak Mantri), Mr. Kalyan Bale (MLA).",
                    "Published JIN Reflexology Book with 118 QR Code Video Link.",
                    "Publish JIN Reflexology E-Book Hindi and English Version.",
                  ]),

                  // Video Section with dynamic thumbnail
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // VIDEO SECTION WITH DYNAMIC THUMBNAIL
  // ------------------------------
  Widget _videoSectionWithThumbnail({
    required bool isMobile,
    required bool isTablet,
  }) {
    final youtubeLink = 'https://www.youtube.com/watch?v=vpCIft15u2Y';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Director's Message - Occasion of Web Launching Program",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _launchYouTubeVideo,
            child: Stack(
              children: [
                // YouTube Thumbnail Image
                _buildThumbnailImage(
                  youtubeLink,
                  isTablet ? 220 : (isMobile ? 180 : 240),
                ),

                // Play Button Overlay
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // GestureDetector(
          //   onTap: _launchYouTubeVideo,
          //   child: const Text(
          //     "https://www.youtube.com/watch?v=vpCIft15u2Y",
          //     style: TextStyle(
          //       fontSize: 12,
          //       color: Colors.blue,
          //       decoration: TextDecoration.underline,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          // const SizedBox(height: 4),
          // const Text(
          //   "Tap to watch video",
          //   style: TextStyle(
          //     fontSize: 11,
          //     color: Colors.grey,
          //     fontStyle: FontStyle.italic,
          //   ),
          // ),
        ],
      ),
    );
  }

  // ------------------------------
  // THUMBNAIL IMAGE WIDGET
  // ------------------------------
  Widget _buildThumbnailImage(String youtubeLink, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          getYoutubeThumbnail(youtubeLink),
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                height: height,
                width: double.infinity,
                color: Colors.grey[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Image not available",
                      style: TextStyle(
                        fontSize: height >= 200 ? 14 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: height,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------
  // DIRECTOR'S MESSAGE
  // ------------------------------
  Widget _directorsMessage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade300, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Director's Message",
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Occasion of Web Launching Program",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Welcome to JIN Reflexology. We are committed to providing natural healing solutions through our research and innovative therapies.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // RESEARCH SECTION
  // ------------------------------
  Widget _researchSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Research – JIN Point Technology",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "J – Justify   I – Integrated   N – Natural",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          ...[
                "After doing research work on 13000 people, on the most ancient Therapy, it was presented as JIN Reflexology Therapy. There are more than 200 Therapies in the world for treatment, but the disease cannot be diagnosed accurately. After Ayurveda, the only therapy in the world for diagnosing the disease is JIN Reflexology, in which not a single question is asked to the patient, and he is told what problem he is suffering from.",
                "Creation of world class software in which complete information of the patient is stored for research work and to get quick results.",
                "India's biggest health awareness campaign successfully completed.",
              ]
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // ------------------------------
  // CONFERENCES SECTION
  // ------------------------------
  Widget _conferencesSection() {
    final conferences = [
      "1st National Conference and Award presentation Ceremony – 2015 at Chhatrapati Sambhaji Nagar, Maharashtra, India",
      "2nd National Conference and Award presentation Ceremony – 2016 at Mumbai, Maharashtra, India",
      "3rd National Conference and Award presentation Ceremony – 2017 at Mumbai, Maharashtra, India",
      "4th National Conference and Award presentation Ceremony – 2018 at Surat, Gujarat, India",
      "5th National Conference and Award presentation Ceremony – 2019 at Bengaluru, Karnataka, India",
      "1st International and 6th National Conference Online – 2020",
      "2nd International and 7th National Conference Online – 2021",
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade300, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "National & International Conferences",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...conferences
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // ------------------------------
  // JIN DAY EVENTS
  // ------------------------------
  Widget _jinDayEvents() {
    final events = [
      "JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2020: 21 Days Free Online Power Yoga",
      "JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2021: Free 21 Days Free Online Power Yoga",
      "JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2022: 21 Days, 19 Cities in Maharashtra, 25 Health Awareness and Life Changing Seminars",
      "JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2023: 21 Days, 19 Cities (4 States – Madhya Pradesh, Maharashtra, Gujarat, Rajasthan), 21 Health Awareness and Life Changing Seminars",
      "JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2024: 21 Days, 21 Cities (4 States – Madhya Pradesh, Maharashtra, Karnataka, Telangana Rajasthan), 21 Health Awareness and Life Changing Seminars",
      "JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2025: 31 Days, 21 Cities (7 States – Delhi, Madhya Pradesh, Maharashtra, Karnataka, Telangana Rajasthan, Tamil Nadu), 21 Health Awareness and Life Changing Seminars",
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "JIN Day Health Awareness Campaigns",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...events
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  // ------------------------------
  // SECTION TILE
  // ------------------------------
  Widget _sectionTile(String title, List<String> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // TEAM CARD
  // ------------------------------
  Widget _teamCard({
    required String image,
    required String name,
    required String role,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade400, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;

          if (isNarrow) {
            return Column(
              children: [
                CircleAvatar(radius: 38, backgroundImage: AssetImage(image)),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ],
            );
          }

          return Row(
            children: [
              CircleAvatar(radius: 34, backgroundImage: AssetImage(image)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (desc.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(desc, style: const TextStyle(fontSize: 13)),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
