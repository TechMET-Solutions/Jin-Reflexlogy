import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class ColorDetailsScreen extends StatelessWidget {
  final Map item;

  const ColorDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item["image_url"] != null && item["image_url"].isNotEmpty
            ? item["image_url"][0]
            : null;

    return DefaultTabController(
      length: 6, // Fixed 6 tabs for colors
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          children: [
            /// IMAGE
            SizedBox(height: 10),
            imageUrl != null
                ? Container(
                  //height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (_, __, ___) => Center(
                          child: Icon(
                            Icons.color_lens,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                  ),
                )
                : Container(
                  height: 220,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Center(
                    child: Icon(
                      Icons.color_lens,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  ),
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
                textAlign: TextAlign.center,
              ),
            ),

            /// TABS
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.black,
                tabs: const [
                  Tab(text: "Description"),
                  Tab(text: "Details"),
                  Tab(text: "Additional Info"),
                  Tab(text: "Benefits"),
                  Tab(text: "Precautions"),
                  Tab(text: "Side Effects"),
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
                  _tabText(item["benefits"]),
                  _tabText(item["precautions"]),
                  _tabText(item["side_effects"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabText(String? text) {
    // Filter out test data (single letters)
    if (text != null && text.length == 1 && text == "d") {
      text = "No data available";
    }

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
