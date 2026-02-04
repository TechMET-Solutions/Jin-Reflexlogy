import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaDetailsScreen extends StatelessWidget {
  final Map item;

  const YogaDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // Fixed 6 tabs for yoga
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          children: [
            /// IMAGE
            if (item["image_url"] != null && 
                (item["image_url"] as List).isNotEmpty && 
                item["image_url"][0] != null)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  item["image_url"][0],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey[100],
                child: Center(
                  child: Icon(
                    Icons.self_improvement,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              ),

            /// TITLE
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                item["title"] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            /// TABS
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(text: "Description"),
                  Tab(text: "details"),
                  Tab(text: "Additional Info"),
                  Tab(text: "Benefits"),
                  Tab(text: "Side Effects"),
                  Tab(text: "Video Guide"),
                ],
              ),
            ),

            /// TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  _tabText(item["description"]),
                  _tabText(item["details"]),
                  _tabText(item["additionalInfo"]),
                  _tabText(item["benefits"]),
                  _tabText(item["side_effects"]),
                  _videoTab(item["procedure_video"], context), // Pass context here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabText(String? text) {
    // Filter out test data (single letters)
    if (text != null && text.length == 1 && 
        ["d", "f", "r", "h", "e", "t", "u", "k", "j"].contains(text)) {
      text = "No data available";
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          text != null && text.isNotEmpty ? text : "No data available",
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }

  Widget _videoTab(String? videoUrl, BuildContext context) { // Add context parameter
    // Extract YouTube video ID if it's a YouTube URL
    String? youtubeId = _extractYoutubeId(videoUrl);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (videoUrl != null && videoUrl.isNotEmpty)
              Column(
                children: [
                  // YouTube Thumbnail
                  if (youtubeId != null)
                    GestureDetector(
                      onTap: () => _launchYoutubeVideo(videoUrl, context),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // YouTube Thumbnail
                              Image.network(
                                "https://img.youtube.com/vi/$youtubeId/hqdefault.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.videocam,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Play Button Overlay
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: const Center(
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    // Generic video thumbnail for non-YouTube URLs
                    GestureDetector(
                      onTap: () => _launchVideoUrl(videoUrl, context),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_library,
                              size: 80,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Watch Video Tutorial",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Video Information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Video Instructions:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "1. Click the video thumbnail above to play\n"
                          "2. Watch the complete tutorial carefully\n"
                          "3. Follow the instructor's guidance step by step\n"
                          "4. Practice at your own pace\n"
                          "5. Stop if you feel any pain or discomfort\n"
                          "6. Breathe normally throughout the practice",
                          style: TextStyle(fontSize: 14, height: 1.6),
                        ),
                        const SizedBox(height: 16),
                        
                        // Video URL Info
                        Text(
                          "Video Source:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.link,
                                size: 20,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SelectableText(
                                  videoUrl,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _launchVideoUrl(videoUrl, context),
                                icon: const Icon(
                                  Icons.open_in_new,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                tooltip: "Open in browser",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Play Button (alternative)
                  ElevatedButton.icon(
                    onPressed: () => _launchVideoUrl(videoUrl, context),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play Video in Browser"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              )
            else
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No video tutorial available",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Check back later for video updates",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Extract YouTube video ID from URL
  String? _extractYoutubeId(String? url) {
    if (url == null || url.isEmpty) return null;
    
    try {
      final uri = Uri.parse(url);
      
      // For standard YouTube URLs like https://www.youtube.com/watch?v=VIDEO_ID
      if (uri.host.contains('youtube.com') && uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }
      
      // For youtu.be short URLs like https://youtu.be/VIDEO_ID
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }
      
      // For live YouTube URLs
      if (uri.host.contains('youtube.com') && uri.pathSegments.contains('live')) {
        // Extract ID from live URLs like https://youtube.com/live/VIDEO_ID
        for (var segment in uri.pathSegments) {
          if (segment != 'live' && segment.isNotEmpty) {
            return segment;
          }
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Launch YouTube video
  Future<void> _launchYoutubeVideo(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showErrorDialog("Could not launch YouTube", context);
      }
    } catch (e) {
      _showErrorDialog("Error opening video: $e", context);
    }
  }

  // Launch generic video URL
  Future<void> _launchVideoUrl(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _showErrorDialog("Could not open video URL", context);
      }
    } catch (e) {
      _showErrorDialog("Error opening video: $e", context);
    }
  }

  void _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}