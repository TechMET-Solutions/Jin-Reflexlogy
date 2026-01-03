import 'package:flutter/material.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: CommonAppBar(title: "About Us"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // _topLogos(),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/about_bannar.png"),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _sectionTile("Our Mission", ["Your Health is Our Priority"]),
              _sectionTile("Our Vision", [
                "Healthy Life without Medicine - 100%",
              ]),
              _sectionTile("Our Team", []),
              _teamCard(
                image: "assets/images/suganchand_Jain.png",
                name: "Suganbhai Jain",
                role: "Director",
                desc: "A Great Leader and Best Motivational Personality",
              ),
              _teamCard(
                image: "assets/images/suganchand_Jain.png",
                name: "Manoj Kumar Jain",
                role: "Director",
                desc: "Best Administrator and Team Builder",
              ),
              _teamCard(
                image: "assets/images/anil_jain.png",
                name: "Mr. Anil Jain",
                role: "Inventor of Jain Reflexology",
                desc:
                    "Director of Acupressure Training and Research Center, Aurangabad",
              ),
              _sectionTile("Research – Jain Point Technology", [
                "Acupoint technology used in our methodology Acupressure Therapy is based on the 5000-year-old ancient healing science.",
                "The highly effective point stimulation technology ensures deep healing without Medicine & Surgery.",
                "This helps maintain health naturally, solving the disorder around 60%–100% effective results.",
              ]),
              _sectionTile("Training", [
                "We highly enhance and empower JIN Reflexology members through world-class training.",
                "Training helps increase awareness, confidence, discipline and leadership.",
              ]),

              _sectionTile("JIN Reflexology Organized Workshops", [
                "Organized more than 400+ JIN Reflexology Treatment Workshops.",
                "National level awareness camps.",
                "Organized more than 300+ JIN Reflexology Workshops helping thousands of families.",
              ]),

              _sectionTile("Manufacturer", [
                "Muditly crafted and designed Jain Acupressure Therapy material.",
              ]),

              _sectionTile("Exporter", [
                "We export Jain therapeutic tools, rollers, slippers, presses, Jimmy and related accessories.",
              ]),

              _sectionTile("Publisher", [
                "Developed more than 20+ Reflexology Charts in many local languages.",
                "Published 100+ books on Reflexology, Yoga, Diet & Health topics.",
                "International Publications across India and 25+ countries.",
              ]),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // TOP LOGO PANEL
  // ------------------------------
  Widget _topLogos() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset("assets/team1.png", height: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "JAIN ACUPRESSURE HEALTH RESEARCH CENTER",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // SECTION TILE
  // ------------------------------
  Widget _sectionTile(String title, List<String> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• "),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // TEAM CARD
  // ------------------------------
  Widget _teamCard({
    required String image,
    required String name,
    required String role,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade400, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 34, backgroundImage: AssetImage(image)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(desc, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
