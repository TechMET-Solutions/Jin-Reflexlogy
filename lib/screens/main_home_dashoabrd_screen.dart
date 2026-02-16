import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jin_reflex_new/dashbard_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/ebook_screen.dart';
import 'package:jin_reflex_new/screens/shop/shop_screen.dart';
import 'package:jin_reflex_new/services/first_time_service.dart';
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

  @override
  void initState() {
    super.initState();
    _getDeliveryType();
    _checkAndShowWelcomeDialog();
  }

  Future<void> _checkAndShowWelcomeDialog() async {
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint("🔍 Home: Checking if dealer completed...");

    final prefs = await SharedPreferences.getInstance();
    final dealerCompleted = prefs.getBool('dealer_completed') ?? false;

    debugPrint("📊 Home: dealer_completed = $dealerCompleted");

    // If dealer is completed, don't show dialog
    if (dealerCompleted) {
      debugPrint("⏭️ Home: Dealer completed, skipping popup");
      return;
    }

    if (!mounted) return;

    await WelcomeDialog.show(
      context,
      onGetStarted: () {
        debugPrint("🔄 Home: Dialog closed, refreshing...");
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
    final value = prefs.getString("delivery_type");

    return (value == null || value.isEmpty) ? "india" : value;
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

  /// Only non-shop screens here
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          key: ValueKey(_homeScreenKey),
        ); // Use key to force rebuild
      case 1:
        return MemberListScreen();
      case 3:
        return EbookScreen();
      default:
        return HomeScreen(key: ValueKey(_homeScreenKey));
    }
  }
}
