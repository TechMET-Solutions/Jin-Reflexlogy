import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      debugPrint("🌐 RAW RESPONSE => ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("HTTP Error ${response.statusCode}");
      }

      final Map<String, dynamic> decoded = json.decode(response.body);

      final List list = decoded["data"] ?? [];

      tipsList = list.map((e) => HealthyTip.fromJson(e)).toList();

      debugPrint("📦 TOTAL TIPS => ${tipsList.length}");
    } catch (e) {
      hasError = true;
      debugPrint("❌ Healthy Tips API Error => $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
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
  /// UI
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Healthy Tips"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
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
                  final tip = tipsList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.red,
                        size: 34,
                      ),
                      title: Text(
                        tip.title ?? "Healthy Tip ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          tip.desc != null && tip.desc!.isNotEmpty
                              ? Text(tip.desc!)
                              : const Text("Tap to watch video"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => openYoutube(tip.youtubeLink),
                    ),
                  );
                },
              ),
    );
  }
}