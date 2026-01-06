import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Detail")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            course['image'] != ""
                ? Image.network(
                    course['image'],
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 120),
                  )
                : const Icon(Icons.image, size: 120),

            const SizedBox(height: 16),

            Text(
              course['title'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(course['longDesc']),
            const SizedBox(height: 20),

            Text("Price: ₹ ${course['price']}"),
            Text("Shipping: ₹ ${course['shipping']}"),
            const SizedBox(height: 10),

            Text(
              "Total: ₹ ${course['total']}",
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
