import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2019Screen extends StatefulWidget {
  const Wrw2019Screen({super.key});

  @override
  State<Wrw2019Screen> createState() => _Wrw2019ScreenState();

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

class _Wrw2019ScreenState extends State<Wrw2019Screen> {
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
                    "ICR hosting World Reflexology Week - 2019 - Opportunity of treatment through unique therapy",
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
              "World Reflexology Week countrywide launching from Mumbai.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The countrywide free service week will be inaugurated on "
                  "22 September by Hon’ble Rajendra Darda, Editor-in-Chief "
                  "of the Lokmat Group, from Mumbai.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Reflexology: Caring for the body by tending to the feet.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Pressure on certain reflex points helps the corresponding "
                  "organs of the body function more normally and also helps "
                  "to decrease pain. This practice has come to be known as "
                  "reflexology, an approach to holistic health that many "
                  "people have adopted over the years.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "5th National Conference will be organized in Bengaluru, Karnataka.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "This time, on the concluding day of World Reflexology Week, "
                  "the 5th National Conference will be organized in Bengaluru. "
                  "Therapists from fields such as Acupressure, Reflexology, "
                  "Sujok, JIN Reflexology, Shiatsu, Reiki, Neurotherapy and "
                  "other non-medicine therapy systems will participate.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "On this occasion, International Council of Reflexology "
                  "Director Member and Chairperson of the Education Committee "
                  "Dr. Cyril Antony will address the gathering.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Leading therapists from across the country will present "
                  "their research and investigative work.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Participating in the conference will be a golden opportunity "
                  "for service and will also enhance the knowledge of therapists "
                  "coming from different parts of the country. Therapists who "
                  "have been providing treatment for more than three years will "
                  "also be honored on this occasion.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The International Council of Reflexology (ICR) has announced "
                  "the celebration of World Reflexology Week from September 23 "
                  "to 29, 2019. This week will be celebrated as a grand health "
                  "event providing free treatment by experts throughout the week.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The drive is being held in association with leading health "
                  "organizations in the country, where expert therapists will "
                  "conduct free health check-ups for two hours every day "
                  "during the week.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The drive is being initiated under the guidance of Lokmat’s "
                  "Editor-in-Chief Shri Rajendra Babuji Darda with the objective "
                  "of creating awareness about reflexology among the common people.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Convener JR Anil Jain, Inventor of JIN Reflexology, said that "
                  "the development of the Indian lifestyle has gained awareness "
                  "from the local level to the global level in terms of reflexology.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "For the last four years in India, this drive has been conducted "
                  "jointly by the Acupressure Training and Research Centre and "
                  "Nature Care Organization in association with institutions such "
                  "as the Indian Institute of Holistic Science, International "
                  "Naturopathy Organization, All India Association of Acupressure "
                  "Reflexology, Bharatiya Acupressure Yoga Parishad, Bihar "
                  "Acupressure Yoga College, Scientific Institute of Alternative "
                  "Medicine & Paramedical Science Council, Vishv Chaitanya "
                  "Acupressure Therapy Foundation and Heritage Foundation.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "A national-level committee has been formed for the successful "
                  "implementation of this drive. The committee includes Prof. "
                  "Purushottam Lohiya (President, Indian Institute of Holistic "
                  "Science), Shri Anant Biradar (President, International "
                  "Naturopathy Organization), Dr. Sarvdeo Prasad Gupta "
                  "(President, Bharatiya Yoga Parishad), Shri Ashok Kothari "
                  "(Vice-President, International Sujok Association), and "
                  "Co-convener Dr. Dilip Urankar. JR Anil Jain is the convener "
                  "of the program.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "More information can be obtained from the website "
                  "www.jinreflexology.in",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 12),

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
                    "International Reflexology Week Concludes in Bangalore With a Commitement to Research Activities",
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
              "JR Anil Jain, Inventor of JIN Reflexology, Dr. Dilip Urankar, "
                  "Dr. Cyril Antony from Sri Lanka, a member of the International "
                  "Reflexology Council’s governing board and head of the education "
                  "committee, Dr. H. Bhojraj, Dr. Nilesh, and Dr. Reshma Suryavanshi "
                  "energized the assembly through clapping therapy. The second "
                  "picture shows doctors providing free treatment in Jalandhar "
                  "(Punjab) during International Reflexology Week.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Formation of the International Reflexology JIN Association: "
                  "To promote and accelerate research in the JIN Reflexology "
                  "system of medicine globally, the International Reflexology "
                  "JIN Association was also formed on this occasion by "
                  "Dr. Cyril Antony from Sri Lanka.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The fifth All India Conference of practitioners of drug-free "
                  "therapies such as Acupressure, Reflexology, Sujok, Shiatsu, "
                  "JIN Reflexology, Reiki, Mudra Therapy, Neuro Therapy, etc., "
                  "was held in Bangalore at the conclusion of International "
                  "Reflexology Week.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The conference began with a prayer led by JR Shilpa Jain "
                  "and JR Preeti Desarda.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "In his introductory remarks, the convener JR Anil Jain said "
                  "that the objective is not only to preserve India’s ancient "
                  "medical systems but also to bring their scientific perspective "
                  "to the forefront so that they can reach every person. In this "
                  "regard, Acupressure, a developed form of the Indian way of "
                  "life, has been presented as JIN Reflexology. It can treat "
                  "diseases and help diagnose problems in various parts of the "
                  "body without the use of machines.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Following the Indian government’s Digital India initiative, "
                  "this system facilitates easy collection of complete patient "
                  "data through the JIN Reflexology app. Patients receive "
                  "information about their diagnosis and dietary restrictions "
                  "through the app, and this information can also be printed "
                  "if required.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Dr. Cyril Antony, a member of the International Reflexology "
                  "Council’s governing board and head of the education committee, "
                  "informed the attendees about the council’s work in the field "
                  "of reflexology worldwide and highlighted future plans to "
                  "expand into the corporate sector. He also appreciated the "
                  "free medical camp campaign being conducted across India "
                  "under the leadership of convener JR Anil Jain and honored "
                  "him with a special award.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Leading doctors from across the country presented their "
                  "research work, mainly focusing on acupuncture, acupressure, "
                  "Jain reflexology, home therapy, and magnet therapy. "
                  "Dr. H. Bhojraj, Dr. Dilip Urankar, Dr. Reshma Suryavanshi "
                  "(Vadodara), Dr. Mona Contractor (Ahmedabad), and others "
                  "gave presentations.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "With the cooperation of practitioners of drug-free therapies, "
                  "this campaign was conducted across the country from "
                  "September 23 to 29. Thousands of doctors provided free "
                  "treatment to millions of patients through treatment and "
                  "training camps organized nationwide.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "The coordinators and doctors from across the country "
                  "expressed heartfelt gratitude to Shri Rajendra Babuji Darda "
                  "for the valuable service provided by Lokmat Media as a "
                  "media partner and guide in bringing these side-effect-free "
                  "medical systems to the common people.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Dr. Dilip Urankar, Dr. Santosh Adakul, Dr. Sharadchandra "
                  "Diwan, Dr. Avinash Songirkar, and others played a crucial "
                  "role in making this event, organized by the Acupressure "
                  "Training and Research Center, a success along with "
                  "convener JR Anil Jain, Inventor of JIN Reflexology. "
                  "The program was successfully conducted by JR Shilpa Jain "
                  "and Rikita Siyal.",
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
                    "JR Anil Jain: Spontaneous Response to 'Safe Treatment Training Program'",
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
              "Workshop: JIN Reflexology Acupressure Indian Remedies. "
                  "JR Anil Jain and participants from Amravatikar and Sakhi "
                  "Manch members participated in the two-day ‘Self Treatment "
                  "Training Program’ organized by Lokmat Sakhi Manch.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Amravati: The Indian way of life is a good treatment method; "
                  "however, with the increasing adoption of changing lifestyles, "
                  "people are facing various health problems. Acupressure is a "
                  "self-healing method that involves applying pressure to the "
                  "reflex points on various parts of the body, asserted "
                  "JR Anil Jain, Inventor of JIN Reflexology, during the "
                  "JIN Reflexology training program.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "A two-day self-treatment training program workshop organized "
                  "by Lokmat Sakhi Manch concluded at Engineer Bhavan, Shegaon "
                  "Naka Chowk, V.M.V. Road, Amravati. The workshop received a "
                  "spontaneous response from the citizens.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "This was a great opportunity for citizens to learn reflexology "
                  "and acupressure treatment. Both sessions were attended by a "
                  "large number of citizens, especially women. During the program, "
                  "participants learned about the treatment system from trainer "
                  "and assistant subject expert JR Anil Jain through a "
                  "computerized audio-visual system.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "Initially, the image of Jawaharlal Darda, the founder of "
                  "‘Lokmat’, was worshipped.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "On this occasion, the ceremonial lamp was lit by "
                  "JR Anil Jain, JR Shilpa Jain, ‘Lokmat’ DGM Sushant "
                  "Dandge, Dr. Vivek Gohad, and JR Lata Waghmare.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "JR Shilpa Jain presented the prayer ‘Bhavna Din-Raat Meri, "
                  "Sab Sukhi Sansar Ho…’ at the beginning of the workshop. "
                  "JR Anil Jain then said that although JIN Reflexology is "
                  "known today as an Indian treatment method, the benefits of "
                  "this system include accurate diagnosis and quick results.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "He explained that the original source of this treatment "
                  "method is India. Science is hidden in the various cultural "
                  "practices of the Indian way of life; however, he expressed "
                  "regret that no serious effort has been made to understand "
                  "this science.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "To increase vitality and enthusiasm, one should press the "
                  "toes of both hands. To stay stress-free, one should wash "
                  "the face and hands immediately after coming from outside "
                  "so that negative thoughts and energy do not affect the body.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            const Text(
              "JR Anil Jain, Inventor of JIN Reflexology, said that "
                  "walking barefoot for some time in the morning or evening "
                  "puts pressure on the reflex points on the soles of the "
                  "feet and helps maintain good health.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, height: 1.6, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),
          ],

          SizedBox(height: 20),

          Container(height: 200, width: double.infinity, color: Colors.grey),

          SizedBox(height: 20),

          const Text(
            "Magnet Therapy - 5th National Conference क्ष Award Presentaion Ceremony at Bengaluru-By JR Anil Jain",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.6,
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
      appBar: CommonAppBar(title: "WRW - 2019"),
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Purple Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF6A3EB5),
              child: const Text(
                "World Reflexology Week - 23th September to 29th September , 2019",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Wrw2019Screen.buildRow("Convenor", "JR Anil Jain"),

            Wrw2019Screen.buildRow(
              "Advisory Member",
              "Prof. P.B. Lohiya, Dr. Sarvdeo Prasad Gupta",
            ),

            Wrw2019Screen.sectionTitle(
              "WRW Inaugural Function - World Reflexology Week Nationwide Free Treatment Mega Event -",
            ),

            Wrw2019Screen.buildRow("Date", "22th September 2019"),

            Wrw2019Screen.buildRow(
              "Guest",
              " ",
            ),

            Wrw2019Screen.buildRow("City", "Mumbai, Maharashtra, India"),

            Wrw2019Screen.buildRow(
              "Organizer",
              "International Reflexology JIN Association",
            ),

            Wrw2019Screen.sectionTitle(
              "WRW Concluding Function - 5th National Conference and Award Presentation Ceremony - 2019",
            ),

            Wrw2019Screen.buildRow("Date", "29th September 2019"),

            Wrw2019Screen.buildRow(
              "Guest",
              "Dr. Cyril Antony, (Education Committee Member International Council of Reflexology )Shri Lanka",
            ),

            Wrw2019Screen.buildRow("City", "Banglore, Karnataka, India"),

            Wrw2019Screen.buildRow(
              "Organizer",
              "International Reflexology JIN Association",
            ),

            Wrw2019Screen.buildRow(
              "Supported",
              "JIN Reflexology, Jain Chumbak",
            ),

            Wrw2019Screen.buildRow(
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
