import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class VitaminDetailsScreen extends StatelessWidget {
  final Map item;

  const VitaminDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          children: [
          
            SizedBox(height: 5),
            if (item["image_url"] != null &&
                (item["image_url"] as List).isNotEmpty &&
                item["image_url"][0] != null)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Image.network(
                  item["image_url"][0],
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                item["title"] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// TABS WITH ICONS
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(icon: Icon(Icons.description), text: "Description"),
                  Tab(icon: Icon(Icons.info), text: "Details"),
                  Tab(icon: Icon(Icons.add_circle), text: "More Info"),
                  Tab(icon: Icon(Icons.today), text: "Daily Needs"),
                  Tab(icon: Icon(Icons.food_bank), text: "Sources"),
                  Tab(icon: Icon(Icons.health_and_safety), text: "Deficiency"),
                  Tab(icon: Icon(Icons.warning), text: "Side Effects"),
                  Tab(icon: Icon(Icons.error), text: "Warnings"),
                ],
              ),
            ),

            /// TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  _tabText(item["description"]),
                  _tabText(item["details"]),
                  _tabText(item["additionalInfo"]),
                  _tabText(item["daily_needs"]),
                  _tabText(item["source"]),
                  _tabText(item["deficiency"]),
                  _tabText(item["side_effects"]),
                  _tabText(item["warnings"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabText(String? text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          text != null && text.isNotEmpty ? text : "No data available",
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }
}
