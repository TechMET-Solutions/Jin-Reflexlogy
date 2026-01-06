import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/dashbord_forlder/CourseDetailScreen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.deliveryType});
  final String deliveryType;
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final String country = widget.deliveryType == "india" ? "in" : "us";

    try {
      final response = await http.post(
        Uri.parse("https://admin.jinreflexology.in/api/courses/by-country"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"country": country}),
      );

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      final List list = data['data'] ?? [];

      courses =
          list.map<Map<String, dynamic>>((e) {
            final List pricing = e['pricing'] ?? [];

            final pricingForCountry = pricing.firstWhere(
              (p) => p['country'] == country,
              orElse: () => null,
            );

            return {
              "id": e['id'],
              "title": e['title'] ?? "",
              "description": e['description'] ?? "",
              "longDesc": e['longDesc'] ?? "",
              "image":
                  (e['images'] != null && e['images'].isNotEmpty)
                      ? e['images'][0]
                      : "",
              "price": pricingForCountry?['price'] ?? 0,
              "shipping": pricingForCountry?['shipping_charges'] ?? 0,
              "total": pricingForCountry?['total_price'] ?? 0,
            };
          }).toList();

      hasError = false;
    } catch (e) {
      debugPrint("❌ Course API Error: $e");
      hasError = true;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void openCourseDetail(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title:
            widget.deliveryType == "india"
                ? "Courses (India Delivery)"
                : "Courses (Outside India)",
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
              ? const Center(child: Text("Something went wrong"))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child:
                            course['image'] != ""
                                ? Image.network(
                                  course['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                )
                                : const Icon(Icons.image, size: 50),
                      ),
                      title: Text(
                        course['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        course['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        "₹ ${course['total']}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => openCourseDetail(course),
                    ),
                  );
                },
              ),
    );
  }
}
