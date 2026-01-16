import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
    final data = json['data'];

    return HealthCampaign(
      id: data['id'],
      title: data['title'],
      desc: data['desc'],
      imageUrl: data['image_url'],
      year: data['year'],
    );
  }
}


class HealthCampaignData extends StatefulWidget {
  const HealthCampaignData({super.key, this.id});
  final id;

  @override
  State<HealthCampaignData> createState() =>
      _HealthCampaignDataState();
}

class _HealthCampaignDataState extends State<HealthCampaignData> {
  late Future<HealthCampaign> campaignFuture;

  @override
  void initState() {
    super.initState();
    campaignFuture = HealthCampaignApi().fetchCampaign(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Campaign'),
      ),
      body: FutureBuilder<HealthCampaign>(
        future: campaignFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final campaign = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE
                Image.network(
                  campaign.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 16),

                /// CONTENT
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        campaign.desc,
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Year: ${campaign.year}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class HealthCampaignApi {
  final Dio _dio = Dio();

  Future<HealthCampaign> fetchCampaign(id) async {
    final response = await _dio.get(
      'https://admin.jinreflexology.in/api/health-campaigns/${id}'
    );

    if (response.statusCode == 200) {
      return HealthCampaign.fromJson(response.data);
    } else {
      throw Exception('Failed to load campaign');
    }
  }
}