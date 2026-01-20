import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/dashbord_forlder/colors/colors_details_screeen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  List colorsList = [];

  @override
  void initState() {
    super.initState();
    fetchColors();
  }

  Future<void> fetchColors() async {
    try {
      final response =
          await dio.get("https://admin.jinreflexology.in/api/colors");

      if (response.statusCode == 200 && response.data["success"] == true) {
        setState(() {
          colorsList = response.data["data"];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Colors"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: colorsList.length,
              
              itemBuilder: (context, index) {
                final item = colorsList[index];
                final imageUrl =
                    item["image_url"] != null &&
                            item["image_url"].isNotEmpty
                        ? item["image_url"][0]
                        : null;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ColorDetailsScreen(item: item),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image, size: 40),
                                  )
                                : const Icon(Icons.image, size: 40),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item["title"] ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
