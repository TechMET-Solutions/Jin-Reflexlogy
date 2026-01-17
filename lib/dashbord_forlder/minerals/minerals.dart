import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/dashbord_forlder/minerals/minerals_details.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class MineralsScreen extends StatefulWidget {
  const MineralsScreen({super.key});

  @override
  State<MineralsScreen> createState() => _MineralsScreenState();
}

class _MineralsScreenState extends State<MineralsScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  List mineralsList = [];

  @override
  void initState() {
    super.initState();
    fetchMinerals();
  }

  Future<void> fetchMinerals() async {
    try {
      final response =
          await dio.get("https://admin.jinreflexology.in/api/minerals");

      if (response.statusCode == 200 && response.data["success"] == true) {
        setState(() {
          mineralsList = response.data["data"];
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
      appBar: CommonAppBar(title: "Minerals"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mineralsList.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = mineralsList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MineralDetailsScreen(item: item),
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
                        Expanded(
                          child: ClipRRect(
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
                );
              },
            ),
    );
  }
}
