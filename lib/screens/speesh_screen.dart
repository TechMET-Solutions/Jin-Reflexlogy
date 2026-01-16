import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// ===============================
/// MODEL
/// ===============================
class Speech {
  final int id;
  final String? title;
  final String? desc;
  final String youtubeLink;
  final List<String> images;

  Speech({
    required this.id,
    this.title,
    this.desc,
    required this.youtubeLink,
    required this.images,
  });

  factory Speech.fromJson(Map<String, dynamic> json) {
    return Speech(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      youtubeLink: json['youtube_link'] ?? "",
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}

/// ===============================
/// SCREEN
/// ===============================
class SpeechesScreen extends StatefulWidget {
  const SpeechesScreen({super.key});

  @override
  State<SpeechesScreen> createState() => _SpeechesScreenState();
}

class _SpeechesScreenState extends State<SpeechesScreen> {
  bool isLoading = true;
  bool hasError = false;
  List<Speech> speechList = [];

  @override
  void initState() {
    super.initState();
    fetchSpeeches();
  }

  /// ===============================
  /// API CALL
  /// ===============================
  Future<void> fetchSpeeches() async {
    const String url = "https://admin.jinreflexology.in/api/speeches";

    try {
      final response = await http.get(Uri.parse(url));
      final decoded = json.decode(response.body);

      speechList =
          (decoded['data'] as List).map((e) => Speech.fromJson(e)).toList();
    } catch (e) {
      hasError = true;
      debugPrint("❌ Speeches API Error: $e");
    }

    if (mounted) setState(() => isLoading = false);
  }

  /// ===============================
  /// OPEN YOUTUBE
  /// ===============================
  Future<void> openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// ===============================
  /// YOUTUBE THUMBNAIL
  /// ===============================
  String getYoutubeThumbnail(String url) {
    try {
      final uri = Uri.parse(url);
      String? videoId;

      if (uri.host.contains("youtu.be")) {
        videoId = uri.pathSegments.first;
      } else if (uri.path.contains("shorts")) {
        videoId = uri.pathSegments.last;
      } else {
        videoId = uri.queryParameters['v'];
      }

      return "https://img.youtube.com/vi/$videoId/0.jpg";
    } catch (_) {
      return "";
    }
  }

  /// ===============================
  /// UI
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Speeches"),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(child: Text("Something went wrong"))
              : speechList.isEmpty
              ? const Center(child: Text("No speeches found"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: speechList.length,
                itemBuilder: (context, index) {
                  return _speechCard(speechList[index]);
                },
              ),
    );
  }

  /// ===============================
  /// CARD UI (SAME AS HEALTHY TIPS)
  /// ===============================
  Widget _speechCard(Speech speech) {
    final thumbnail = getYoutubeThumbnail(speech.youtubeLink);
    final imageUrl = speech.images.isNotEmpty ? speech.images.first : null;

    return GestureDetector(
      onTap: () => openYoutube(speech.youtubeLink),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xfffff3d6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xfff1cd8f)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              speech.title ?? "Speech",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            /// IMAGE (FROM API) OR YOUTUBE THUMBNAIL
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      imageUrl ?? thumbnail,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                    ),
                  ),

                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),

            if (speech.desc != null && speech.desc!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(speech.desc!, style: const TextStyle(fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }
}