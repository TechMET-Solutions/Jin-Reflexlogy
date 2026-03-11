import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
class Wrw2018Screen extends StatelessWidget {
  const Wrw2018Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CommonAppBar(title: "WRW - 2018"),
   
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔵 Purple Header
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

            buildRow("Convenor", "JR Anil Jain"),
            buildRow(
              "Advisory Member",
              "Prof. P.B. Lohiya, Dr. Sarvdeo Prasad Gupta",
            ),

            sectionTitle(
              "WRW Inaugural Function - World Reflexology Week Nationwide Free Treatment Mega Event",
            ),

            buildRow("Date", "24th September 2018"),
            buildRow(
              "Guest",
              "Hon. Rajendra Babuji Darda (Editor in Chief, Lokmat), "
            ),
            buildRow("City", "Aurangabad, Maharashtra, India"),
            buildRow("Organizer", "International Reflexology JIN Association"),

            sectionTitle(
              "WRW Concluding Function - 4th National Conference and Award Presentation Ceremony - 2018",
            ),

            buildRow("Date", "30th September 2018"),
            buildRow(
              "Guest",
              "Dr. Sachin Lohia and Dr. Bharat Bhushan Sharma",
            ),
            buildRow("City", "Surat, Gujrat, India"),
            buildRow("Organizer", "International Reflexology JIN Association"),
            buildRow("Supported", "JIN Reflexology, Jain Chumbak"),
            buildRow("Media Partner", "Lokmat (Maharashtra's No.1 Newspaper)"),

            const SizedBox(height: 20),

            /// ✅ ARTICLE SECTION ADDED BELOW
            articleSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🟡 Section Header
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

  /// 📋 Table Row
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

