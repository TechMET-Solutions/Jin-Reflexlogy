import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// =====================
/// MODELS
/// =====================
class PowerYogaResponse {
  final bool success;
  final String message;
  final List<PowerYoga> data;

  PowerYogaResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PowerYogaResponse.fromJson(Map<String, dynamic> json) {
    return PowerYogaResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: (json['data'] as List).map((e) => PowerYoga.fromJson(e)).toList(),
    );
  }
}

class PowerYoga {
  final int id;
  final String heading;
  final List<YogaVideo> videos;

  PowerYoga({required this.id, required this.heading, required this.videos});

  factory PowerYoga.fromJson(Map<String, dynamic> json) {
    return PowerYoga(
      id: json['id'],
      heading: json['heading'] ?? "",
      videos:
          (json['videos'] as List).map((e) => YogaVideo.fromJson(e)).toList(),
    );
  }
}

class YogaVideo {
  final String title;
  final String youtubeLink;
  final String image;
  final String image_url;

  YogaVideo({
    required this.title,
    required this.youtubeLink,
    required this.image,
    required this.image_url,
  });

  factory YogaVideo.fromJson(Map<String, dynamic> json) {
    return YogaVideo(
      title: json['title'] ?? "",
      youtubeLink: json['youtube_link'] ?? "",
      image: json['image'] ?? "",
      image_url: json['image_url'] ?? "",
    );
  }
}

/// =====================
/// SCREEN
/// =====================
class PowerYogaScreen extends StatefulWidget {
  const PowerYogaScreen({super.key});

  @override
  State<PowerYogaScreen> createState() => _PowerYogaScreenState();
}

class _PowerYogaScreenState extends State<PowerYogaScreen> {
  bool isLoading = true;
  List<PowerYoga> yogaList = [];

  @override
  void initState() {
    super.initState();
    fetchPowerYogas();
  }

  /// =====================
  /// API CALL
  /// =====================
  Future<void> fetchPowerYogas() async {
    try {
      final response = await http.get(
        Uri.parse('https://admin.jinreflexology.in/api/power-yogas'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        yogaList =
            (jsonData['data'] as List)
                .map((e) => PowerYoga.fromJson(e))
                .toList();
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }

    setState(() => isLoading = false);
  }

  /// =====================
  /// YOUTUBE THUMBNAIL (SAME AS SUCCESS STORY)
  /// =====================
  String getYoutubeThumbnail(String url) {
    try {
      final uri = Uri.parse(url);
      String? videoId;

      if (uri.host.contains("youtu.be")) {
        videoId = uri.pathSegments.first;
      } else {
        videoId = uri.queryParameters['v'];
      }

      return "https://img.youtube.com/vi/$videoId/0.jpg";
    } catch (_) {
      return "";
    }
  }

  /// =====================
  /// OPEN YOUTUBE
  /// =====================
  Future<void> openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// =====================
  /// UI
  /// =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Power Yoga"),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: yogaList.length,
                itemBuilder: (context, index) {
                  final yoga = yogaList[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        yoga.heading,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: yoga.videos.length,
                        itemBuilder: (context, i) {
                          final video = yoga.videos[i];
                          final thumbnail = getYoutubeThumbnail(
                            video.youtubeLink,
                          );

                          return GestureDetector(
                            onTap: () => openYoutube(video.youtubeLink),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xfffff3d6),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xfff1cd8f),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          "${video.image_url}",
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Container(
                                                height: 200,
                                                width: double.infinity,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                              ),
                                        ),
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withOpacity(
                                              0.4,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            size: 42,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
    );
  }
}
