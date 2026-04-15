import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/health_campaign_pdf_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2017Screen extends StatefulWidget {
  const Wrw2017Screen({super.key});

  @override
  State<Wrw2017Screen> createState() => _Wrw2017ScreenState();

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

class _Wrw2017ScreenState extends State<Wrw2017Screen> {
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

          const Text(
            "3rd National Conferences and Award Presentaion Ceremony - Mumbai - JR Anil Jain",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),

          SizedBox(height: 20,),

          Container(height: 200, width: double.infinity, color: Colors.grey),

          SizedBox(height: 20,),

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
                    "International Reflexology Week begins two-hour free service every day across the india",
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
              "Lokmat News –  Aurangabad, September 18. Los Seva",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),

            const SizedBox(height: 10),

            const Text(
              "International Reflexology Week is celebrated nationwide as a "
                  "free medical extravaganza. Organized by the Acupressure Training "
                  "and Research Center and the Nature Care Therapist Association, "
                  "the week was inaugurated on Monday at the Gajanan Hall at the "
                  "Gajanan Maharaj Temple. As part of this campaign, all therapists "
                  "at 33 centers across the city will provide free medical services "
                  "for two hours each day.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "This massive campaign was launched two years ago under the "
                  "guidance of Lokmat Editor-in-Chief Rajendra Darda. Under the "
                  "leadership of leading institutions across the country, "
                  "acupressure, Sujok, Shiatsu, reflexology, and JIN Reflexology "
                  "have been promoted and practiced widely.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "MLA Atul Save receives treatment at the inauguration of the "
                  "International Reflexology Week in Aurangabad on Monday. "
                  "Also seen are JR Anil Jain, Prabha Desarda, Manju Thole, "
                  "Harshali Sancheti, Dr. Jayshree Mag, and others.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "With the help of practitioners of medical systems like "
                  "reflexology, this campaign will continue across the country "
                  "until September 24. MLA Atul Save, President of the Lions Club "
                  "of Aurangabad Royal, inaugurated this free service week. "
                  "Omprakash Agarwal, Manoj Bora, Paras Ostwal, Lalit Gandhi "
                  "and convener JR Anil Jain were prominently present. "
                  "MLA Atul Save said that many people suffer side effects "
                  "from medicines and that reflexology and acupressure "
                  "treatments prove to be crucial. He urged the city’s citizens "
                  "to take advantage of this week. JR Anil Jain stated that "
                  "these treatments prove to be important for leading a "
                  "drug-free life.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Specific pressure is applied to the body’s reflex centers, "
                  "including the hands, feet, ears, and face. This treatment "
                  "technique has also become popular abroad. It should be "
                  "adopted as a form of primary care.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "A large number of doctors, including Nilesh Kankaria, Vikas "
                  "Patni, Anand Duggad, Prabha Desarda, Manoj Bakliwal, and others, "
                  "were present at the event. Following the inauguration, many "
                  "people received treatment. A national committee has been "
                  "established to conduct the free medical campaign. The entire "
                  "program was organized under the guidance of Dr. P.B. Lohia, "
                  "Dr. Anant Biradar, Dr. Sarvdev Gupta, and Dr. Kusum Agarwal. "
                  "Lokmat News is the media partner for the event. JIN Reflexology "
                  "and the Lions Club of Aurangabad Royal have provided support "
                  "for the event.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),

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
                    "International Reflexology Week Concludes in Mumbai - Resolution for a drug free, healthy life by 2030",
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
              "Third National Conference held on September 24, 2017, as part of "
                  "the World Reflexology Week recently held in Dadar, Mumbai.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The national conference was organized by JR Anil Jain, Inventor "
                  "of JIN Reflexology on behalf of the Aurangabad Acupressure "
                  "Training and Research Centre. The chief guests included "
                  "Dr. P.B. Lohia, Dr. Jagannath Hegde, Farmer Sharif Nagar Palika "
                  "member Anant Biradar, INO National President C.C.R.Y.N. Working "
                  "Group Member of the Ministry of AYUSH, Government of India, "
                  "Suresh Jain, Convener of Patanjali Yoga Peeth Mumbai, Social "
                  "Worker Dr. Jagmohan Sachdev, Senior Acupressure Therapist "
                  "Dr. Sahadev Prasad Gupta, President of Acupressure Yoga College "
                  "of Bihar, and many others from various districts of different "
                  "states of India.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Lokmat News Network Mumbai: Acupressure and JIN Reflexology.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "There is a need to promote drug-free and side-effect-free "
                  "treatment methods like JIN Reflexology and Shiatsu. These "
                  "methods are our ancient heritage, and by using them a person "
                  "not only stays healthy but also lives a long life, said former "
                  "Mumbai Mayor Dr. Jagannath G. Hegde. He was speaking at the "
                  "Third All India Conference in Mumbai on the occasion of "
                  "International Reflexology Week. The resolution of a drug-free "
                  "healthy life by 2030 was highlighted on this occasion.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "A nationwide awareness campaign was conducted through all the "
                  "organizations related to this treatment method. Lokmat Group "
                  "played the role of media partner in this entire event.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "During this week, which lasted from September 18 to 24, more "
                  "than 15,000 health workers across the country provided free "
                  "services for two hours every day. Lakhs of patients benefited "
                  "from this. Inventor JR Anil Jain said that research is underway "
                  "in JIN Reflexology and that the JIN Reflexology app has been "
                  "created using modern technology.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Suresh Yadav, head of Patanjali University, Maharashtra, "
                  "explained the features of this treatment method.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Dr. Anant Biradar, President of the International Association "
                  "of Naturopathy, gave information about the efforts being made "
                  "by the Indian government in the field of natural healing. "
                  "Entrepreneur and social activist Suresh Jain (Mumbai) was also "
                  "present on this occasion.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Those who have made significant contributions to the field of "
                  "acupressure treatment for more than twenty years were honored "
                  "with the ‘Acupressure Icon of India’ award. Prof. Dr. P. B. "
                  "Lohia, Dr. Anant G. Biradar and Dr. Navinchandra Shah "
                  "(posthumously) were honored.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "To make the program a success, the organizers J. R. Anil Jain "
                  "and co-organizers Dilip Urankar, Nilesh Kankaria (Surat), "
                  "Santosh Pandey (Mumbai), Chandrakant Bhabhera (Mumbai), "
                  "Manoj Bora, Lalit Gandhi, and Prabha Desarda (Aurangabad) "
                  "worked hard.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Media Partner – Maharashtra’s No. 1 daily newspaper.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
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
                    "JR Anil Jain: Response to Self-Treatment Workshop JIN Reflexology india Remedies",
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
              "Lokmat News – Nashik: The Indian way of life is a good treatment "
                  "method; however, with the changing times, as the Western lifestyle "
                  "is being adopted more and more, citizens are facing various "
                  "diseases. Acupressure is a self-healing method that involves "
                  "applying pressure on various parts of the body, said JR Anil Jain, "
                  "Inventor of JIN Reflexology in the JIN Reflexology self-treatment "
                  "training program.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "A two-day ‘Self Treatment Training Program’ workshop organized for "
                  "Lokmat Sakhi Manch and family at Ichchamani Lawns and Shri Krishna "
                  "Banquet Hall in Upnagar received a spontaneous response.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Lokmat Sakhi Manch members greatly benefited. A wonderful "
                  "opportunity to learn JIN Reflexology Acupressure Treatment was "
                  "available on this occasion. Both the sessions were attended by a "
                  "large number of Sakhi Manch members and their families.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Through the audio-visual system, the citizens tried to learn about "
                  "the medical system from the trainer and assistant specialist "
                  "JR Anil Jain. At the beginning of the workshop, JR Anil Jain "
                  "recited the prayer ‘Bhavna Din Raat Meri, Sab Sukhi Sansar Ki’. "
                  "While guiding, Jain said that although acupuncture is known today "
                  "as a Chinese treatment method, the original source of this "
                  "treatment method is India.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Science is hidden in the various practices of the Indian way of "
                  "life; however, he expressed regret that no attempt has been made "
                  "to learn this science. To increase vitality and enthusiasm, one "
                  "should press the toes of both feet.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "To stay stress-free, wash your face, hands and feet immediately "
                  "after coming from outside so that negative thoughts and energy do "
                  "not affect you. Walk barefoot for some time in the morning or "
                  "evening, as this puts pressure on the reflex points on the soles "
                  "of the feet and helps maintain good health, said JR Anil Jain.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "He initially introduced the information and functions of the "
                  "body’s organs in simple language. Guidance was also given on "
                  "what to eat and how to eat.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "On the second day of the workshop, demonstrations were given on "
                  "how to press the points of the body’s organs, especially the "
                  "hands and feet, while treating various diseases.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),
          ],

          SizedBox(height: 20),

          Container(height: 200, width: double.infinity, color: Colors.grey),

          SizedBox(height: 20),

          const Text(
            "3rd National Conferences and Award Presentaion Ceremony - Mumbai - JR Anil Jain",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),

          SizedBox(height: 20),

          Container(height: 200, width: double.infinity, color: Colors.grey),

          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "2017 Glimpses PDF",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 560,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const CampaignPdfViewer(year: 2017),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "WRW - 2017"),
    
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Purple Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF6A3EB5),
              child: const Text(
                "World Reflexology Week - 18th September to 24th September , 2017   ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Wrw2017Screen.buildRow("Convenor", "JR Anil Jain"),

            Wrw2017Screen.buildRow(
              "Advisory Member",
              "Prof. P.B. Lohiya, Dr. Anant Biradar, Dr. Sarvdeo Prasad Gupta",
            ),

            Wrw2017Screen.sectionTitle(
              "WRW Inaugural Function - World Reflexology Week Nationwide Free Treatment Mega Event -",
            ),

            Wrw2017Screen.buildRow("Date", "18th September 2017"),

            Wrw2017Screen.buildRow(
              "Guest",
              "Hon. Rajendra Babuji Darda (Editor in Chief, Lokmat)",
            ),

            Wrw2017Screen.buildRow("City", "Aurangabad, Maharashtra, India"),

            Wrw2017Screen.buildRow(
              "Organizer",
              "International Reflexology JIN Association",
            ),

            Wrw2017Screen.sectionTitle(
              "WRW Concluding Function - 3rd National Conference and Award Presentation Ceremony - 2017",
            ),

            Wrw2017Screen.buildRow("Date", "24th September 2017"),

            Wrw2017Screen.buildRow(
              "Guest",
              "Hon'ble Dr. Jagan Nath Hegde, Shri Suresh Jain, Shri Suresh Patil",
            ),

            Wrw2017Screen.buildRow("City", "Aurangabad, Maharashtra, India"),

            Wrw2017Screen.buildRow(
              "Organizer",
              "International Reflexology JIN Association",
            ),

            Wrw2017Screen.buildRow(
              "Supported",
              "JIN Reflexology, Jain Chumbak",
            ),

            Wrw2017Screen.buildRow(
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
