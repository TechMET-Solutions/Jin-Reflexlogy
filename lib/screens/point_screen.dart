import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({Key? key}) : super(key: key);

  // Replace these asset paths with your actual images (add them to pubspec.yaml).
  static const List<_PointItem> items = [
    _PointItem(
      title: '1 - Headaches & Insomnia',
      image: 'assets/images/effective_one.jpg',
      color: Color(0xFFF7A325),
      description: 'Press with fingers or thumb on both temples of the head.',
    ),
    _PointItem(
      title: '2 - For Sinus',
      image: 'assets/images/effective_two.jpg',
      color: Color(0xFF7BB241),
      description: 'Apply gentle pressure on both nostrils seven times.',
    ),
    _PointItem(
      title: '3 - Cough, Tonsils, Hoarseness',
      image: 'assets/images/effective_three.jpg',
      color: Color(0xFFF0A83D),
      description:
          'Light press situated at the throat with fingers or thumb for seven times.',
    ),
    _PointItem(
      title: '4 - Increasing Memory',
      image: 'assets/images/effective_four.jpg',
      color: Color(0xFF9B59B6),
      description: 'Press point at ears with fingers and thumb 7 times.',
    ),
    _PointItem(
      title: '5 - For Sciatica',
      image: 'assets/images/effective_five.jpg',
      color: Color(0xFF4FB3E6),
      description:
          'Press 7 times with thumb or fingers on the points shown in red color.',
    ),
    _PointItem(
      title: '6 - For Gas',
      image: 'assets/images/effective_six.jpg',
      color: Color(0xFFF39C12),
      description:
          'Press 7 times with thumb or finger on the points shown in the figure.',
    ),
    _PointItem(
      title: '7 - For Insomnia (Relaxation)',
      image: 'assets/images/effective_seven.jpg',
      color: Color(0xFF6BBF59),
      description:
          'Press the tips of fingers of both hands and take a deep breath. Repeat 21 times.',
    ),
    _PointItem(
      title: '8 - For Hiccups & Vomiting',
      image: 'assets/images/effective_eight.jpg',
      color: Color(0xFFE67E22),
      description:
          'Press the point located at lower part of the throat with finger and release, repeat 21 times.',
    ),
    _PointItem(
      title: '9 - To Break Sleep & Bring Vigour',
      image: 'assets/images/effective_nine.jpg',
      color: Color(0xFF9B59B6),
      description:
          'Press the tips of fingers and thumb of both hands for 7 times.',
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // _AppHeader(),
          SizedBox(height: 10),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.orange.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
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
                crossAxisCount: 2, // 2 cards per row
                mainAxisSpacing: 18, // vertical gap
                crossAxisSpacing: 16, // horizontal gap
                childAspectRatio: 0.50, // card shape ratio
              ),

              itemBuilder: (context, index) {
                final item = items[index];
                return _PointCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.self_improvement,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '9 Effective Points',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Simple acupressure points for common issues',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white)),
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
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.fill,
                    errorBuilder:
                        (c, e, s) => const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 36,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ),

              Row(
                children: [
                  // circular image preview
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.touch_app, size: 18, color: item.color),
                            const SizedBox(width: 6),
                            const Text(
                              'Tap for details',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, _PointItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.56,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          builder:
              (context, scrollController) => SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            item.image,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (c, e, s) =>
                                    const Icon(Icons.image_not_supported),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
        );
      },
    );
  }
}

class _PointItem {
  final String title;
  final String image;
  final Color color;
  final String description;

  const _PointItem({
    required this.title,
    required this.image,
    required this.color,
    required this.description,
  });
}
