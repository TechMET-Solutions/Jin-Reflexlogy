import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/auth/upload_document.dart';
import 'package:jin_reflex_new/bannar.dart';
import 'package:jin_reflex_new/dashbord_forlder/feedback_form.dart';
import 'package:jin_reflex_new/dashbord_forlder/feedback_from_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/free_power_yoga.dart';
import 'package:jin_reflex_new/dashbord_forlder/healthy_tips.dart';
import 'package:jin_reflex_new/dashbord_forlder/training_coureses.dart';
import 'package:jin_reflex_new/dashbord_forlder/year_comaining.dart';
import 'package:jin_reflex_new/foot_chart_screen.dart';
import 'package:jin_reflex_new/hand_chart_screen.dart';
import 'package:jin_reflex_new/marking_screen.dart';
import 'package:jin_reflex_new/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/aboutUs%20copy.dart';
import 'package:jin_reflex_new/screens/anil_jain_about_screen.dart';
import 'package:jin_reflex_new/screens/comman_webview_screen.dart';
import 'package:jin_reflex_new/screens/health_campaign_screen.dart';
import 'package:jin_reflex_new/screens/contactUs/feedBack.dart';
import 'package:jin_reflex_new/screens/ebook_screen.dart';
import 'package:jin_reflex_new/screens/faq_screen.dart';
import 'package:jin_reflex_new/screens/history_screen.dart';
import 'package:jin_reflex_new/screens/info_screen.dart';
import 'package:jin_reflex_new/screens/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/screens/life_style/treatmentPlan.dart';
import 'package:jin_reflex_new/screens/shop/shop_screen.dart';
import 'package:jin_reflex_new/screens/speesh_screen.dart';
import 'package:jin_reflex_new/screens/visitUsScreen.dart';
import 'package:jin_reflex_new/screens/point_finder_screen.dart';
import 'package:jin_reflex_new/screens/point_screen.dart';
import 'package:jin_reflex_new/screens/relaxing_screen.dart';
import 'package:jin_reflex_new/screens/sussess_story_screen.dart';
import 'package:jin_reflex_new/screens/treatment/triment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _countryName = 'Loading...';
  String _countryCode = '';
  bool _isLoadingLocation = true;

  Future<void> _saveDeliveryType(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("delivery_type", value);

    debugPrint("✅ delivery_type saved = $value");
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _checkDocumentsAndShowPopup();
    Future.delayed(const Duration(seconds: 2), _autoSlide);
  }

  Future<void> _checkDocumentsAndShowPopup() async {
    AppPreference().initialAppPreference();
    try {
      final response = await http.get(
        Uri.parse(
          'https://jinreflexology.in/api1/new/check_documents.php?id=${AppPreference().getString(PreferencesKey.userId).toString()}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final bool documentUploaded = data['document_uploaded'] == true;
print("documentUploaded--------------------------------$documentUploaded");    
        if (!documentUploaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppPreference().initialAppPreference();
            _showUploadPopup();
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Document check error: $e');
    }
  }

  void _showUploadPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => PopScope(
            canPop: true,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              icon: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              iconPadding: const EdgeInsets.only(top: 8, right: 8),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Upload Required",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your documents are pending upload.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Upload now to continue using all features.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("LATER"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DocumentUploadScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 20),
                            SizedBox(width: 8),
                            Text("UPLOAD NOW"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            ),
          ),
    );
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

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      setState(() {
        _countryName = 'Location disabled';
        _isLoadingLocation = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        setState(() {
          _countryName = 'Permission denied';
          _isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        _countryName = 'Permission denied';
        _isLoadingLocation = false;
      });
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final country = place.country ?? 'Unknown';
        final code = place.isoCountryCode ?? '';

        final deliveryType =
            country.toLowerCase().contains("india") ? "india" : "outside";

        await _saveDeliveryType(deliveryType);

        setState(() {
          _countryName = country;
          _countryCode = code;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _countryName = 'Error getting location';
        _isLoadingLocation = false;
      });
    }
  }

  Future<String> _getSavedDeliveryType() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("delivery_type");
    return (value == null || value.isEmpty) ? "outside" : value;
  }

  Future<void> _refreshLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _countryName = 'Loading...';
      _countryCode = '';
    });
    await _requestLocationPermission();
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
      onTap: () async {
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
      title: 'Effective Points',
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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LifestyleScreen()),
        );
      },
    ),

    CampaignItem(
      title: 'Feedback',
      img: 'assets/jinImages/12.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FeedBackFormNew()),
        );
      },
    ),
  ];

  List<CampaignItem> campaignItems3() => [
    CampaignItem(
      title: 'Shop',
      img: 'assets/jinImages/13.png',
      onTap: () async {
        final deliveryType = await _getSavedDeliveryType();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShopScreen(deliveryType: deliveryType),
          ),
        );
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
      onTap: () async {
        final deliveryType = await _getSavedDeliveryType();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseScreen(deliveryType: deliveryType),
          ),
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

    CampaignItem(
      title: 'Speeches',
      img: 'assets/jinImages/speech.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SpeechesScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'Vitamin',
      img: 'assets/jinImages/vitamin.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'Minerals',
      img: 'assets/jinImages/minerals.png',
      onTap: () {},
    ),
    CampaignItem(title: 'Yoga', img: 'assets/jinImages/yoga.png', onTap: () {}),
    CampaignItem(
      title: 'Mudra',
      img: 'assets/jinImages/mudra.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'Magnet',
      img: 'assets/jinImages/magnet.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'Color',
      img: 'assets/jinImages/color.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'Spinal',
      img: 'assets/jinImages/spinal.png',
      onTap: () {},
    ),
  ];

  List<CampaignItem> campaignItems4() => [
    CampaignItem(
      title: 'Health Campaigns',
      img: 'assets/jinImages/25.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthCampaignScreen()),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2025',
      img: 'assets/jinImages/26.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'JIN Day 2024',
      img: 'assets/jinImages/26.png',
      onTap: () {},
    ),
    CampaignItem(
      title: 'JIN Day 2023',
      img: 'assets/jinImages/27.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => CommonWebView(
                  url: "https://jinreflexology.in/jin23/",
                  title: "JIN Day 2023",
                ),
          ),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2022',
      img: 'assets/jinImages/28.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => CommonWebView(
                  url: "https://jinreflexology.in/jinday22/",
                  title: "JIN Day 2022",
                ),
          ),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2021',
      img: 'assets/jinImages/29.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => CommonWebView(
                  url: "https://jinreflexology.in/jin2021/",
                  title: "JIN Day 2021",
                ),
          ),
        );
      },
    ),
    CampaignItem(
      title: 'JIN Day 2020',
      img: 'assets/jinImages/30.png',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => CommonWebView(
                  url: "https://jinreflexology.in/jin-day-2020/",
                  title: "JIN Day 2020",
                ),
          ),
        );
      },
    ),
    CampaignItem(title: '2019', img: 'assets/jinImages/31.png', onTap: () {}),
    CampaignItem(title: '2018', img: 'assets/jinImages/31.png', onTap: () {}),
    CampaignItem(title: '2017', img: 'assets/jinImages/31.png', onTap: () {}),
    CampaignItem(title: '2016', img: 'assets/jinImages/31.png', onTap: () {}),
    CampaignItem(title: '2015', img: 'assets/jinImages/31.png', onTap: () {}),
    CampaignItem(
      title: '1989 to 2014',
      img: 'assets/jinImages/31.png',
      onTap: () {},
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
          MaterialPageRoute(builder: (_) => VisitUsScreen()),
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
          MaterialPageRoute(builder: (_) => FeedbackFormScreen()),
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: _refreshLocation,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_countryCode.isNotEmpty && !_isLoadingLocation)
                      SizedBox(
                        width: 16,
                        height: 10,
                        child: CountryFlag.fromCountryCode(_countryCode),
                      ),

                    if (_countryCode.isNotEmpty && !_isLoadingLocation)
                      const SizedBox(width: 6),

                    const SizedBox(width: 6),

                    Text(
                      _countryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (_isLoadingLocation) ...[
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
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
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_rounded),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => CommonWebView(
                          url: "https://jinreflexology.in/privacypolicy.php",
                          title: "Privacy Policy",
                        ),
                  ),
                );
              },
            ),
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
                  Navigator.pop(context);
                  _showLogoutDialog(context);
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
              header: "For JIN Reflexolog                      For Patients",
              items: campaignItems2(),
            ),
            const SizedBox(height: 4),
            _campaignSection(header: " For Premium", items: campaignItems3()),
            // const SizedBox(height: 4),
            _campaignSection(header: "Contact us", items: campaignItems5()),
           
            // Container(
            //   color: const Color(0xFF3B3B8F),
            //   child: YeraHelathScreen(),
            // ),

            // campaignItems4(),

             _campaignSection(header: " India's Biggest Health Awareness Campaign", items: campaignItems4()),

            // const SizedBox(height: 4),
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
              color: Colors.white,
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
              Navigator.pop(context);
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
