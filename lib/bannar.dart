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
          return Container(
            height: 200,
           // margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final banners = snapshot.data!;

        return Container(
          margin: EdgeInsets.only(top: 0),
          child: Column(
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

                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _buildBannerImage(banner.image),
                      ),
                    ),
                  );
                }).toList(),

                carouselController: _controller,

                options: CarouselOptions(
                  height: 200,
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

              const SizedBox(height: 16),

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

                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width:
                          _currentIndex == entry.key
                              ? 24
                              : 8,

                      height: 8,

                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),

                        color:
                            _currentIndex == entry.key
                                ? Color(0xFF5B4FCF)
                                : Colors.grey.shade300,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
        fit: BoxFit.fill,
        width: double.infinity,

        errorBuilder:
            (context, error, stackTrace) {
          return Image.asset(
            "assets/images/jin_slide1.png",
            fit: BoxFit.fill,
            width: double.infinity,
          );
        },
      );
    }

    // Local asset
    return Image.asset(
      path,
      fit: BoxFit.fill,
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
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          banner.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF5B4FCF),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            _buildDetailImage(),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      banner.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xFF555555),
                      ),
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

  Widget _buildDetailImage() {
    if (banner.image.startsWith("http")) {
      return Image.network(
        banner.image,
        width: double.infinity,
        height: 220,
        fit: BoxFit.fill,

        errorBuilder:
            (context, error, stackTrace) {
          return Image.asset(
            "assets/images/jin_slide1.png",
            width: double.infinity,
            height: 220,
            fit: BoxFit.fill,
          );
        },
      );
    }

    return Image.asset(
      banner.image,
      width: double.infinity,
      height: 220,
      fit: BoxFit.fill,
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
