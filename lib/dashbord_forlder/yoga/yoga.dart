import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/dashbord_forlder/yoga/yoga_details_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class YogasScreen extends StatefulWidget {
  const YogasScreen({super.key});

  @override
  State<YogasScreen> createState() => _YogasScreenState();
}

class _YogasScreenState extends State<YogasScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  List yogasList = [];

  @override
  void initState() {
    super.initState();
    fetchYogas();
  }

  Future<void> fetchYogas() async {
    try {
      final response =
          await dio.get("https://admin.jinreflexology.in/api/yogas");

      if (response.statusCode == 200 && response.data["success"] == true) {
        setState(() {
          yogasList = response.data["data"];
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
      appBar: CommonAppBar(title: "Yogas"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: yogasList.length,
            
              itemBuilder: (context, index) {
                final item = yogasList[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => YogaDetailsScreen(item: item),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.network(
                              item["image_url"]?[0] ?? "",
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image, size: 40),
                            ),
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
