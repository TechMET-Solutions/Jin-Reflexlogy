import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HealthCampaignScreen extends StatefulWidget {
  const HealthCampaignScreen({super.key});

  @override
  State<HealthCampaignScreen> createState() => _HealthCampaignScreenState();
}

class _HealthCampaignScreenState extends State<HealthCampaignScreen> {
  final String apiUrl =
      "https://admin.jinreflexology.in/api/health-campaigns";

  late Future<List<HealthCampaign>> campaignFuture;

  @override
  void initState() {
    super.initState();
    campaignFuture = fetchCampaigns();
  }

  // ================= API CALL =================
  Future<List<HealthCampaign>> fetchCampaigns() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List list = body['data'];

      List<HealthCampaign> campaigns = list.map((e) => HealthCampaign.fromJson(e)).toList();

      // Automatically set year to 2027 for campaigns with year 2025 or 2026
      List<HealthCampaign> modifiedCampaigns = campaigns.map((campaign) {
        if (campaign.year == 2025 || campaign.year == 2026) {
          return HealthCampaign(
            id: campaign.id,
            title: campaign.title,
            desc: campaign.desc,
            imageUrl: campaign.imageUrl,
            startDate: campaign.startDate,
            endDate: campaign.endDate,
            year: 2027,
          );
        } else {
          return campaign;
        }
      }).toList();

      return modifiedCampaigns;
    } else {
      throw Exception("Failed to load health campaigns");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Awareness Campaign"),
        backgroundColor: const Color(0xFF3B3B8F),
      ),
      body: FutureBuilder<List<HealthCampaign>>(
        future: campaignFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Campaign Available"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return campaignCard(data[index]);
            },
          );
        },
      ),
    );
  }

  // ================= CARD UI =================
  Widget campaignCard(HealthCampaign item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              item.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.desc,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      "${item.startDate}  to  ${item.endDate}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ================= MODEL =================
class HealthCampaign {
  final int id;
  final String title;
  final String desc;
  final String imageUrl;
  final String startDate;
  final String endDate;
  final int year;

  HealthCampaign({
    required this.id,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.year,
  });

  factory HealthCampaign.fromJson(Map<String, dynamic> json) {
    return HealthCampaign(
      id: json['id'],
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      imageUrl: json['image_url'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      year: json['year'] ?? 0,
    );
  }
}
