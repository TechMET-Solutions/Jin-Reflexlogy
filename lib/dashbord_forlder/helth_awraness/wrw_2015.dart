import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2015Screen extends StatefulWidget {
  const Wrw2015Screen({super.key});

  @override
  State<Wrw2015Screen> createState() => _Wrw2015ScreenState();

  /// Section Header
  static Widget sectionTitle(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFFFFF6B0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Table Row
  static Widget buildRow(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFFF9F9F9),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(value),
            ),
          ),
        ],
      ),
    );
  }
}

class _Wrw2015ScreenState extends State<Wrw2015Screen> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;

  /// Article Section
  Widget articleSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Expandable Title
          InkWell(
            onTap: () {
              setState(() {
                isExpanded1 = !isExpanded1;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                    isExpanded1 ? Icons.remove : Icons.add,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Health Awareness & Life Changing Seminars Change Lifestyle to enjoy life JR Anil Jain's Appeal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Expanded Content
          if (isExpanded1) ...[
            const SizedBox(height: 16),

            const Text(
              "Our lifestyle should be in harmony with nature. "
              "In today’s hectic life, despite running around a lot, we face stress and depression. "
              "To avoid that, we can benefit from a happy life by changing our daily routine a little, "
              "asserted JR Anil Jain, Inventor of JIN Reflexology.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "JR Anil Jain was speaking at a seminar organized by Mahavir International. "
              "It is intended to implement new initiatives in the future that will be "
              "beneficial to the social and educational sectors.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "JR Anil Jain further said, “Our ancestors used to say that early to bed "
              "and early to rise brings good health. It is true and has a scientific basis. "
              "We must wake up before sunrise. Only if we sleep for 6 to 8 hours "
              "continuously can we experience the joy of being refreshed. "
              "We should take at least 10 to 15 minutes of sleep at any time "
              "during the day at our convenience. In today’s computer age, "
              "we spend hours in air-conditioned rooms.”",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "It is a situation where the body of highly educated people who sit still "
              "does not get any sun. One must walk barefoot on the ground or on the grass "
              "for some time every day. Being in the open air allows one to get plenty of "
              "oxygen. Light exercises and yoga should be done regularly. There is no need "
              "to go to the gym and strain oneself. While relaxing at home, one should "
              "watch only humorous and funny series. Watching series with fights and "
              "tension creates unnecessary mental stress and adversely affects our "
              "lifestyle. Our life is precious.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "Moments do not come back. Always be happy, smiling, and cheerful. "
              "Be careful that no one is unhappy with your behavior. Give happiness "
              "to others without causing trouble. This life is not repeated. "
              "While you are happy, you should think about how others will also be happy. "
              "Positive thinking changes your lifestyle and doubles the joy of living, "
              "said JR Anil Jain.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "JR Anil Jain has explained through various examples how important it is "
              "to change our lifestyle for good health. If we try to change accordingly, "
              "we can truly enjoy life.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 12),
          ],

          SizedBox(height: 20),

          InkWell(
            onTap: () {
              setState(() {
                isExpanded2 = !isExpanded2;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                    isExpanded2 ? Icons.remove : Icons.add,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Life is precious, Health plays an important role: JR Anil Jain",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Expanded Content
          if (isExpanded2) ...[
            const SizedBox(height: 16),

            const Text(
              "A workshop was organized in Senior Citizen Bhawan by Giants International, "
              "Lions International, and Mahavir International in collaboration with the "
              "Senior Citizen Forum to control unhealthy lifestyles and create awareness "
              "about health. The main speakers were JR Anil Jain, Inventor of JIN "
              "Reflexology, and JR Shilpa Jain who came from Maharashtra. They said that "
              "life is precious and health plays the most important role in it. If we want "
              "to live a happy life, it is very important for us to be aware of our health. "
              "JR Anil Jain shared information about various types of videos through "
              "reflexology technology and also made them available on mobile. "
              "Information was also provided about the negative impacts of television "
              "on our daily lives.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),
          ],

          SizedBox(height: 20),

          /// Expandable Title
          InkWell(
            onTap: () {
              setState(() {
                isExpanded3 = !isExpanded3;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                    isExpanded1 ? Icons.remove : Icons.add,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Ancient Medical methods will be preserved",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Expanded Content
          if (isExpanded3) ...[
            const SizedBox(height: 16),

            const Text(
              "Expert Voices: Praise from doctors in the field of reflexology "
              "and acupressure across the country",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "The ancient medical practices of India, including chiropractic, "
              "acupressure, yoga, and pranayama, need to be preserved. "
              "These practices should be developed and presented to the public "
              "in new forms. Experts said that efforts will be made to ensure "
              "that more and more patients benefit from these practices by "
              "spreading awareness about their advantages. This was stated at "
              "the first national conference and award ceremony held on Sunday "
              "to mark World Reflexology Week.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "World Reflexology Week was celebrated from September 21 to 27. "
              "On the occasion of this week, the Acupressure Training and Research "
              "Center organized a reflexology workshop on Sunday at the "
              "President’s Lawn.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "This national conference and awards ceremony was organized here.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "Rajendra Darda, Editor-in-Chief of ‘Lokmat’, presided over the "
              "function. Assembly Speaker Haribhau Bagde and MP Chandrakant "
              "Khaire were present as the chief guests. Dr. P. B. Lohia, "
              "Dr. Dilip Kamble, and convener Dr. Anil Jain were present on "
              "the platform. At the function, 40 doctors from across the "
              "country who have been working in the field of reflexology "
              "and acupressure for more than three years were honored with "
              "Gold, Silver, and Diamond awards by the dignitaries.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "While guiding the ceremony, Rajendra Darda said that JR Anil Jain, "
              "Inventor of JIN Reflexology, founded the Acupressure Training and "
              "Research Center in 2003. Through this, he has worked to promote "
              "reflexology. A lot of work is being done in the country through "
              "reflexology, and it needs to be taken further.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Haribhau Bagde said that the acupressure treatment method is "
              "spread all over the country today and this technology is being "
              "used widely by society. Chandrakant Khaire (MP) said that "
              "reflexology will be promoted and spread even more in the "
              "coming period.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const SizedBox(height: 12),

            const Text(
              "JR Anil Jain said, Reflexology Week has been organized for the last ten years; but in India, this type of",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "No public awareness program had been conducted earlier. "
              "This week was organized for the first time in the country. "
              "A large number of doctors related to acupressure participated "
              "in this event. On the occasion of the week, free medical and "
              "public awareness workshops were conducted at 21 places in the "
              "city. After the award ceremony, doctors from all over the "
              "country guided the conference. Nilesh Kankaria, Sandeep Kathed, "
              "Shalin Bunaliya, Dr. Vijay Jain, Shailesh Chandiwal, Vinaya "
              "Chamle, Balasaheb Joshi, Syed Azmat, Sheikh Khalid, Harshali "
              "Sancheti, Nupur Baldawa, Manish Bunaliya, Rajendra Pagariya, "
              "Zainab Jamal, Pushpa Jadhav, Dr. S.B. Gorwadkar, Dr. Yogesh "
              "Jain and others worked hard for the successful organization "
              "of the program.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "On the occasion of International Reflexology Week, a grand free "
              "medical camp will be organized for the first time across the "
              "country. Under the leadership of all major institutions in the "
              "country, this campaign will run from September 21 to 27, during "
              "which all practitioners will provide free treatment for two hours "
              "daily at their respective centers. This campaign has been "
              "initiated under the guidance of the esteemed Editor-in-Chief "
              "of the Lokmat Group, Shri Rajendra Babuji Darda.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Reflexology, a developed form of the Indian system of medicine "
              "in the context of acupressure, has gained awareness from the "
              "local to the global level. A grand event is being organized in "
              "the last week of September through the International Reflexology "
              "Council. Through this week, we can create public awareness.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Under the joint auspices of the Acupressure Training and Research "
              "Center and the Rural Health Organization, and with the support "
              "of institutions across the country such as the Acupressure "
              "Research, Training and Treatment Institute, Allahabad, the "
              "Indian Board of Alternative Medicine, Kolkata, the Indian "
              "Institute of Holistic Science, the Bharatiya Acupressure Yoga "
              "Parishad, the Bihar Acupressure Yoga College, Patna, the "
              "Chinese Therapy and Sujok Therapy Center, Roorkee, the "
              "Acupressure Institute, Jodhpur, and the Nature Care Therapists "
              "Association, Aurangabad, a grand initiative of providing free "
              "treatment for two hours daily for a week is being organized "
              "for the first time this year. During these seven days, free "
              "workshops will also be organized at the local level in "
              "acupressure therapy specialist training institutions and "
              "professional organizations.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "On the last day of the week, September 27, the first All India "
              "Conference on Reflexology and Acupressure will be organized in "
              "Aurangabad, Maharashtra, under the chairmanship of the esteemed "
              "Editor-in-Chief of the Lokmat Group, Shri Rajendra Babuji Darda. "
              "Leading medical experts from across the country will grace this "
              "conference. On this occasion, practitioners who have been "
              "providing treatment for more than three years will be honored. "
              "Participating in the ceremony will provide a golden opportunity "
              "for service and will also enhance knowledge through the "
              "experiences of practitioners from various parts of the country. "
              "To systematically implement all these activities, a national-level "
              "committee has also been formed. This entire program will be "
              "organized under the guidance of prominent figures such as "
              "Dr. Suresh G. Agarwal, President of the Indian Board of "
              "Alternative Medicine, Kolkata; Dr. P.B. Lohia, President of the "
              "Indian Institute of Holistic Science; Dr. Sarvadev Prasad Gupta, "
              "President of the Indian Acupressure Yoga Council; Dr. Yogesh "
              "Kodkani, Vice President of Maharashtra International Sujok, "
              "Mumbai; Dr. Chanchalmal Chordiya, Jodhpur; and Nitin Desai, "
              "Mumbai. The convener is JR Anil Jain, Inventor of JIN Reflexology. "
              "For more information, please visit the website: www.jinreflexology.in",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "What is Reflexology Acupressure therapy?",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Reflexology Acupressure means: Acu – meaning sharp, pressure – meaning force, and reflex – meaning reflection.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Reflexology acupressure is a method of treatment that involves "
              "applying specific pressure to the reflex points of the body’s "
              "organs, which are located on the hands, feet, ears, and face.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "The first national conference for International Reflexology Week "
              "is being organized on September 27 in Aurangabad, Maharashtra, "
              "under the chairmanship of the Editor-in-Chief of the Lokmat "
              "Group. More than 300 doctors from across the country will "
              "participate. Doctors who have worked in the field of reflexology "
              "and acupressure therapy for more than three years will also be "
              "honored at the event.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),
          ],

          SizedBox(height: 20),

          Container(height: 200, width: double.infinity, color: Colors.grey),

          SizedBox(height: 20),

          Container(
            height: 50,
            width: double.infinity,
            color: Colors.red,

            child: Text(
              "GLIMPSE OF iNDIA'S BIGGEST HEALTH AWARENESS CAMPAIGN - 2015",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 200, width: double.infinity, color: Colors.grey),

          Divider(color: Colors.red,),

          SizedBox(height: 20),

          const Text(
            "World Reflexology Week free Treatment Campaign - 26 September 2015",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 20),


          Container(height: 200, width: double.infinity, color: Colors.grey),






        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "WRW - 2015"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Purple Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF6A3EB5),
              child: const Text(
                "World Reflexology Week - 24th September to 30th September , 2018",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Wrw2015Screen.buildRow("Convenor", "JR Anil Jain"),

            Wrw2015Screen.buildRow(
              "Advisory Member",
              "Prof. P.B. Lohiya, Dr. Sarvdeo Prasad Gupta",
            ),

            Wrw2015Screen.sectionTitle(
              "WRW Inaugural Function - World Reflexology Week Nationwide Free Treatment Mega Event",
            ),

            Wrw2015Screen.buildRow("Date", "24th September 2018"),

            Wrw2015Screen.buildRow(
              "Guest",
              "Hon. Rajendra Babuji Darda (Editor in Chief, Lokmat)",
            ),

            Wrw2015Screen.buildRow("City", "Aurangabad, Maharashtra, India"),

            Wrw2015Screen.buildRow(
              "Organizer",
              "International Reflexology JIN Association",
            ),

            Wrw2015Screen.sectionTitle(
              "WRW Concluding Function - 4th National Conference and Award Presentation Ceremony - 2018",
            ),

            Wrw2015Screen.buildRow("Date", "30th September 2018"),

            Wrw2015Screen.buildRow(
              "Guest",
              "Dr. Sachin Lohia and Dr. Bharat Bhushan Sharma",
            ),

            Wrw2015Screen.buildRow("City", "Surat, Gujrat, India"),

            Wrw2015Screen.buildRow(
              "Organizer",
              "International Reflexology JIN Association",
            ),

            Wrw2015Screen.buildRow(
              "Supported",
              "JIN Reflexology, Jain Chumbak",
            ),

            Wrw2015Screen.buildRow(
              "Media Partner",
              "Lokmat (Maharashtra's No.1 Newspaper)",
            ),

            const SizedBox(height: 20),

            /// Article Section
            articleSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
