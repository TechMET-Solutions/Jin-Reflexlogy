import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

/// =======================
/// MODELS
/// =======================

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class FaqCategory {
  final String heading;
  final List<FaqItem> faqs;

  FaqCategory({required this.heading, required this.faqs});

  factory FaqCategory.fromJson(Map<String, dynamic> json) {
    return FaqCategory(
      heading: json['heading'] ?? '',
      faqs: (json['faqs'] as List).map((e) => FaqItem.fromJson(e)).toList(),
    );
  }
}

/// =======================
/// API SERVICE
/// =======================

class FaqService {
  static const String _url = 'https://admin.jinreflexology.in/api/faqs';

  static Future<List<FaqCategory>> fetchFaqs() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List data = decoded['data'];

      return data.map((e) => FaqCategory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load FAQs');
    }
  }
}

/// =======================
/// FAQ SCREEN
/// =======================

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: CommonAppBar(title: "FAQ"),
      body: FutureBuilder<List<FaqCategory>>(
        future: FaqService.fetchFaqs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong', style: GoogleFonts.poppins()),
            );
          }

          final categories = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADING
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    child: Text(
                      category.heading,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // FAQ LIST
                  ListView.separated(
                    itemCount: category.faqs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      return FaqCard(faq: category.faqs[i]);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// =======================
/// FAQ CARD (EXPANDABLE)
/// =======================

class FaqCard extends StatefulWidget {
  final FaqItem faq;

  const FaqCard({Key? key, required this.faq}) : super(key: key);

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F0E3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT STRIP
                  Container(
                    width: 6,
                    height: isExpanded ? null : 80,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),

                  // QUESTION
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.faq.question,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1C1C1C),
                        ),
                      ),
                    ),
                  ),

                  // ICON
                  Padding(
                    padding: const EdgeInsets.only(right: 10, top: 8),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // ANSWER
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  widget.faq.answer,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    height: 1.45,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
