import 'dart:convert';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DiseaseModel {
  final String diseaseDetail;
  final String diseaseCauses;
  final String diseaseSymptoms;
  final String diseaseRegimen;
  final String diseaseMainPoint;
  final String diseaseRelatedPoints;
  final String diseaseMicroMagnet;
  final String image; // base64 string
  final List<String> youtubeLinks;

  DiseaseModel({
    required this.diseaseDetail,
    required this.diseaseCauses,
    required this.diseaseSymptoms,
    required this.diseaseRegimen,
    required this.diseaseMainPoint,
    required this.diseaseRelatedPoints,
    required this.diseaseMicroMagnet,
    required this.image,
    required this.youtubeLinks,
  });

  String get youtubeLink => youtubeLinks.isNotEmpty ? youtubeLinks.first : '';

  static List<String> parseYoutubeLinks(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return [value.trim()];
    }

    return [];
  }

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseDetail: json['diseaseDetail'] ?? '',
      diseaseCauses: json['diseaseCauses'] ?? '',
      diseaseSymptoms: json['diseaseSymptoms'] ?? '',
      diseaseRegimen: json['diseaseRegimen'] ?? '',
      diseaseMainPoint: json['diseaseMainPoint'] ?? '',
      diseaseRelatedPoints: json['diseaseRelatedPoints'] ?? '',
      diseaseMicroMagnet: json['diseaseMicroMagnet'] ?? '',
      image: json['image'] ?? '',
      youtubeLinks: parseYoutubeLinks(json['youtube_link']),
    );
  }
}

class DiseaseDetailPage extends StatefulWidget {
  final String? name;

  const DiseaseDetailPage({super.key, this.name});
  @override
  _DiseaseDetailPageState createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  DiseaseModel? disease;
  bool loading = true;
  YoutubePlayerController? _youtubeController;
  final Set<String> _expandedPlayers = <String>{};
  String? _activeVideoUrl;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  String getYoutubeThumbnail(String url) {
    try {
      final uri = Uri.parse(url);
      String? videoId;

      // youtu.be/ID
      if (uri.host.contains("youtu.be")) {
        if (uri.pathSegments.isNotEmpty) {
          videoId = uri.pathSegments.first;
        }
      }
      // youtube.com/watch?v=ID
      else if (uri.host.contains("youtube.com")) {
        videoId = uri.queryParameters['v'];
      }

      if (videoId == null || videoId.isEmpty) {
        return "";
      }

      // HD thumbnail (fallback to normal if not exists)
      return "https://img.youtube.com/vi/$videoId/0.jpg";
    } catch (e) {
      debugPrint("Thumbnail Error: $e");
      return "";
    }
  }

