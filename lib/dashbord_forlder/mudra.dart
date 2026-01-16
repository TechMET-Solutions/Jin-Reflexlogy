import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class MudrasScreen extends StatefulWidget {
  const MudrasScreen({super.key});

  @override
  State<MudrasScreen> createState() => _MudrasScreenState();
}

class _MudrasScreenState extends State<MudrasScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  List mudrasList = [];

  @override
  void initState() {
    super.initState();
    fetchMudras();
  }

  /// 🔹 API CALL
  Future<void> fetchMudras() async {
    try {
      final response = await dio.get(
        "https://admin.jinreflexology.in/api/mudras",
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        setState(() {
          mudrasList = response.data["data"];
          isLoading = false;
        });
      } else {
        showError("Failed to load mudras");
      }
    } catch (e) {
      showError("Something went wrong");
    }
  }

  void showError(String msg) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Mudras"),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : mudrasList.isEmpty
              ? const Center(child: Text("No mudras found"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: mudrasList.length,
                itemBuilder: (context, index) {
                  final item = mudrasList[index];
                  return MudraCard(
                    title: item["title"],
                    description: item["description"],
                    imageUrl:
                        item["image_url"] != null &&
                                item["image_url"].isNotEmpty
                            ? item["image_url"][0]
                            : null,
                  );
                },
              ),
    );
  }
}

/// 🔹 CARD UI
class MudraCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  const MudraCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Image.network(
                imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) =>
                        const SizedBox(height: 180, child: Icon(Icons.image)),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// DESCRIPTION
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
