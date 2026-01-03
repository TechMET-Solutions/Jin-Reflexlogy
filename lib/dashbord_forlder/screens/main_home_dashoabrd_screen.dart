import 'package:flutter/material.dart';
import 'package:jin_reflex_new/dashbard_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/member_list_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/e_books/ebook_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/shop/shop_screen.dart';

class MainHomeScreenDashBoard extends StatefulWidget {
  const MainHomeScreenDashBoard({super.key});

  @override
  State<MainHomeScreenDashBoard> createState() => _MainHomeScreenDashBoardState();
}

class _MainHomeScreenDashBoardState extends State<MainHomeScreenDashBoard> {
  int _currentIndex = 0;

  final List<Widget> _screens =  [
    HomeScreen(),
    MemberListScreen(),
  ShopScreen(deliveryType: '',),
    EbookScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Diagnosis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'E-Book',
          ),
        ],
      ),
    );
  }
}