  /// 📰 Article Section
  static Widget articleSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "International Reflexology Week 2018",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "A week-long grand event of free treatments",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "International Reflexology Week is being celebrated across the country as a grand "
                "festival of free medical treatment. The International Reflexology Council observes "
                "the last week of September every year as International Reflexology Week. Following "
                "this tradition, under the leadership of the country’s leading organizations, this "
                "campaign will be conducted throughout the country from September 24th to 30th, "
                "with the cooperation of practitioners of various drug-free therapies such as "
                "acupressure, reflexology, Sujok, Shiatsu, Jain Reflexology, and this year also "
                "including neurotherapy and acupuncture."
                " Free treatment and training camps will be organized as part of this campaign. "
                "Under this initiative, all practitioners will provide free treatment for two "
                "hours daily at their respective centers. After the service week, all practitioners "
                "will be honored with certificates. This grand campaign was initiated three years "
                "ago under the guidance of the Chief Editor of the Lokmat Group, the respected "
                "Rajendra Babuji Darda.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          const Text(
            "Coordinator J.R. Anil Jain said that awareness of reflexology and acupressure, "
                "which are developed forms of the Indian way of life and drug-free treatment "
                "methods, has reached from the local level to the global level. To create public "
                "awareness, along with free treatment, acupressure therapy specialists will also "
                "organize free workshops at the local level in educational institutions and "
                "business establishments during these seven days."
                " Under the joint auspices of the Acupressure Training and Research Center, and with "
                "the support of all the institutions in the country, including the International "
                "Naturopathy Organization, Indian Institute of Holistic Science, Bharatiya "
                "Acupressure Yoga Council, Bihar Acupressure Yoga College, All India Association of "
                "Acupressure Reflexology, Scientific Institute of Alternative Medicine and "
                "Paramedical Science Council, National Institute of Acupressure Research Training "
                "and Treatment, Heritage Foundation, Vishwa Chaitanya Acupressure Therapy "
                "Foundation and Research Center, and Nature Care Organization, a grand event of "
                "two hours of free treatment is being organized daily.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          const Text(
            "To systematically implement all these activities, a national-level committee "
                "has also been formed. This entire program will be organized under the guidance "
                "of Dr. P.B. Lohia, President of the Indian Institute of Holistic Science, "
                "Anant Biradar, President of the International Naturopathy Organization, "
                "Dr. Sarvadev Prasad Gupta, President of the Bharatiya Acupressure Yoga Council, "
                "Shri Ashok Kothari, Vice President of Sujok International Association, and "
                "co-convenor Dr. Dilip Kumar Urankar. Convenor Dr. Anil Kumar Jain provided "
                "this information."
                "For more information, please use the following website:\n"
                "www.jinreflexology.in",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          const Text(
            "The nationwide launch of International Reflexology Week will take place in Aurangabad.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          const Text(
            "The free service week, which will be held across the country, will be inaugurated on September 24th in Aurangabad by the chief editor of the Lokmat group, Rajendra Babuji Darda.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          Text(
            "The Fourth All India Conference of practitioners of drugless therapies, "
                "including Acupressure, Reflexology, Sujok, Shiatsu, and Jain Reflexology, "
                "along with Reiki, Mudra Therapy, Neuro Therapy, etc., is being organized in "
                "Surat on September 30th, the last day of the week. Leading practitioners from "
                "across the country will present their research work at the conference."
                "Participating in this event will provide a golden opportunity for service and "
                "allow attendees to enhance their knowledge by learning from the experiences "
                "of practitioners from different parts of the country. Practitioners with more "
                "than three years of experience and those who have made significant "
                "contributions will also be honored at the event.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "Reflexology Acupressure means: Acu – meaning sharp, pressure – meaning force, "
                "and reflex – meaning reflection. Reflexology acupressure is a method of "
                "treatment that involves applying specific pressure to the reflex points of "
                "the body’s organs, which are located on the hands, feet, ears, and face.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://jinreflexology.in/wrw-event/wrw-2016/#flipbook-df_17451/1/",
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text("Image failed to load")),
                );
              },
            ),
          ),
          SizedBox(height: 20),

          const Text(
            "Glimpses of World Reflexology Week Opening Ceremony",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://jinreflexology.in/wrw-event/wrw-2016/#flipbook-df_17451/1/",
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text("Image failed to load")),
                );
              },
            ),
          ),

          SizedBox(height: 12),

         Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             const Text(
               "2018 concluding – ",
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
             ),

             // FittedBox(
             //   fit: BoxFit.scaleDown,
             //   child: const Text(
             //     "With a resolve to conduct research activities",
             //     textAlign: TextAlign.center,
             //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
             //   ),
             // ),

             const Text(
               "With a resolve to conduct research activities,",
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,letterSpacing: 0,),
             ),

             const Text(
               "International Reflexology Week concludes in Surat",
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,letterSpacing: 0),
             ),
           ],
         ),

          SizedBox(height: 10,),

          Text(
            "Dr. Bharat Bhushan, Delhi; Dr. Sachin Lohia, Mumbai; Mr. Santosh Adakul, "
                "Solapur–Mumbai; and program coordinator J.R. Anil Jain provided guidance. "
                "The second picture shows the practitioners performing the techniques.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "The fourth All India Conference of practitioners of drug-free therapies such as "
                "Acupressure, Reflexology, Sujok, Shiatsu, Jain Reflexology, Reiki, Mudra Therapy, "
                "Neuro Therapy, etc., was held in Surat on the conclusion of International "
                "Reflexology Week.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "At the inaugural program of this week, our guide and Editor-in-Chief of "
                "Lokmat, the respected Rajendra Ji Darda, had said that research work is needed "
                "to make drug-free therapies more effective. Adopting this declaration, "
                "practitioners from across the country resolved to conduct research and "
                "diagnose diseases.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "With the cooperation of all practitioners of drug-free treatments, this "
                "campaign was conducted across the country from September 24th to 30th, "
                "during which thousands of practitioners provided free treatment to millions "
                "of patients across the country through free treatment and training camps.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "The meeting began with a prayer led by J.R. Harshali Sancheti, Preeti Desarda, and Anuprita Gandhi.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "In his introductory remarks, coordinator J.R. Anil Jain said that it is not only necessary "
                "to preserve India’s ancient medical systems but also to make them accessible to everyone "
                "by bringing their scientific perspective to the forefront. "
                "In this regard, we have presented Acupressure, a developed form of the Indian way of life, "
                "as Jain Reflexology. It has the ability to treat diseases and also to identify which organ "
                "of the body is experiencing what problem without the use of any machines. "
                "Dr. Sachin Lohia, Secretary of the Indian Institute of Holistic Science, encouraged all members "
                "to work together.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "The convenor and doctors from across the country extended their heartfelt gratitude "
                "to Shri Rajendra Babuji Darda for providing invaluable service as a media partner "
                "and guide in bringing these side-effect-free medical practices to the common people.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "Leading doctors from across the country also presented their research work, which "
                "primarily included topics such as acupuncture, acupressure, Jain reflexology, home therapy, "
                "magnet therapy, stress-free lifestyle, and clapping therapy.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "The event, organized by the Acupressure Training and Research Center, was successfully "
                "conducted with the significant contributions of convenor J.R. Anil Jain and co-convenors "
                "Dr. Dilip Urankar, Dr. Nanji Bhai (Surat), Santosh Adakul (Solapur), Bharat Bhushan (New Delhi), "
                "and Prof. P.B. Lohia. "
                "The program was successfully anchored by Mrs. Manju Thole and J.R. Shilpa Jain.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://jinreflexology.in/wrw-event/wrw-2016/#flipbook-df_17451/1/",
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text("Image failed to load")),
                );
              },
            ),
          ),
          SizedBox(height: 10,),

          Text(
            "Glimpses of 3rd National Conference and Award Presentation Ceremony",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://jinreflexology.in/wrw-event/wrw-2016/#flipbook-df_17451/1/",
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: Text("Image failed to load")),
                );
              },
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "Health Awareness & Life Changing Seminars Change lifestyle to enjoy life JR Anil Jain’s Appeal",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10,),

          Text(
            "Our lifestyle should be in harmony with nature. In today’s hectic life, despite running around a lot, "
                "we face stress and depression. "
                "To avoid that, we can benefit from a happy life by changing our daily routine a little, "
                "asserted JR Anil Jain, Inventor of JIN Reflexology.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          Text("JR Anil Jain speaking at a seminar.",
            style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.black87,
          ),),

          Text("It is intended to implement new initiatives in the future that will be beneficial to the social and educational sectors.",
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),),

          SizedBox(height: 10,),

          Text(
            "JR Anil Jain further said, “Our ancestors used to say that early to bed and early to rise brings good health. "
                "It is true and has a scientific basis. We must wake up before sunrise. "
                "Only if we sleep for 6 to 8 hours continuously can we experience the joy of being refreshed. "
                "We should take at least 10 to 15 minutes of sleep at any time during the day at our convenience. "
                "In today’s computer age, we spend hours in air-conditioned rooms.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "It is a situation where the body of highly educated people who sit still does not get any sun. "
                "One must walk barefoot on the ground or on the grass for some time every day. Being in the open air allows one to get plenty of oxygen. "
                "Light exercises and yoga should be done regularly. There is no need to go to the gym and strain oneself. "
                "While relaxing at home, one should watch only humorous and funny series. Watching series with fights and tension creates unnecessary mental stress and adversely affects our lifestyle. "
                "Our life is precious.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "Moments do not come back. Always be happy, smiling, and cheerful. Be careful that no one is unhappy with your behavior. "
                "Give happiness to others without causing trouble. This life is not repeated. "
                "While you are happy, you should think about how others will also be happy. Positive thinking changes your lifestyle and doubles the joy of living, said JR Anil Jain.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10,),

          Text(
            "JR Anil Jain has told us through various examples how important it is to change our lifestyle for good health. "
                "If we try to change accordingly, we can enjoy life.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "Life is precious, health plays an important role:  JR Anil Jain",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 10,),

          Text(
            "A workshop was organized in Senior Citizen Bhawan by Giants International, Lions International, "
                "Mahavir International in collaboration with Senior Citizen Forum to control uncontrolled lifestyle "
                "and make people aware about health."
                "The main speakers were JR Anil Jain, Inventor of JIN Reflexology and JR Shilpa Jain who came from Maharashtra. "
                "They said- Life is precious and health plays the most important role in it. "
                "If we want to live a happy life then it is very important for us to be aware about our health."
                "JR Anil Jain gave information about various types of videos through reflexology technology. "
                "He also made available on mobile and information was also provided about the negative impacts of television on our daily lives.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
              fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "Other Glimpses of India’s Biggest Health Awareness Campaign – 2018",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}