import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({Key? key}) : super(key: key);

  static const List<_PointItem> items = [
    _PointItem(
      title: '1 - Headaches & Insomnia',
      image: 'assets/images/effective_one.jpg',
      color: Color(0xFFF7A325),
      description: 'Press with fingers or thumb on both temples of the head.',
      videoUrl: 'https://youtu.be/avNEBlX0pWA',
    ),
    _PointItem(
      title: '2 - For Sinus',
      image: 'assets/images/effective_two.jpg',
      color: Color(0xFF7BB241),
      description: 'Apply gentle pressure on both nostrils seven times.',
      videoUrl: 'https://youtu.be/3qqrMmQM8LY',
    ),
    _PointItem(
      title: '3 - Cough, Tonsils, Hoarseness',
      image: 'assets/images/effective_three.jpg',
      color: Color(0xFFF0A83D),
      description:
          'Light press situated at the throat with fingers or thumb for seven times.',
      videoUrl: 'https://youtu.be/J20EVbBqEtE',
    ),
    _PointItem(
      title: '4 - Increasing Memory',
      image: 'assets/images/effective_four.jpg',
      color: Color(0xFF9B59B6),
      description: 'Press point at ears with fingers and thumb 7 times.',
      videoUrl: 'https://youtu.be/Pj0-fiYJgtg',
    ),
    _PointItem(
      title: '5 - For Sciatica',
      image: 'assets/images/effective_five.jpg',
      color: Color(0xFF4FB3E6),
      description:
          'Press 7 times with thumb or fingers on the points shown in red color.',
      videoUrl: '', // if no link yet
    ),
    _PointItem(
      title: '6 - For Gas',
      image: 'assets/images/effective_six.jpg',
      color: Color(0xFFF39C12),
      description:
          'Press 7 times with thumb or finger on the points shown in the figure.',
      videoUrl: 'https://youtu.be/AyTWhYmOzeI',
    ),
    _PointItem(
      title: '7 - For Vomiting',
      image: 'assets/images/effective_seven.jpg',
      color: Color(0xFF6BBF59),
      description:
          'Press the tips of fingers of both hands and take a deep breath.',
      videoUrl: 'https://youtu.be/qPxwedQIocE',
    ),
    _PointItem(
      title: '8 - For Sleep',
      image: 'assets/images/effective_eight.jpg',
      color: Color(0xFFE67E22),
      description:
          'Press the point located at lower part of the throat and release.',
      videoUrl: 'https://youtu.be/WugXb-evdpQ',
    ),
    _PointItem(
      title: '9 - To Break Sleep & Bring Vigour',
      image: 'assets/images/effective_nine.jpg',
      color: Color(0xFF9B59B6),
      description:
          'Press the tips of fingers and thumb of both hands for 7 times.',
      videoUrl: 'https://youtu.be/ZLupKkkIBkA',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF130442),
        title: const Text(
          'Direct Points',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                "9 Effective Points",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 18,
                crossAxisSpacing: 16,
                childAspectRatio: 0.50,
              ),
              itemBuilder: (context, index) {
                return _PointCard(item: items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PointCard extends StatelessWidget {
  final _PointItem item;

  const _PointCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HexColor("#F0E6D6"),
      borderRadius: BorderRadius.circular(14),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDetail(context, item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.image,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.touch_app, size: 18),
                  SizedBox(width: 6),
                  Text("Tap for details"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// POPUP WITH YOUTUBE THUMBNAIL
  /// ===============================
  void _showDetail(BuildContext context, _PointItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(item.description, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 18),

                  /// 🎥 YOUTUBE THUMBNAIL PREVIEW
                  if (item.videoUrl.isNotEmpty)
                    GestureDetector(
                      onTap: () => _openVideo(item.videoUrl),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _youtubeThumbnail(item.videoUrl),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Done"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// ===============================
  /// HELPERS
  /// ===============================
  String _youtubeThumbnail(String url) {
    final videoId = Uri.parse(url).pathSegments.last;
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  Future<void> _openVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _PointItem {
  final String title;
  final String image;
  final Color color;
  final String description;
  final String videoUrl;

  const _PointItem({
    required this.title,
    required this.image,
    required this.color,
    required this.description,
    required this.videoUrl,
  });
}
