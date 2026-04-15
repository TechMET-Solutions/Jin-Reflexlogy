import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jin_reflex_new/dashbard_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/ebook_screen.dart';
import 'package:jin_reflex_new/screens/shop/shop_screen.dart';
import 'package:jin_reflex_new/services/first_time_service.dart';
import 'package:jin_reflex_new/services/welcome_dialog_prefs.dart';
import 'package:jin_reflex_new/widgets/welcome_dialog.dart';

class MainHomeScreenDashBoard extends StatefulWidget {
  const MainHomeScreenDashBoard({super.key});

  @override
  State<MainHomeScreenDashBoard> createState() =>
      _MainHomeScreenDashBoardState();
}

class _MainHomeScreenDashBoardState extends State<MainHomeScreenDashBoard> {
  int _currentIndex = 0;
  int _homeScreenKey = 0; // Key to force HomeScreen rebuild

  String _normalizeDeliveryType(String? value) {
    final normalized = (value ?? '').trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'india';
    }
    if (normalized == 'india' || normalized == 'in' || normalized == 'indian') {
      return 'india';
    }
    if (normalized == 'outside' ||
        normalized == 'us' ||
        normalized == 'international') {
      return 'outside';
    }
    return 'india';
  }

  @override
  void initState() {
    super.initState();
    _getDeliveryType();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWelcomeDialog();
    });
  }

  Future<void> _checkAndShowWelcomeDialog() async {
    debugPrint("🔍 Checking dealer status");
    final shouldShow = await WelcomeDialogPrefs.shouldShowDialog();
    debugPrint("shouldShowWelcomeDialog = $shouldShow");
    if (!shouldShow) return;

    if (!mounted) return;

    await WelcomeDialog.show(
      context,
      onGetStarted: () {
        if (mounted) {
          setState(() {
            _homeScreenKey++;
          });
        }
      },
    );
  }

  /// 🔹 Get latest delivery type
  Future<String> _getDeliveryType() async {
    final prefs = await SharedPreferences.getInstance();
    return _normalizeDeliveryType(prefs.getString("delivery_type"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        onTap: (index) async {
          // ✅ SHOP TAB
          if (index == 2) {
            final deliveryType = await _getDeliveryType();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShopScreen(deliveryType: deliveryType),
              ),
            );
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Diagnosis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Product',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'E-Book'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(key: ValueKey(_homeScreenKey));

      case 1:
        return MemberListScreen();

      case 2:
        return FutureBuilder<String>(
          future: _getDeliveryType(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ShopScreen(deliveryType: snapshot.data!);
          },
        );

      case 3:
        return EbookScreen();

      default:
        return HomeScreen(key: ValueKey(_homeScreenKey));
    }
  }
}
