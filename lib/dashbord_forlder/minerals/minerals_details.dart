import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class MineralDetailsScreen extends StatelessWidget {
  final Map item;

  const MineralDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          children: [
            /// IMAGE
            Image.network(
              item["image_url"]?[0] ?? "",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(height: 220, child: Icon(Icons.image)),
            ),

            /// TITLE
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

            /// TABS
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: "Description"),
                Tab(text: "Details"),
                Tab(text: "Additional Info"),
              ],
            ),

            /// TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  _tabText(item["description"]),
                  _tabText(item["details"]),
                  _tabText(item["additionalInfo"]),
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
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
