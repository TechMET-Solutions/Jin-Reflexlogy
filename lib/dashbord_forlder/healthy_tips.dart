import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// ===============================
/// MODEL
/// ===============================
class HealthyTip {
  final int id;
  final String? title;
  final String? desc;
  final String youtubeLink;

  HealthyTip({
    required this.id,
    this.title,
    this.desc,
    required this.youtubeLink,
  });

  factory HealthyTip.fromJson(Map<String, dynamic> json) {
    return HealthyTip(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      youtubeLink: json['youtube_link'] ?? "",
    );
  }
}

/// ===============================
/// SCREEN
/// ===============================
class HealthyTipsScreen extends StatefulWidget {
  const HealthyTipsScreen({super.key});

  @override
  State<HealthyTipsScreen> createState() => _HealthyTipsScreenState();
}

class _HealthyTipsScreenState extends State<HealthyTipsScreen> {
  bool isLoading = true;
  bool hasError = false;
  List<HealthyTip> tipsList = [];

  @override
  void initState() {
    super.initState();
    fetchHealthyTips();
  }

  /// ===============================
  /// API CALL
  /// ===============================
  Future<void> fetchHealthyTips() async {
    const String url = "https://admin.jinreflexology.in/api/healthy-tips";

    try {
      final response = await http.get(Uri.parse(url));
      final decoded = json.decode(response.body);

      tipsList =
          (decoded['data'] as List).map((e) => HealthyTip.fromJson(e)).toList();
    } catch (e) {
      hasError = true;
      debugPrint("❌ Healthy Tips API Error: $e");
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
      appBar: CommonAppBar(title: "Healthy Tips") ,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(child: Text("Something went wrong"))
              : tipsList.isEmpty
              ? const Center(child: Text("No healthy tips found"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tipsList.length,
                itemBuilder: (context, index) {
                  return _tipCard(tipsList[index]);
                },
              ),
    );
  }

  /// ===============================
  /// CARD UI (RESPONSIVE PREVIEW)
  /// ===============================
  Widget _tipCard(HealthyTip tip) {
    final thumbnail = getYoutubeThumbnail(tip.youtubeLink);

    return GestureDetector(
      onTap: () => openYoutube(tip.youtubeLink),
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
              tip.title ?? "Healthy Tip",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            /// VIDEO PREVIEW (RESPONSIVE)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      thumbnail,
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

            if (tip.desc != null && tip.desc!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(tip.desc!, style: const TextStyle(fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }
}
