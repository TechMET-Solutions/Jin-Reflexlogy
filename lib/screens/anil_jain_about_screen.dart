import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class AboutJinReflexologyScreen extends StatefulWidget {
  const AboutJinReflexologyScreen({super.key});

  @override
  State<AboutJinReflexologyScreen> createState() =>
      _AboutJinReflexologyScreenState();
}

class _AboutJinReflexologyScreenState extends State<AboutJinReflexologyScreen> {
  Widget sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff7b001c),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget contentBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.45)),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("• $text", style: const TextStyle(fontSize: 14, height: 1.4)),
    );
  }

  final List<Map<String, String>> awardsList = [
    {
      "title": "APPRECIATION AWARD",
      "desc":
          "Conferred by Yogi Vivekanand Nisargoupchar Sikshan Kendra – 2025",
    },
    {
      "title": "APPRECIATION AWARD",
      "desc":
          "Conferred by Mahavir International, Metro City, Chhatrapati Sambhajinagar – 2025",
    },
    {
      "title": "APPRECIATION AWARD",
      "desc":
          "Conferred by Mahavir International, Chhatrapati Sambhajinagar – 2025",
    },
    {
      "title": "APPRECIATION AWARD",
      "desc": "Conferred by Shri Tulsi Mahapraghya Foundation, Mumbai – 2025",
    },
    {
      "title": "APPRECIATION AWARD",
      "desc": "Conferred by Bharat Scouts and Guides – 2024",
    },
    {
      "title": "INTERNATIONAL ICON OF REFLEXOLOGY",
      "desc": "Conferred by Akhil Bhartiya Marvadi – Gujarati Manch – 2024",
    },
    {
      "title": "JIN REFLEXOLOGY RESEARCH AWARD",
      "desc": "Conferred by International Holistic Medicine, Indore – 2022",
    },
    {
      "title": "LIFE TIME ACHIEVEMENT AWARD",
      "desc":
          "Conferred by Mahavir International, Metro City, Aurangabad – 2022",
    },
    {
      "title": "GEM OF ALTERNATIVE MEDICINE",
      "desc": "Conferred by Indian Board of Alternative Medicines – 2011",
    },
    {
      "title": "APPRECIATION AWARD",
      "desc": "Conferred by Lions Club of CIDCO, Aurangabad – 2003",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: CommonAppBar(title: "About JR Anil Jain"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/anil_jain.png"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "JR Anil Suganchand Jain",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Inventor of JIN Reflexology\nPresident – International Reflexology JIN Association",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// INVENTION
            sectionHeader("Invention Work – JIN Reflexology"),
            contentBox(
              "After research on more than 13,000 people, JIN Reflexology Therapy "
              "was developed. Among 200+ therapies worldwide, JIN Reflexology uniquely "
              "diagnoses disease without asking questions to the patient and provides "
              "accurate treatment through reflex points.",
            ),

            const SizedBox(height: 16),

            /// INDIA BIGGEST CAMPAIGN
            sectionHeader("India’s Biggest Health Awareness Campaign"),
            contentBox(
              "National & International Conferences conducted continuously "
              "from 2015 onwards across India.",
            ),
            const SizedBox(height: 8),
            bullet("2015 – Chhatrapati Sambhaji Nagar"),
            bullet("2016–2017 – Mumbai"),
            bullet("2018 – Surat"),
            bullet("2019 – Bengaluru"),
            bullet("2020–2021 – Online"),
            bullet("2022–2025 – 21 to 31 Days Campaign across 7 States"),

            const SizedBox(height: 16),

            /// FREE TREATMENT
            sectionHeader("Free Treatment Service to All"),
            contentBox(
              "Free treatment was provided for 2 hours daily for 29 consecutive years "
              "(1989–2018) as a service to humanity.",
            ),

            const SizedBox(height: 16),

            /// CAMPS
            sectionHeader("Organizing Awareness Camps"),
            contentBox(
              "More than 125 free training and awareness camps were organized "
              "across India to make JIN Reflexology accessible to common people.",
            ),

            const SizedBox(height: 16),

            /// SEMINARS
            sectionHeader("Health Awareness & Life Changing Seminar"),
            contentBox(
              "Till now, more than 165 seminars have been organized nationwide "
              "under Swasth Bharat Abhiyan to promote disease prevention "
              "and healthy lifestyle.",
            ),

            const SizedBox(height: 16),

            /// BOOK
            sectionHeader("Write JIN Reflexology Book"),
            contentBox(
              "JIN Reflexology book has been published in multiple editions "
              "with Hindi & English versions including DVD and QR codes "
              "for deeper learning.",
            ),
            const SizedBox(height: 8),
            bullet("1st Edition – Hindi (Award Winning)"),
            bullet("2nd Edition – English"),
            bullet("3rd Edition – Hindi with DVD"),
            bullet("4th Edition – 118 QR Codes (2024)"),

            const SizedBox(height: 16),

            /// AWARDS
            sectionHeader("Honors & Appreciation Awards"),
            contentBox(
              "For the work of research and service, he has been honored with more than 35 national and international awards like International Icon of Reflexology, Yoga Maharishi, Gems of Alternative Therapy, Maharashtra Gaurav, Yuva Gaurav, Samaj Bhushan, Chinmaya Chikitsa etc.",
            ),
            const SizedBox(height: 10),
            ...awardsList.map(
              (item) => awardCard(item["title"]!, item["desc"]!),
            ),

            const SizedBox(height: 20),
            //sectionHeader("Spiritual"),
            sectionHeader("SPIRITUAL"),

            contentBoxWidget(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "For the past 34 years, every year during the 8 days of “Paryushan festival”, "
                    "I visit places where saints do not observe “Chaturmas”, as a “Swadhyayi” "
                    "and participate in the worship of my religion and that of all members.",
                    style: TextStyle(fontSize: 14, height: 1.45),
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Places Visited (Year-wise):",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Mathaniya (Rajasthan) – 1990\n"
                    "Coimbatore (Tamilnadu) – 1992\n"
                    "Chennai (Tamilnadu) – 1993\n"
                    "Rajnandgaon (Chhattisgarh) – 1994\n"
                    "Jay Pore Jhadi (Orissa) – 1995\n"
                    "Lasur (Maharashtra) – 1996\n"
                    "Nanded (Maharashtra) – 1997\n"
                    "Shrirampur (Maharashtra) – 1998\n"
                    "Parbhani (Maharashtra) – 1999\n"
                    "Beed (Maharashtra) – 2000\n"
                    "Gangapur (Maharashtra) – 2001\n"
                    "Lasalgaon (Maharashtra) – 2002\n"
                    "Manmad (Maharashtra) – 2003\n"
                    "Nandura (Maharashtra) – 2004\n"
                    "Yeola (Maharashtra) – 2005\n"
                    "Karanja (Maharashtra) – 2006\n"
                    "Deola (Maharashtra) – 2007\n"
                    "Pimpalner (Maharashtra) – 2008\n"
                    "Manur Takli (Maharashtra) – 2009\n"
                    "Beed (Maharashtra) – 2010\n"
                    "Raipur (Chhattisgarh) – 2011\n"
                    "Kolkata (West Bengal) – 2012\n"
                    "Bangalore (Karnataka) – 2013\n"
                    "Mumbai CP Tank (Maharashtra) – 2014\n"
                    "Choumahla (Rajasthan) – 2015\n"
                    "Mumbai Bhainder (Maharashtra) – 2016\n"
                    "Morvan (Madhya Pradesh) – 2017\n"
                    "Ramganjmandi (Rajasthan) – 2018\n"
                    "Mumbai – Marol (Maharashtra) – 2019\n"
                    "Jodhpur (Rajasthan) – 2020 (COVID)\n"
                    "Udaipur (Rajasthan) – 2021 (COVID)\n"
                    "Balod (Chhattisgarh) – 2022\n"
                    "Dhar (Madhya Pradesh) – 2023\n"
                    "Alwar (Rajasthan) – 2024\n"
                    "Mumbai – Thane (Maharashtra) – 2025",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            sectionHeader("Social"),
            contentBox(
              "Founder President of Mahavir International, Metro City, an organization working on the principle of service to all, love to all, and live and let live. currently working as the Zone Chairman of Mahavir International, Central Maharashtra.Successfully organized five national and one international convention through the International Reflexology JIN Organization.",
            ),
            Container(height: 5),
          Container(
  width: double.infinity,
  height: 200, // IMPORTANT: height द्यावी लागते
  margin: const EdgeInsets.only(top: 6),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    image: DecorationImage(
      image: NetworkImage("assets/images/award.png"),
      fit: BoxFit.cover, // cover / contain / fill
    ),
  ),
),
SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget contentBoxWidget(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget awardCard(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GREEN HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffe6ffcf),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              desc,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
