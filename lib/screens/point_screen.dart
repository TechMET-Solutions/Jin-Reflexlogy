import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  late List<_VideoItem> videos;
  YoutubePlayerController? _activeController;
  int? playingIndex;

  @override
  void initState() {
    super.initState();

    videos = [
      _VideoItem(
        title: '1 - Headaches & Insomnia',
        description:
            'Press with fingers or thumb on both temples of the head.',
        url: 'https://youtu.be/avNEBlX0pWA',
      ),
      _VideoItem(
        title: '2 - For Sinus',
        description:
            'Apply gentle pressure on both nostrils seven times.',
        url: 'https://youtu.be/3qqrMmQM8LY',
      ),
      _VideoItem(
        title: '3 - Cough, Tonsils, Hoarseness',
        description:
            'Light press situated at the throat with fingers or thumb.',
        url: 'https://youtu.be/J20EVbBqEtE',
      ),
      _VideoItem(
        title: '4 - Increasing Memory',
        description:
            'Press point at ears with fingers and thumb 7 times.',
        url: 'https://youtu.be/Pj0-fiYJgtg',
      ),
      _VideoItem(
        title: '5 - For Sciatica',
        description:
            'Press 7 times with thumb or fingers on the points shown.',
        url: '',
      ),
      _VideoItem(
        title: '6 - For Gas',
        description:
            'Press 7 times with thumb or finger on the points shown.',
        url: 'https://youtu.be/AyTWhYmOzeI',
      ),
      _VideoItem(
        title: '7 - For Vomiting',
        description:
            'Press the tips of fingers of both hands and take deep breath.',
        url: 'https://youtu.be/qPxwedQIocE',
      ),
      _VideoItem(
        title: '8 - For Sleep',
        description:
            'Press the point located at lower part of the throat.',
        url: 'https://youtu.be/WugXb-evdpQ',
      ),
      _VideoItem(
        title: '9 - To Break Sleep & Bring Vigour',
        description:
            'Press the tips of fingers and thumb of both hands.',
        url: 'https://youtu.be/ZLupKkkIBkA',
      ),
    ];
  }

  void _playVideo(int index) {
    _activeController?.dispose();

    final videoId = YoutubePlayer.convertUrlToId(videos[index].url)!;

    _activeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {
      playingIndex = index;
    });
  }

  @override
  void dispose() {
    _activeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF130442),
        title: const Text(
          'Effective Points',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final item = videos[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              if (item.url.isEmpty)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Video coming soon',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              else if (playingIndex == index)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: YoutubePlayer(
                    controller: _activeController!,
                    showVideoProgressIndicator: true,
                  ),
                )
              else
                GestureDetector(
                  onTap: () => _playVideo(index),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          'https://img.youtube.com/vi/'
                          '${YoutubePlayer.convertUrlToId(item.url)}/0.jpg',
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
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 10),

              Text(
                item.description,
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _VideoItem {
  final String title;
  final String description;
  final String url;

  _VideoItem({
    required this.title,
    required this.description,
    required this.url,
  });
}