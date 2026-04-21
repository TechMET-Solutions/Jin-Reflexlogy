import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class MudraDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const MudraDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        item["image_url"] != null && item["image_url"].isNotEmpty
            ? item["image_url"][0]
            : null;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          children: [
            imageUrl != null
                ? Image.network(
                  imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _noImage(),
                )
                : _noImage(),

            /// ================= TITLE =================
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                item["title"] ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// ================= TABS =================
            const TabBar(
              isScrollable: true, // 👈 many tabs scrollable
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: "Description"),
                Tab(text: "Details"),
                Tab(text: "Benefits"),
                Tab(text: "Precautions"),
                Tab(text: "Side Effects"),
                Tab(text: "More Info"),
              ],
            ),

            /// ================= TAB CONTENT =================
            Expanded(
              child: TabBarView(
                children: [
                  /// Description
                  _tabView(item["description"]),

                  /// Details
                  _tabView(item["details"]),

                  /// Benefits
                  _tabView(item["benefits"]),

                  /// Precautions
                  _tabView(item["precautions"]),

                  /// Side Effects
                  _tabView(item["side_effects"]),

                  /// Additional Info
                  _tabView(item["additionalInfo"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= TAB TEXT UI =================
  Widget _tabView(String? text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Text(
          text != null && text.trim().isNotEmpty ? text : "No data available",
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }

  /// ================= NO IMAGE =================
  Widget _noImage() {
    return const SizedBox(
      height: 240,
      child: Center(
        child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
      ),
    );
  }
}
