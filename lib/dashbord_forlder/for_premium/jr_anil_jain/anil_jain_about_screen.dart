import 'package:flutter/material.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

class AboutJinReflexologyScreen extends StatelessWidget {
  const AboutJinReflexologyScreen({super.key});

  Widget yellowHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget infoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
// "
      appBar: CommonAppBar(title: "About JR Anil Jain"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            // ------------------ PROFILE CARD ------------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: const AssetImage("assets/images/anil_jain.png"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "JR Anil Jain",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "• Inventor of JIN Reflexology\n"
                    "• President – International Reflexology Jain Association",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.3),
                  )
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ------------------ SECTION 1 ------------------
            yellowHeader("INVENTION WORK – JIN REFLEXOLOGY"),
            infoBox(
              "JIN Reflexology was invented from 5000 years practice in the ancient therapy science name 'Indian traditional Reflexology Therapy'. "
              "There are more than 70 meridians in the whole body. Through these meridians a disease can be detected early and reflexology helps maintain body functioning to optimum level. "
              "JIN Reflexology provides modern therapy, which is painless and gives best and effective treatment for a long term.",
            ),

            const SizedBox(height: 15),

            yellowHeader("FREE TREATMENT SERVICE TO ALL"),
            infoBox(
              "A unique and free JIN Reflexology treatment system. The medical service was provided for 2 hours daily for 20 consecutive years.",
            ),

            const SizedBox(height: 15),

            yellowHeader("ORGANIZING AWARENESS CAMPS"),
            infoBox(
              "To make this knowledge treatment awareness conducted in the remote places, more than 2000 treatment camps were conducted with the help of various organisations across the country.",
            ),

            const SizedBox(height: 15),

            yellowHeader("HEALTH AWARENESS AND LIFE CHANGING SEMINAR"),
            infoBox(
              "For the last several years JR has inspired people through his healthy lifestyle. "
              "He conducted more than 1500 seminars inspiring more than 15,00,000 people across India. "
              "Through this awareness seminars he explained the root cause of diseases, their symptoms, diet planning and reflexology science for prevention and cure.",
            ),

            const SizedBox(height: 15),

            yellowHeader("WHAT JIN REFLEXOLOGY CAN DO?"),
            infoBox(
              "JIN Reflexology is based on an excellent approach. It gives quick results, reduces disease and makes the body fit. "
              "It works on reflex points that directly send signals to brain and activate healing energy to the related organs.",
            ),

            const SizedBox(height: 15),

            yellowHeader("Honor"),
            infoBox(
              "For the work of research and service, he has been honoured with more than 200 national & international awards and titles.",
            ),

            const SizedBox(height: 15),
            AwardsScreen(),

            Container(
              height: 200,
              decoration: BoxDecoration( 
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/award.png",))
              ),

            )

          ],
        ),
      ),
    );
  }
}




class AwardsScreen extends StatelessWidget {
  final List<Map<String, String>> awards = [
    {
      "title": "Appreciation Award",
      "subtitle": "Conferred by Lions Club of CIDCO, Aurangabad, 2003"
    },
    {
      "title": "Matrutwad Gaurav Puraskar",
      "subtitle": "Conferred by Value Education Academy, 2004"
    },
    {
      "title": "Samta Ratna Puraskar",
      "subtitle": "Conferred by Maharashtra Equality Welfare Society, 2005"
    },
    {
      "title": "Gem of Alternative Medicine",
      "subtitle": "Conferred by Indian Board of Alternative Medicines, 2011"
    },
    {
      "title": "Appreciation Award",
      "subtitle": "Conferred by Lions Club of Doniskha, Dondicha, 2012"
    },
    {
      "title": "Appreciation Award",
      "subtitle": "Conferred by Nahavir International, Suratgarh, 2012"
    },
    {
      "title": "Appreciation Award",
      "subtitle": "Conferred by Mahatma Gandhi Vidhyalaya, Warsha, 2012"
    },
    {
      "title": "Appreciation Award",
      "subtitle": "Conferred by Bhartiy Jain Sanghtana, Warora, 2013"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("Awards"),
            SizedBox(height: 12),

            /// Awards List
            ...awards.map((item) => _awardCard(item)).toList(),
            SizedBox(height: 25),

            _sectionHeader("SPIRITUAL"),
            _yellowInfoBox(
              "For the past 30 years, every year during the festival “Prakatan Utsav”, "
              "I got thousands of ideas when thousands observe “Dharma Yatra”, and "
              "participate in spreading my religion and that of their members.",
            ),

            _sectionHeader("SOCIAL"),
            _yellowInfoBox(
              "Honorable President of World International Maha Sang, an organisation "
              "working with principles of Samata & Ekta Worldwide. Successfully created "
              "international connections through Reflexology NGO projects.",
            ),
          ],
        );
  }

  /// Header Box
  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xffffd36b),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xffe2b44f), width: 2),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
      ),
    );
  }

  /// Award Card
  Widget _awardCard(Map<String, String> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xfffff3d6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xfff1cd8f)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data["title"]!,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
          SizedBox(height: 4),
          Text("•  ${data["subtitle"]}",
              style: TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  /// Yellow Information Box
  Widget _yellowInfoBox(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xfffff3d6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xfff1cd8f)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
      ),
    );
  }
}
