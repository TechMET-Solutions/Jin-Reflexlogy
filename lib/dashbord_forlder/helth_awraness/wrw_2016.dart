import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
class Wrw2016Screen extends StatelessWidget {
  const Wrw2016Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "WRW - 2016"),
    
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔵 Purple Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF6A3EB5),
              child: const Text(
                "World Reflexology Week - 19th September to 25th September, 2016",
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

            buildRow("Date", "19th September 2016"),
            buildRow(
              "Guest",
              "Hon. Rajendra Babuji Darda (Editor in Chief, Lokmat), "
                  "Hon. Prashant Bamb (MLA), Hon. Atul Save (MLA)",
            ),
            buildRow("City", "Aurangabad, Maharashtra, India"),
            buildRow("Organizer", "International Reflexology JIN Association"),

            sectionTitle(
              "WRW Concluding Function - 2nd National Conference and Award Presentation Ceremony - 2016",
            ),

            buildRow("Date", "25th September 2016"),
            buildRow(
              "Guest",
              "Hon. Deepak Kesarkar (Minister of State), "
                  "Hon. Shrikant Shinde (MP)",
            ),
            buildRow("City", "Mumbai, Maharashtra, India"),
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
            "International Reflexology Week from September 19th",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "A grand celebration of therapy to be held across the country",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "Aurangabad: The International Reflexology Week will be celebrated "
                "across the country as a grand festival of free therapy. Under the "
                "leadership of all major institutions in the country, this campaign "
                "will run from September 19th to 25th with the cooperation of therapists "
                "of various treatment methods such as Acupressure, Sujok, Shiatsu, "
                "Reflexology, and JIN Reflexology. Under this initiative, all therapists "
                "will provide free treatment for two hours every day at their centers. "
                "The campaign will be launched under the guidance of Lokmat Group’s "
                "Editor-in-Chief, Rajendra Darda.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "Convener JR Anil, Inventor of JIN Reflexology, said that this grand "
                "event of free treatment for two hours every day for a week will be "
                "organized from the local to the global level with the cooperation of "
                "various institutions including Indian Acupressure Yoga Council, "
                "Scientific Institute of Alternative Medicine, National Institute of "
                "Acupressure Research Training and Treatment, International Naturopathy "
                "Organization, and many others.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "World Reflexology Week aims at a healthier world. During this week, "
                "free workshops are organized at the local level and a 2nd National "
                "Conference and Award Presentation Ceremony will be held in Mumbai. "
                "Senior practitioners will be felicitated and research work will be "
                "presented by experts from across the country will present their research work. On this occasion, practitioners with more than three years of experience will be felicitated. Practitioners will participate in the ceremony and expand their knowledge.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 10),

          const Text(
            "An exhibition will also be organized. A national-level committee has been formed for all these programs. The Indian Board of Alternative Medicine is the main organizer.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 10),

          const Text(
            "It is being organized in the last week of September through the International Reflexology Conference. Awareness campaigns are being conducted through this week. Through the Acupressure Training & Research Center, Acupressure Research, Training and Treatment Institute, Allahabad, Indian Board of Alternative Medicine, Kolkata, Indian Institute of Holistic Science, All India Association of Acupressure Reflexology, Delhi, Dr. Suresh Agarwal, President of Kolkata, Dr. P. B. Lohia, President of the Indian Institute of Holistic Science, Dr. Sarvadev Prasad Gupta, President of the Indian Acupressure Yoga Council, Dr. of the All India Association of Acupressure Reflexology, Delhi, This entire program is being organized under the guidance of Kusum Agarwal, Anant Biradar, President of the International Naturopathy Organization, and others.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 20),

          const Text(
            "What is Reflexology Acupressure Therapy?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Reflexology Acupressure means, Acu means sharp, Pressure means "
                "pressure, and Reflex means reflection. The method of treating by "
                "applying special pressure to the reflection centers of the body’s "
                "organs, which are located on the hands, feet, ears, and face, is "
                "called Reflexology Acupressure.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          /// 🏥 Free Mega Campaign Section
          const SizedBox(height: 20),

          const Text(
            "Free Mega Campaign",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          const Text(
            "The Seva Week Camp will continue from September 19th to 25th, "
                "patients will be examined at the free treatment camp. The incredible "
                "importance of Indian medical system Reflexology in a healthy life.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "Aurangabad, September 19th. Two hours of free service daily to "
                "commemorate World Reflexology Week, a free treatment camp was "
                "inaugurated today by the Acupressure Training and Research Center.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "The camp was inaugurated by Lokmat Editor-in-Chief Rajendra Babuji "
                "Darda at the Gajanan Maharaj Temple Trust's Gajanan Maharaj Bhavan. "
                "Prominent attendees included MLA Prashant Bamba, Paras Ostwal of the "
                "Lions Club of Aurangabad Royal, Secretary Vishal Dargad, President of "
                "the Gajanan Maharaj Temple Trust, and JR Anil Jain, Inventor of JIN "
                "Reflexology and President of the Acupressure Training and Research Center.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "The guests unanimously declared that for the next seven days, "
                "60 therapists will provide free treatment for two hours daily at "
                "forty centers across the city. This free medical campaign will "
                "conclude in Mumbai on September 25th.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "Rajendra Darda stated that this is a type of natural medicine. Acupressure originated in India. This treatment method existed in India thousands of years ago. People like Anil Jain are promoting this treatment method in India. Darda said that if the tongue is controlled, all the nerves of the body can be controlled.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),

          const Text(
            "MLA Prashant Bamba said that health, finances, society, and family are important in human life, but 75 percent of life is spent on accumulating wealth, which is causing health to deteriorate. Acupressure is changing lifestyles. He urged people to use what is taught at this camp for public service.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 12),
          const Text(
            "Shridhar Chakte said that we are lagging behind in acupressure therapy. This camp will help make the therapy accessible to the common man. Shashikant Gorwadkar explained the importance of reflexology. In his introduction to the camp, Anil Jain stated that acupressure is an art of living. More research is needed in this method of treatment. 25,000 therapists will participate during this week. Millions of people across the country have benefited from acupressure therapy to live a healthy life.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 12),

          const Text(
            "in all over India started from. Aurangabad On Monday, September 19th Inaugurate MLA Prashant Bamba, Shridhar Vakte, President Acupressure Training Center and Convener JR Anil Jain, therapists, and officials of the Lions Club of Aurangabad Royal were present at the inauguration of the free treatment megacamp organized by the Acupressure Training and Research Center on the occasion of World Reflexology Week in Aurangabad on Monday. On this occasion, guests present honored Prabha Desarda.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 12),
          const Text(
            "Lalit Gandhi, Vikas Patni, Anand Duggar, Rahul Sancheti, Hemant Khinvsara, Nilesh Kankaria. Mulka",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const Text(
            "Duggar successfully moderated the stage. Finally, JR Anil Jain expressed his gratitude.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          /// 🖼️
          const Text(
            "World Reflexology Week Opening Ceremony at Chhatrapati Sambhajinagar, Maharashtra",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

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

          Text(
            "Promoting Alternative Medicine is Essential",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12),

          Text(
            "Aurangabad | September 26. Lokmat Seva – Maharashtra’s Minister of "
                "State for Home, Finance and Planning, Deepak Kesarkar, said that "
                "efforts will be made to promote alternative medicine systems like "
                "Yoga. This will enable more and more people to learn about its "
                "benefits.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "He was addressing the Second All India Conference held in Mumbai on "
                "Sunday on the conclusion of World Reflexology Week. Presiding over "
                "the program, he congratulated the organizers for the successful "
                "organization of Reflexology Week.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "It is noteworthy that an awareness campaign was conducted across "
                "the country through all the institutions associated with these "
                "medical systems. Lokmat was the Media Partner for this entire "
                "event – World Reflexology Week.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 16),

          Text(
            "2nd National Conference & Awards Presentation Ceremony",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Text(
            "in Presidentship of Maharashtra’s Minister of State for Home, Finance and Planning, Deepak Kesarkar, Shrikant Ji Shinde ( M.P.), Convenor JR Anil Jain, Inventor of JIN Reflexology addressing the program held in Mumbai on Sunday. Present on the stage were Prof. P. Lohia from Aurangabad, Sarvadevprasad Gupta Patna, Kusum Agarwal Delhi. In the second picture, experts from various parts of the country. etc. This will also maintain their dignity.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 16),

          Text(
            "Organized By Acupressure Training & Research Centre",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Text(
            "The ‘Lokmat Group’ played a significant role. Under the week-long program held from September 19 to 25, more than 25,000 doctors from all corners of the country provided services for 2 hours daily. During this time, millions of patients benefited from it. Experts who treat with these medical methods were also honored at the program. A large number of experts from all therapies.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "were present at the program. Kesarkar, while giving suggestions on this occasion, said that instead of writing ‘Doctor’ before their name, every person providing treatment should write the therapy in which they have specialized. For example, Sujok Therapy Specialist, Reflexologist.  For A Healthier World",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "Present as a guest at the conference Lok Sabha member Shrikant Shinde said that doctors should not pressure patients to receive treatment only from a particular medical system. Rather, if the patient is not benefiting from a particular medical system, they should not be kept in the dark and should be immediately referred to another doctor. This will maintain the authenticity of the profession. Program convenor Anil Jain gave detailed information about the week and the conference. In the context of Minister Kesarkar’s suggestion, he said that all JIN Reflexologists",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),
          Text(
            "will write JR Therapist instead of Doctor before their name. He said that even after seven days of treatment, if the patient does not benefit from their therapy, they are advised to go to another doctor without being kept in the dark. The success rate of this treatment method is up to 80 percent. He informed that the International Council of Reflexology had started the service week in the second half of September to create awareness about this medical system. JR Manju Thole The program began with a prayer. Mukta Duggar was the host. Nilesh Kankaria, Anand Duggar, Vikas Patni, Vivek Bagrecha, Kishore Chaudhary (Mumbai), and Rajendra Tondapurkar contributed to the success of the program.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const Text(
            "2nd National Conference and Award Presentation Ceremony at Mumbai, Maharashtra",

            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 25),

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
          Text(
            "Health Awareness & Life Changing Seminars Change Lifestyle to Enjoy Life – JR Anil Jain’s Appeal",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12),

          Text(
            "Our lifestyle should be in harmony with nature. In today’s hectic life, "
                "despite running around a lot, we face stress and depression. To avoid that, "
                "we can benefit from a happy life by changing our daily routine a little, "
                "asserted JR Anil Jain, Inventor of JIN Reflexology.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "JR Anil Jain speaking at a seminar. It is intended to implement new "
                "initiatives in the future that will be beneficial to the social and "
                "educational sectors.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "JR Anil Jain further said that our ancestors believed in early to bed and "
                "early to rise for good health. Waking up before sunrise, sleeping for "
                "six to eight hours, and taking short rest breaks during the day help "
                "maintain a healthy body and mind. In today’s computer age, people spend "
                "long hours in air-conditioned rooms.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "It is a situation where the body of highly educated people who sit still does not get any sun. One must walk barefoot on the ground or on the grass for some time every day. Being in the open air allows one to get plenty of oxygen. Light exercises and yoga should be done regularly. There is no need to go to the gym and strain oneself. While relaxing at home, one should watch only humorous and funny series. Watching series with fights and tension creates unnecessary mental stress and adversely affects our lifestyle. Our life is precious.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 12),

          Text(
            "Moments do not come back. Always be happy, smiling, and cheerful. "
                "Be careful that no one is hurt by your behavior. Spread happiness without "
                "causing trouble. Positive thinking changes lifestyle and doubles the joy "
                "of living, said JR Anil Jain.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 16),

          Text(
            "JR Anil Jain has told us through various examples how important it is to change our lifestyle for good health. If we try to change accordingly, we can enjoy life.",
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 20),

          /// 🔹 Heading
          const Text(
            'Life is precious, health plays an important role: JR Anil Jain',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          /// 🔹 Paragraph
          const Text(
            'A workshop was organized in Senior Citizen Bhawan by Giants '
                'International, Lions International, Mahavir International in '
                'collaboration with Senior Citizen Forum to control uncontrolled '
                'lifestyle and make people aware about health. The main speakers '
                'were JR Anil Jain, Inventor of JN Reflexology and JR Shilpa Jain '
                'who came from Maharashtra.\n\n'
                'They said life is precious and health plays the most important role '
                'in it. If we want to live a happy life then it is very important '
                'for us to be aware about our health. JR Anil Jain gave information '
                'about various types of videos through reflexology technology. '
                'He also made available on mobile and information was also provided '
                'about the negative impacts of television on our daily lives.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),

          const SizedBox(height: 30),

          /// 🔹 Sub Heading
          const Text(
            'Other Glimpses of India’s Biggest Health Awareness Campaign – 2016',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}