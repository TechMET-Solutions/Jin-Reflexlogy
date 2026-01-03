import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

class SuccessStoryScreen extends StatefulWidget {
  const SuccessStoryScreen({super.key});

  @override
  State<SuccessStoryScreen> createState() => _SuccessStoryScreenState();
}

class _SuccessStoryScreenState extends State<SuccessStoryScreen> {
  bool isLoading = true;
  List<SuccessStory> stories = [];

  @override
  void initState() {
    super.initState();
    fetchSuccessStories();
  }

  // ----------------------------------------------------------
  // API CALL
  // ----------------------------------------------------------
  Future<void> fetchSuccessStories() async {
    try {
      final response = await http.get(
        Uri.parse('https://admin.jinreflexology.in/api/success-stories'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List list = jsonData['data'];
        stories = list.map((e) => SuccessStory.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }

    setState(() => isLoading = false);
  }

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Success Story"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stories.isEmpty
              ? const Center(child: Text("No success stories found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    return _successRow(stories[index]);
                  },
                ),
    );
  }

  // ----------------------------------------------------------
  // SUCCESS CARD
  // ----------------------------------------------------------
  Widget _successRow(SuccessStory story) {
    final thumbnail = getYoutubeThumbnail(story.youtubeLink);

    return GestureDetector(
      onTap: () => openYoutube(story.youtubeLink),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xfffff3d6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xfff1cd8f)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    thumbnail,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
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

            if (story.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                story.description,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // YOUTUBE THUMBNAIL
  // ----------------------------------------------------------
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

  // ----------------------------------------------------------
  // OPEN YOUTUBE
  // ----------------------------------------------------------
  Future<void> openYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

//////////////////////////////////////////////////////////////
// MODEL
//////////////////////////////////////////////////////////////

class SuccessStory {
  final int id;
  final String title;
  final String description;
  final String youtubeLink;

  SuccessStory({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeLink,
  });

  factory SuccessStory.fromJson(Map<String, dynamic> json) {
    return SuccessStory(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      youtubeLink: json['youtube_link'] ?? '',
    );
  }
}
