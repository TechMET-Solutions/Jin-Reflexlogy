import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/helth_details_screen.dart';

class HealthCampaign {
  final int id;
  final String title;
  final String desc;
  final String imageUrl;
  final int year;

  HealthCampaign({
    required this.id,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.year,
  });

  factory HealthCampaign.fromJson(Map<String, dynamic> json) {
    return HealthCampaign(
      id: json['id'],
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      imageUrl: json['image_url'] ?? '',
      year: json['year'] ?? 0,
    );
  }
}

Future<List<HealthCampaign>> fetchHealthCampaigns() async {
  final response = await http.get(
    Uri.parse('https://admin.jinreflexology.in/api/health-campaigns'),
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    final List list = decoded['data'];
    return list.map((e) => HealthCampaign.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load campaigns");
  }
}

class YeraHelathScreen extends StatefulWidget {
  const YeraHelathScreen({super.key});

  @override
  State<YeraHelathScreen> createState() => _YeraHelathScreenState();
}

class _YeraHelathScreenState extends State<YeraHelathScreen> {
  late Future<List<HealthCampaign>> futureCampaigns;
  bool showAll = false; // 👈 IMPORTANT

  @override
  void initState() {
    super.initState();
    futureCampaigns = fetchHealthCampaigns();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HealthCampaign>>(
      future: futureCampaigns,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Campaigns Found"));
        }

        final campaigns = snapshot.data!;
        final visibleCount =
            showAll ? campaigns.length : min(8, campaigns.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Text(
                "India's Biggest Health Awareness Campaign",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: visibleCount,
              itemBuilder: (context, index) {
                final item = campaigns[index];

                return Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => HealthCampaignData(id: item.id),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.year.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),

            /// 👇 SEE ALL BUTTON
            if (campaigns.length > 8)
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(
                    showAll ? "Show Less" : "See All",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