  /// =====================
  /// OPEN YOUTUBE
  /// =====================
  Future<void> openYoutube(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Cannot open: $url");
      }
    } catch (e) {
      debugPrint("Open Youtube Error: $e");
    }
  }

  void _initializeYouTubeController(String videoId) {
    _youtubeController?.dispose();
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  void _launchYouTubeInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch YouTube'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  load() async {
    disease = await fetchDisease();
    if (disease != null && disease!.youtubeLinks.isNotEmpty) {
      _activeVideoUrl = disease!.youtubeLinks.first;
      _preparePlayerForUrl(_activeVideoUrl!);
    }
    setState(() => loading = false);
  }

  void _preparePlayerForUrl(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return;
    _initializeYouTubeController(videoId);
  }

  // HTML → Plain Text Convert
  String cleanHtml(String htmlString) {
    final document = parse(htmlString);
    return document.body?.text.trim() ?? "";
  }

  Future<DiseaseModel?> fetchDisease() async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "a": AppPreference().getString(PreferencesKey.userId) ?? "1",
        "name": widget.name,
      });

      Response response = await dio.post(
        "https://jinreflexology.in/api/request_dwt.php",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 200) {
        dynamic jsonBody;

        // ✅ First print raw response
        // log("RAW RESPONSE: ${response.data}");

        // Case 1: String JSON
        if (response.data is String) {
          jsonBody = jsonDecode(response.data);
        }
        // Case 2: Already Map
        else {
          jsonBody = response.data;
        }

        // ✅ Now print parsed JSON
        print("PARSED JSON: $jsonBody");

        // ✅ success check
        if (jsonBody["success"] == 1) {
          var item = jsonBody["data"][0];
          var youtubeLinks = DiseaseModel.parseYoutubeLinks(
            jsonBody["youtube_link"],
          );

          print("FIRST ITEM: $item");
          print("YouTube Links: $youtubeLinks");

          // Add YouTube link to the item
          if (item is Map<String, dynamic>) {
            item['youtube_link'] = youtubeLinks;
          }

          return DiseaseModel.fromJson(item);
        }
      }

      return null;
    } catch (e, s) {
      print("API Error: $e");
      print("Stack: $s");
      return null;
    }
  }

  Widget _buildYouTubeThumbnail(String youtubeUrl) {
    final thumbnailUrl = getYoutubeThumbnail(youtubeUrl);

    if (thumbnailUrl.isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, size: 50, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                "No Thumbnail Available",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => openYoutube(youtubeUrl),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
              ),
            ),

            // Dark Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),

            // Play Button
            const Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: Icon(Icons.play_arrow, size: 40, color: Colors.white),
              ),
            ),

            // YouTube Logo
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 16),
                    Text(
                      "YouTube",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tap to open hint
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                child: Text(
                  "Tap to watch on YouTube",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 232, 186),
      appBar: CommonAppBar(title: "${widget.name}"),
      body:
          loading
              ? Center(child: CircularProgressIndicator(color: Colors.amber))
              : disease == null
              ? Center(child: Text("No Data"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    cardWidget("${widget.name} :", disease!.diseaseDetail),
                    cardWidget("Causes :", disease!.diseaseCauses),
                    cardWidget("Symptoms :", disease!.diseaseSymptoms),
                    cardWidget("Regimen :", disease!.diseaseRegimen),
                    cardWidget("Main Point :", disease!.diseaseMainPoint),
                    cardWidget(
                      "Related Points :",
                      disease!.diseaseRelatedPoints,
                    ),
                    cardWidget(
                      "Using Micro Magnet :",
                      disease!.diseaseMicroMagnet,
                    ),
                    const SizedBox(height: 15),
                    buildImageBox(disease!.image),

                    // YouTube Section
                    if (disease!.youtubeLinks.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.orange.shade300,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              color: Colors.orange.shade200,
                              child: const Text(
                                "Video Tutorial :",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ...disease!.youtubeLinks.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final url = entry.value;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            index == disease!.youtubeLinks.length - 1
                                                ? 0
                                                : 14,
                                      ),
                                      child: _buildYoutubeVideoCard(url, index),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _buildYoutubeVideoCard(String youtubeUrl, int index) {
    final bool canPlayInApp =
        YoutubePlayer.convertUrlToId(youtubeUrl) != null;
    final bool isExpanded = _expandedPlayers.contains(youtubeUrl);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Video ${index + 1}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade900,
            ),
          ),
          const SizedBox(height: 10),
          _buildYouTubeThumbnail(youtubeUrl),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => openYoutube(youtubeUrl),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.open_in_new, color: Colors.red.shade700),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Open in YouTube App",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        Text(
                          "For best viewing experience",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red.shade700,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          if (canPlayInApp) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedPlayers.remove(youtubeUrl);
                  } else {
                    _expandedPlayers
                      ..clear()
                      ..add(youtubeUrl);
                    _activeVideoUrl = youtubeUrl;
                    _preparePlayerForUrl(youtubeUrl);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.close : Icons.play_circle_fill,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isExpanded ? "Hide In-App Player" : "Play in App",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (isExpanded &&
              _activeVideoUrl == youtubeUrl &&
              _youtubeController != null) ...[
            const SizedBox(height: 10),
            YoutubePlayer(
              controller: _youtubeController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              onReady: () {
                print('YouTube Player is ready.');
              },
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
                const PlaybackSpeedButton(),
                FullScreenButton(),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget cardWidget(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange.shade300, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: Colors.orange.shade200,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(padding: const EdgeInsets.all(10), child: Text(description)),
        ],
      ),
    );
  }

  Widget buildImageBox(String base64String) {
    if (base64String.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange.shade300, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "No Image Available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    try {
      final bytes = base64Decode(base64String);
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange.shade300, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.memory(bytes),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange.shade300, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Error loading image",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}
