import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/dashbord_forlder/murdra/mudra_details_screen.dart';
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

  Future<void> fetchMudras() async {
    try {
      final response =
          await dio.get("https://admin.jinreflexology.in/api/mudras");

      if (response.statusCode == 200 && response.data["success"] == true) {
        setState(() {
          mudrasList = response.data["data"];
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
      appBar: CommonAppBar(title: "Mudras"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mudrasList.length,
            
              itemBuilder: (context, index) {
                final item = mudrasList[index];
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
                          builder: (_) => MudraDetailsScreen(item: item),
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
