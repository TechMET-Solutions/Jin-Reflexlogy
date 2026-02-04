import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class MineralDetailsScreen extends StatelessWidget {
  final Map item;

  const MineralDetailsScreen({super.key, required this.item});

  // Helper function to check if a field has meaningful content
  bool _hasContent(String? field) {
    if (field == null) return false;
    if (field.isEmpty) return false;
    if (field.trim().isEmpty) return false;
    if (field.toLowerCase() == "null") return false;
    if (field.toLowerCase().contains("no information")) return false;
    if (field.toLowerCase().contains("no data")) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Count available tabs
    int tabCount = 1; // Always show Description
    
    if (_hasContent(item["details"])) tabCount++;
    if (_hasContent(item["additionalInfo"])) tabCount++;
    if (_hasContent(item["daily_needs"])) tabCount++;
    if (_hasContent(item["source"])) tabCount++;
    if (_hasContent(item["deficiency"])) tabCount++;
    if (_hasContent(item["side_effects"])) tabCount++;
    if (_hasContent(item["warnings"])) tabCount++;

    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        appBar: CommonAppBar(title: item["title"] ?? ""),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE AT TOP
            SizedBox(height: 5,),
            if (item["image_url"] != null && 
                (item["image_url"] as List).isNotEmpty && 
                item["image_url"][0] != null &&
                item["image_url"][0].toString().isNotEmpty)
              Container(
                //height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  item["image_url"][0].toString(),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),

            // TABS
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: tabCount > 3,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.black,
                tabs: _buildTabs(),
              ),
            ),

            // TAB CONTENT
            Expanded(
              child: TabBarView(
                children: _buildTabViews(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    List<Widget> tabs = [];
    
    tabs.add(const Tab(text: "Description"));
    
    if (_hasContent(item["details"])) {
      tabs.add(const Tab(text: "Details"));
    }
    
    if (_hasContent(item["additionalInfo"])) {
      tabs.add(const Tab(text: "Additional Info"));
    }
    
    if (_hasContent(item["daily_needs"])) {
      tabs.add(const Tab(text: "Daily Needs"));
    }
    
    if (_hasContent(item["source"])) {
      tabs.add(const Tab(text: "Food Sources"));
    }
    
    if (_hasContent(item["deficiency"])) {
      tabs.add(const Tab(text: "Deficiency"));
    }
    
    if (_hasContent(item["side_effects"])) {
      tabs.add(const Tab(text: "Side Effects"));
    }
    
    if (_hasContent(item["warnings"])) {
      tabs.add(const Tab(text: "Warnings"));
    }
    
    return tabs;
  }

  List<Widget> _buildTabViews() {
    List<Widget> views = [];
    
    // Description
    views.add(_buildTabContent(
      "Description",
      item["description"] ?? "No description available",
    ));
    
    // Details
    if (_hasContent(item["details"])) {
      views.add(_buildTabContent(
        "Details",
        item["details"]!,
      ));
    }
    
    // Additional Info
    if (_hasContent(item["additionalInfo"])) {
      views.add(_buildTabContent(
        "Additional Information",
        item["additionalInfo"]!,
      ));
    }
    
    // Daily Needs
    if (_hasContent(item["daily_needs"])) {
      views.add(_buildTabContent(
        "Daily Requirements",
        item["daily_needs"]!,
      ));
    }
    
    // Food Sources
    if (_hasContent(item["source"])) {
      views.add(_buildTabContent(
        "Food Sources",
        item["source"]!,
      ));
    }
    
    // Deficiency
    if (_hasContent(item["deficiency"])) {
      views.add(_buildTabContent(
        "Deficiency",
        item["deficiency"]!,
      ));
    }
    
    // Side Effects
    if (_hasContent(item["side_effects"])) {
      views.add(_buildTabContent(
        "Side Effects",
        item["side_effects"]!,
      ));
    }
    
    // Warnings - FIXED: Now properly checking and displaying
    if (_hasContent(item["warnings"])) {
      views.add(_buildTabContent(
        "Warnings & Precautions",
        item["warnings"]!,
      ));
    }
    
    return views;
  }

  Widget _buildTabContent(String title, String content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: SelectableText(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}