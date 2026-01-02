import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  /// Fetch course list
  Future<void> fetchCourses() async {
    final response = await http.get(
      Uri.parse("https://admin.jinreflexology.in/api/courses"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        courses = data['data'];
        isLoading = false;
      });
    }
  }

  /// Navigate to detail screen
  void openCourseDetail(int courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                      child: Image.network(
                        course['images'][0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
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
                      "₹${course['total_price']}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => openCourseDetail(course['id']),
                  ),
                );
              },
            ),
    );
  }
}

/// ================= COURSE DETAIL SCREEN =================

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  Map course = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourseDetail();
  }

  Future<void> fetchCourseDetail() async {
    final response = await http.get(
      Uri.parse(
          "https://admin.jinreflexology.in/api/courses/${widget.courseId}"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        course = data['data'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Detail")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(course['images'][0]),
                  const SizedBox(height: 16),

                  Text(
                    course['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(course['longDesc']),
                  const SizedBox(height: 16),

                  Text("Price: ₹${course['price']}"),
                  Text("Shipping: ₹${course['shipping_charges']}"),
                  const SizedBox(height: 8),

                  Text(
                    "Total: ₹${course['total_price']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
