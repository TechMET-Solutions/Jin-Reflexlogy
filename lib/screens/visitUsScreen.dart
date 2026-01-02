import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitUsScreen extends ConsumerStatefulWidget {
  const VisitUsScreen({super.key});

  @override
  ConsumerState<VisitUsScreen> createState() => _VisitUsScreenState();
}

class _VisitUsScreenState extends ConsumerState<VisitUsScreen> {
  void openLocation() async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir//JIN+Health+Care+-+Acupressure,+Reflexology,+Magnet+Town+Centre,+N+1,+Cidco+Chhatrapati+Sambhajinagar,+Maharashtra+431003/@19.8791191,75.3665192,16z/data=!4m5!4m4!1m0!1m2!1m1!1s0x3bdba36db1f1d581:0x67440e70b6fad88d",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f3eb),
      appBar: CommonAppBar(title: "Location"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _locationCard(
              title: "Jain Chumbak",
              address:
                  "A-302, Blue Bell, Near Prozone Mall, Chikalthana, Aurangabad – 431006, Maharashtra, India.",
              phone: "91-7620616269, 91-9569616269",
              footer: "Aurangabad Address",
            ),

            SizedBox(height: 10),

            // Map Image / Google Map Static Image
            InkWell(
              onTap: () {
                openLocation();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/images/google_map.png",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20),

            _locationCard(
              title: "Jain Chumbak",
              address:
                  "Vandita Mini Tower, Chandi Hall, Jodhpur, Rajasthan, India.",
              phone: "0291-2616269",
              footer: "Rajasthan Address (Main)",
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationCard({
    required String title,
    required String address,
    required String phone,
    required String footer,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xfffff3d6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xfff1cd8f)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.orange),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          SizedBox(height: 8),
          Text(address, style: TextStyle(fontSize: 14, height: 1.4)),
          SizedBox(height: 8),

          Text(
            "Phone: $phone",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              footer,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
