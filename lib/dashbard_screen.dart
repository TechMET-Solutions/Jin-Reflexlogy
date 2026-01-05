import 'package:flutter/material.dart';
import 'package:jin_reflex_new/dashbord_forlder/banner/bannar.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/feedback_form/feedback_form.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/power_yoga_screen/free_power_yoga.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/healthy_tips/healthy_tips.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/training/training_coureses.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/foot_chart_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/hand_chart_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/marking_screen.dart';
import 'package:jin_reflex_new/api_service/preference/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/member_list_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/contactUs/aboutUs%20copy.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/jr_anil_jain/anil_jain_about_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/screens/comman_webview_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/health_Awereness_2026/health_campaign_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/contactUs/feedBack.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/e_books/ebook_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/faq_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/history_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/info_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/treatment_plan/treatmentPlan.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/shop/delivery_popup.dart';
import 'package:jin_reflex_new/dashbord_forlder/contactUs/location_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/finder/point_finder_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/point_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/jin_REFLEXOLOGY/relaxing_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/success_story/sussess_story_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/treatment_video/treatment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _autoSlide);
  }

  void _autoSlide() {
    if (!mounted) return;
    _currentPage = (_currentPage + 1) % 3;

    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// ================= DATA =================

  List<CampaignItem> campaignItems1() => [
    CampaignItem(
      title: 'History',
      img: 'assets/jinImages/01.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Info',
      img: 'assets/jinImages/02.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InfoScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Foot Chart',
      img: 'assets/jinImages/03.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FootChartScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Hand Chart',
      img: 'assets/jinImages/04.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HandChartScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Marking',
      img: 'assets/jinImages/05.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarkingProcedureScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Relaxing',
      img: 'assets/jinImages/06.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FootRelaxingScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Direct Points',
      img: 'assets/jinImages/07.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PointsScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'FAQ',
      img: 'assets/jinImages/08.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FaqScreen()),
        );
      },
    ),
  ];

  List<CampaignItem> campaignItems2() => [
    CampaignItem(
      title: 'Diagnosis',
      img: 'assets/jinImages/09.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MemberListScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Finder',
      img: 'assets/jinImages/10.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PointFinderScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Life Style',
      img: 'assets/jinImages/11.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LifestyleScreen()),
        );
      },
    ),

    CampaignItem(
      title: 'Feedback',
      img: 'assets/jinImages/12.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReviewOfSystemScreen()),
        );
      },
    ),
  ];

  List<CampaignItem> campaignItems3() => [
    CampaignItem(
      title: 'Shop',
      img: 'assets/jinImages/13.png',
      onTap: () {
        showDeliveryPopup(context);
      },
    ),
    CampaignItem(
      title: 'Treat Video',
      img: 'assets/jinImages/14.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Treatment()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Refle.Book',
      img: 'assets/jinImages/15.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EbookScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Treatement Plan',
      img: 'assets/jinImages/16.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TreatmentPlanScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Seminar',
      img: 'assets/jinImages/17.png',
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
    ),
    CampaignItem(
      title: 'Workshop',
      img: 'assets/jinImages/18.png',
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
    ),
    CampaignItem(
      title: 'Free power Yoga',
      img: 'assets/jinImages/19.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PowerYogaScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Training',
      img: 'assets/jinImages/20.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CourseScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Healthy Tips',
      img: 'assets/jinImages/21.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HealthyTipsScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Health Meter',
      img: 'assets/jinImages/22.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'JR Anil Jain',
      img: 'assets/jinImages/23.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AboutJinReflexologyScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Success Story',
      img: 'assets/jinImages/24.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SuccessStoryScreen()),
        );
      },
    ),
  ];

  List<CampaignItem> campaignItems4() => [
    // CampaignItem(
    //   title: 'Health Campaigns',
    //   img: 'assets/jinImages/25.png',
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
    //     );
    //   },
    // ),
    CampaignItem(
      title: 'JIN Day 2025',
      img: 'assets/jinImages/26.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2024',
      img: 'assets/jinImages/26.png',
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2023',
      img: 'assets/jinImages/27.png',
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2022',
      img: 'assets/jinImages/28.png',
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2021',
      img: 'assets/jinImages/29.png',
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2020',
      img: 'assets/jinImages/30.png',
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(title: '2019', img: 'assets/jinImages/31.png', onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
    }),
    CampaignItem(title: '2018', img: 'assets/jinImages/31.png', onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
    }),
    CampaignItem(title: '2017', img: 'assets/jinImages/31.png', onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
    }),
    CampaignItem(title: '2016', img: 'assets/jinImages/31.png', onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
    }),
    CampaignItem(title: '2015', img: 'assets/jinImages/31.png', onTap: () {
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
    }),
    CampaignItem(
      title: '1989 to 2014',
      img: 'assets/jinImages/31.png',
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
  ];

  List<CampaignItem> campaignItems5() => [
    CampaignItem(
      title: 'About us',
      img: 'assets/jinImages/37.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Update',
      img: 'assets/jinImages/38.png',
      onTap: () {
        Navigator.pop(context);
        launchUrl(
          Uri.parse("https://www.facebook.com/profile.php?id=61580519183420"),
          mode: LaunchMode.externalApplication,
        );
      },
    ),
    CampaignItem(
      title: 'Location',
      img: 'assets/jinImages/39.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LocationScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'WhatsApp',
      img: 'assets/jinImages/40.png',
      onTap: () async {
        final url = Uri.parse(
          "https://wa.me/${9325616269}?text=${Uri.encodeComponent("")}",
        );

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print("Could not launch WhatsApp");
        }
      },
    ),
    CampaignItem(
      title: 'Review',
      img: 'assets/jinImages/41.png',
      onTap: () {
        Navigator.pop(context);
        launchUrl(
          Uri.parse("https://maps.app.goo.gl/scfouzyb2nEzdBkr8?g_st=aw"),
          mode: LaunchMode.externalApplication,
        );
      },
    ),
    CampaignItem(
      title: 'Facebook',
      img: 'assets/jinImages/42.png',
      onTap: () {
        Navigator.pop(context);
        launchUrl(
          Uri.parse("https://www.facebook.com/profile.php?id=61580519183420"),
          mode: LaunchMode.externalApplication,
        );
      },
    ),
    CampaignItem(
      title: 'Youtube',
      img: 'assets/jinImages/43.png',
      onTap: () {
        Navigator.pop(context);
        launchUrl(
          Uri.parse("https://www.youtube.com/@JINReflexology"),
          mode: LaunchMode.externalApplication,
        );
      },
    ),
    CampaignItem(
      title: 'FeedBack',
      img: 'assets/jinImages/44.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FeedBack()),
        ); //2
      },
    ),
  ];

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEAEA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        title: const Text(
          'JIN Reflexology',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 19, 4, 66),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  // JIN Logo Image (Replace with your actual logo asset)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      // If you have an image, use this instead:
                      // image: DecorationImage(
                      //   image: AssetImage('assets/jin_logo.png'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Image.asset(
                      "assets/images/jin_reflexo.png",
                      height: 60,
                      //color: Color.fromARGB(255, 19, 4, 66),
                    ),
                  ),
                  SizedBox(height: 15),

                  // JIN Reflexology Text
                  Text(
                    "JIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "REFLEXOLOGY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            // Add your drawer items here
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            // Add more drawer items as needed

            // Logout button at the bottom
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer first
                  _showLogoutDialog(context); // Show logout confirmation
                },
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            // AutoSlider(pageController: _pageController),
            BannerSlider(),

            _campaignSection(
              header: "JIN Reflexology",
              items: campaignItems1(),
            ),

            const SizedBox(height: 4),

            _campaignSection(
              header: "For JIN Reflexology        For Patients",
              items: campaignItems2(),
            ),

            const SizedBox(height: 4),

            _campaignSection(header: " For Premium", items: campaignItems3()),
            const SizedBox(height: 4),

            _campaignSection(
              header: "India’s Biggest Health Awareness Campaign",
              items: campaignItems4(),
            ),
            const SizedBox(height: 4),

            _campaignSection(header: "Contact us", items: campaignItems5()),
          ],
        ),
      ),
    );
  }

  /// ================= CAMPAIGN SECTION =================

  Widget _campaignSection({
    required String header,
    required List<CampaignItem> items,
  }) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF3B3B8F),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            header,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) {
              final item = items[index];
              return Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: item.onTap,
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 1,
                          bottom: 1,
                          left: 18,
                          right: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.asset(item.img, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ================= AUTO SLIDER =================

class AutoSlider extends StatelessWidget {
  final PageController pageController;
  const AutoSlider({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView(
        controller: pageController,
        children: const [
          _SliderCard(color: Colors.blue, title: "Page 1"),
          _SliderCard(color: Colors.green, title: "Page 2"),
          _SliderCard(color: Colors.orange, title: "Page 3"),
        ],
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final Color color;
  final String title;
  const _SliderCard({required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= MODEL =================

class CampaignItem {
  final String title;
  final String img;
  final VoidCallback onTap;

  const CampaignItem({
    required this.title,
    required this.img,
    required this.onTap,
  });
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Navigator.pop(context); // Close dialog
              // Add your logout logic here
              AppPreference().clearSharedPreferences();
              Navigator.pop(context);

              // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              print('User logged out');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
