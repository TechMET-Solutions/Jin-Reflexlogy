import 'package:flutter/material.dart';
import 'package:jin_reflex_new/foot_chart_screen.dart';
import 'package:jin_reflex_new/marking_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/aboutUs%20copy.dart';
import 'package:jin_reflex_new/screens/comman_webview_screen.dart';
import 'package:jin_reflex_new/screens/ebook_screen.dart';
import 'package:jin_reflex_new/screens/faq_screen.dart';
import 'package:jin_reflex_new/screens/history_screen.dart';
import 'package:jin_reflex_new/screens/info_screen.dart';
import 'package:jin_reflex_new/screens/point_finder_screen.dart';
import 'package:jin_reflex_new/screens/point_screen.dart';
import 'package:jin_reflex_new/screens/productDetail.dart';
import 'package:jin_reflex_new/screens/relaxing_screen.dart';
import 'package:jin_reflex_new/screens/triment_screen.dart';


// ======================== MAIN HOME SCREEN ===========================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEAEA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        title: const Text(
          'JIN Reflexology',
          style: TextStyle(color: Colors.white),
        ),
      ), 
      drawer: Drawer(
        child: Column(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 19, 4, 66)),
              child: Text("Welcome!", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            gradientHeader("JIN Reflexology"),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HistoryScreen()),
                      );
                    },
                    child: Card("assets/images/history_three.jpg", "History"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => InfoScreen()),
                      );
                    },
                    child: Card("assets/images/info.png", "Information"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FootChartScreen()),
                      );
                    },
                    child: Card("assets/images/foot.png", "Foot Chart"),
                  ),
                  InkWell(
                    onTap: () {
                      //Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (_) => HandChartScreen()),
                      // );
                    },
                    child: Card("assets/images/hand.png", "Hand Chart"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MarkingProcedureScreen(),
                        ),
                      );
                    },
                    child: Card("assets/images/marking.png", "Marking"),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FootRelaxingScreen()),
                      );
                    },
                    child: Card("assets/images/relaxing.png", "Relaxing"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PointsScreen()),
                      );
                    },
                    child: Card(
                      "assets/images/effective_points.png",
                      "Direct Points",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FaqScreen()),
                      );
                    },
                    child: Card("assets/images/faq.png", "FAQ"),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gradientHeader("JIN Reflexology"),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MemberListScreen( ),
                                  ),
                                );
                              },
                              child: Card(
                                "assets/images/diagnosis.png",
                                "Diagnosis",
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => PointFinderScreen(),
                                //   ),
                                // );
                              },
                              child: Card(
                                "assets/images/point_finder.png",
                                "Point Finder",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gradientHeader("JIN Reflexology"),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => LifeStyleScreen(),
                                //   ),
                                // );
                              },
                              child: Card(
                                "assets/images/life_style.png",
                                "Life Style",
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => FeedbackScreen(),
                                //   ),
                                // );
                              },
                              child: Card(
                                "assets/images/feedback.png",
                                "Feedback",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            gradientHeader("For Premium"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShopScreen()),
                      );
                    },
                    child: Card("assets/images/shop.png", "Shop"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Treatment()),
                      );
                    },
                    child: Card(
                      "assets/images/treatment_video.png",
                      "Treatment Video",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EbookScreen()),
                      );
                    },
                    child: Card("assets/images/jin_book.png", "JIN E Book"),
                  ),
                  Card("assets/images/tritmentplan.png", "Treatment Plan"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CommonWebView(
                                url: "https://jinreflexology.in/seminar/",
                                title: "Seminar",
                              ),
                        ),
                      );
                    },
                    child: Card("assets/images/seminar.png", "Seminar"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CommonWebView(
                                url: "https://jinreflexology.in/seminar/",
                                title: "Workshop",
                              ),
                        ),
                      );
                    },
                    child: Card("assets/images/Workshop.png", "Workshop"),
                  ),
                  Card("assets/images/JRJain.png", "JR Anil Jain"),
                  Card("assets/images/SuccessStory.png", "Success Story"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutScreen()),
                      );
                    },
                    child: Card("assets/images/about_us.png", "About Us"),
                  ),
                  Card("assets/images/upadet.png", "Update"),
                  Card("assets/images/location.png", "Loaction"),
                  Card("assets/images/Whatsapp.png", "Whatsapp"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Card(String img, String txt) {
    return Builder(
      builder: (context) {
        double w = MediaQuery.of(context).size.width;

        return SizedBox(
          width: w * 0.22, // कार्ड width responsive
          child: Column(
            children: [
              Container(
                height: w * 0.22, // height = width → perfect square
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(img),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                txt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =================== BODY =======================

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

Widget gradientHeader(String title) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFFD7BAA4), // light brown (left)
          Color(0xFFE9D7C8),
          Color(0xFFF5ECE6),
          Color(0xFFFFFFFF), // fade to white (right)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        bottomLeft: Radius.circular(25),
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}

// ========================= UI HELPERS ==========================

Widget _sectionContainer({required Widget child}) {
  return child;
}

Widget _title(String text) => Text(
  text,
  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
);

Widget _sectionHeader(String left, String right) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        left,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Text(
        right,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

class SquareGrid extends StatelessWidget {
  final List<_Item> items;
  const SquareGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 20,
      children: items.map((e) => homeCard(context, e.label, e.asset)).toList(),
    );
  }
}

// ======================== ITEM CARD (InkWell + Navigation) ========================

Widget homeCard(BuildContext context, String label, String asset) {
  return InkWell(
    onTap: () {
      switch (label) {
        case 'Treatment':
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => DiseaseTreatmentScreen()),
          // );
          break;
        case 'E-Book':
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => EbookScreen()),
          // );
          break;
        case 'About Us':
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => AboutUsScreen()),
          // );
          break;
        case 'Contact Us':
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => ContactUsScreen()),
          // );
          break;
      }
    },
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(asset, height: 55, width: 55, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

// Item Model
class _Item {
  final String label;
  final String asset;
  const _Item(this.label, this.asset);
}
