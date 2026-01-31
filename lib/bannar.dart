import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  final CarouselSliderController _controller =
      CarouselSliderController();

  late Future<List<BannerModel>> bannerFuture;

  // ================= OFFLINE BANNERS =================
  final List<BannerModel> offlineBanners = [
    BannerModel(
      id: 1,
      title: "Welcome",
      desc: "Jin Reflexology",
      image: "assets/images/jin_slide1.png",
    ),
    BannerModel(
      id: 2,
      title: "Therapy",
      desc: "Natural Healing",
      image: "assets/images/jin_slide2.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    bannerFuture = fetchBanners();
  }

  // ================= API CALL =================
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              "https://admin.jinreflexology.in/api/banners",
            ),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        final List list = body['data'];

        return list
            .map((e) => BannerModel.fromJson(e))
            .toList();
      } else {
        return offlineBanners;
      }
    } catch (e) {
      debugPrint("Banner API Error: $e");

      // ✅ No internet → offline banners
      return offlineBanners;
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerModel>>(
      future: bannerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const SizedBox(
            height: 175,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final banners = snapshot.data!;

        return Column(
          children: [
            // ================= SLIDER =================
            CarouselSlider(
              items: banners.map((banner) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BannerDetailScreen(
                          banner: banner,
                        ),
                      ),
                    );
                  },

                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15),

                    child: _buildBannerImage(
                      banner.image,
                    ),
                  ),
                );
              }).toList(),

              carouselController: _controller,

              options: CarouselOptions(
                height: 175,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                autoPlayInterval:
                    const Duration(seconds: 30),

                onPageChanged:
                    (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // ================= INDICATOR =================
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: banners
                  .asMap()
                  .entries
                  .map((entry) {
                return GestureDetector(
                  onTap: () =>
                      _controller.animateToPage(
                    entry.key,
                  ),

                  child: Container(
                    width:
                        _currentIndex == entry.key
                            ? 12
                            : 8,

                    height: 8,

                    margin:
                        const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color:
                          _currentIndex == entry.key
                              ? Colors.blue
                              : Colors.grey
                                  .shade400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  // ================= IMAGE BUILDER =================
  Widget _buildBannerImage(String path) {
    // Network image
    if (path.startsWith("http")) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,

        errorBuilder:
            (context, error, stackTrace) {
          return Image.asset(
            "assets/images/jin_slide1.png",
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    }

    // Local asset
    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }
}

// ================= DETAIL SCREEN =================
class BannerDetailScreen extends StatelessWidget {
  final BannerModel banner;

  const BannerDetailScreen({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(banner.title),
        backgroundColor:
            const Color(0xFF3B3B8F),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            _buildDetailImage(),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    banner.desc,
                    style:
                        const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailImage() {
    if (banner.image.startsWith("http")) {
      return Image.network(
        banner.image,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,

        errorBuilder:
            (context, error, stackTrace) {
          return Image.asset(
            "assets/images/jin_slide1.png",
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      banner.image,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
    );
  }
}

// ================= MODEL =================
class BannerModel {
  final int id;
  final String title;
  final String desc;
  final String image;

  BannerModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.image,
  });

  factory BannerModel.fromJson(
      Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
