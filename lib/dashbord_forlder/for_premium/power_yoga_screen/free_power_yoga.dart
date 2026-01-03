import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  YogaVideo({required this.title, required this.youtubeLink});

  factory YogaVideo.fromJson(Map<String, dynamic> json) {
    return YogaVideo(
      title: json['title'] ?? "",
      youtubeLink: json['youtube_link'] ?? "",
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
        final decoded = json.decode(response.body);
        final result = PowerYogaResponse.fromJson(decoded);

        setState(() {
          yogaList = result.data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      isLoading = false;
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
      appBar: AppBar(
        title: const Text("Power Yoga"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
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

                      /// VIDEOS
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: yoga.videos.length,
                        itemBuilder: (context, i) {
                          final video = yoga.videos[i];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.red,
                                  size: 32,
                                ),
                                title: Text(video.title),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () => openYoutube(video.youtubeLink),
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