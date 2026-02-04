import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class FoodtDetailsScreen extends StatelessWidget {
  final Map item;

  const FoodtDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item["image_url"] != null && item["image_url"].isNotEmpty
            ? item["image_url"][0]
            : null;

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          children: [
            /// IMAGE
            SizedBox(height: 10,),
            if (imageUrl != null)
              Container(
                //height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[200]!,
                      Colors.grey[100]!,
                    ],
                  ),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                color: Colors.grey[100],
                child: Center(
                  child: Icon(
                    Icons.fastfood,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                ),
              ),

            /// TITLE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  item["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            /// TABS
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.green[800],
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.green[800],
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: "DESCRIPTION"),
                  Tab(text: "DETAILS"),
                  Tab(text: "ADDITIONAL INFO"),
                  Tab(text: "DAILY NEEDS"),
                  Tab(text: "FOOD SOURCES"),
                  Tab(text: "DEFICIENCY"),
                  Tab(text: "SIDE EFFECTS"),
                  Tab(text: "WARNINGS"),
                ],
              ),
            ),

            /// TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  _styledTabContent(item["description"]),
                  _styledTabContent(item["details"]),
                  _styledTabContent(item["additionalInfo"]),
                  _styledTabContent(item["daily_needs"]),
                  _styledTabContent(item["source"]),
                  _styledTabContent(item["deficiency"]),
                  _styledTabContent(item["side_effects"]),
                  _styledTabContent(item["warnings"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _styledTabContent(String? text) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text != null && text.isNotEmpty ? text : "No data available",
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}