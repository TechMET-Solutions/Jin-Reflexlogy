import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/dashbord_forlder/vitamin/vitamin_details.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class VitaminsScreen extends StatefulWidget {
  const VitaminsScreen({super.key});

  @override
  State<VitaminsScreen> createState() => _VitaminsScreenState();
}

class _VitaminsScreenState extends State<VitaminsScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  List vitaminsList = [];

  @override
  void initState() {
    super.initState();
    fetchVitamins();
  }

  Future<void> fetchVitamins() async {
    try {
      final response =
          await dio.get("https://admin.jinreflexology.in/api/vitamins");

      if (response.statusCode == 200 && response.data["success"] == true) {
        setState(() {
          vitaminsList = response.data["data"] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching vitamins: $e");
      setState(() => isLoading = false);
    }
  }

  String _getImageUrl(Map<String, dynamic> item) {
    if (item["image_url"] is List && item["image_url"].isNotEmpty) {
      return item["image_url"][0]?.toString() ?? "";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Vitamins"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vitaminsList.isEmpty
              ? const Center(
                  child: Text(
                    "No vitamins available",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                
                  padding: const EdgeInsets.all(16),
                  itemCount: vitaminsList.length,
                  itemBuilder: (context, index) {
                    final item = vitaminsList[index];
                    final title = item["title"]?.toString() ?? "No Title";
                    final imageUrl = _getImageUrl(item);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VitaminDetailsScreen(item: item),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                       // height: 200,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 40,
                                              color: Colors.grey[400],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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