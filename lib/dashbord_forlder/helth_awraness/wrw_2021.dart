import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2021Screen extends StatefulWidget {
  const Wrw2021Screen({super.key});

  @override
  State<Wrw2021Screen> createState() => _Wrw2021ScreenState();
}

class _Wrw2021ScreenState extends State<Wrw2021Screen> {
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Health Awareness – 2021"),
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
        
                /// 🔹 Expandable Article Title
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
                          "21 Days Yoga Camp Begins Today",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                /// 🔹 Expanded Content
                if (isExpanded1) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "You will benefit from guidance, lectures, and discussion sessions. Aurangabad,",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
        
                  const SizedBox(height: 12),
        
                  Text("May 31. Lokmat Samachar Seva",style: TextStyle(fontSize: 16,height: 1.6),),
        
                  const SizedBox(height: 12),
                  const Text(
                    "As in previous years, a 21-day free yoga camp is set to begin tomorrow, "
                    "June 1st, in an effort to boost broken morale and improve health. "
                    "In this camp, guidance lectures and discussion sessions will provide information on yoga.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "The camp was organised under the joint aegis of International Reflexology Jain Association, "
                    "Aurangabad District Automobile and Tyre Dealers Association and Mahavir "
                    "International Metro City from 1st June Jain Reflexology Day to 21st June.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  Text("Kidney patient gets new life in 30 days", textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.6)),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "I, Deependra Singh, am from House No. 240, Street No. 37, PT-II, "
                    "Kaushik Enclave, Burari, North Delhi-110084. Despite numerous kidney treatments,  "
                    "there was no improvement. However, after listening to Dr. Dassan on YouTube,"
                    "I started treatment and my kidneys recovered within just one month.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  Text("Will continue till International Yoga Day.", textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.6)),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "The camp was inaugurated online on Monday at 3 p.m. The camp "
                    "was launched in the august presence of Rajendra Darda, President of the Sakal Jain Samaj, "
                    "Shanti Kumar Jain, International President of Mahavir International, Anil Jain, International General "
                    "Secretary, and Mansingh Pawar, former President of the Maharashtra Chamber of Commerce. Speaking at "
                    "the inauguration, Sakal Jain Samaj President Darda said that physical and mental well-being is essential. ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "Rajkumar Banthia- people Program President Rajendra Darda, JR Anil Jain Jain, "
                    "Inventor of JIN Reflexology, etc. in the inauguration program of Yoga Camp organized "
                    "by International Reflexology Jain Association in Aurangabad on Monday.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  Text("outline of camp organization", textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.6)),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "During the Yoga Festival, there will be practical yoga sessions every day from 7:00 AM to 7:40 PM. "
                    "Yoga expert Manju Thole, director of Fit Way, will guide the participants. "
                    "Five relevant questions will be asked each day. The top three winners will be honored. "
                    "From 7:40 PM to 8:00 PM, experts on various subjects will conduct online discussions. "
                    " The sessions will be broadcast live on YouTube and Facebook.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
        
                  SizedBox(height: 12),
        
                  const Text(
                    "This is a good thing for those in distress. Shantilal Jain, International President of Mahavir International, "
                    "said that it is best to make yoga a part of your lifestyle. He added that he "
                    " himself is a yoga and They do Pranayam, which keeps their mental and physical fatigue away. "
                    "India’s biggest health awareness campaign convener JR Anil Jain, Inventor of JIN Reflexology, "
                    " said that this multipurpose program is being organized for the second consecutive "
                    "year in the circumstances of Corona epidemic. He said that those who complete the 21-day camp in the "
                    "event will be rewarded by Lokmat Group and Ratnaprabha Motors. Coordinator Jain, "
                    "co-ordinator Rajkumar Jain, President of Aurangabad District Automobile and Tyre Dealer Association "
                    "Santosh Kawale, President of Mahavir International Metro City Naresh Bothra "
                    "appealed to take maximum benefit of the program.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
        
                const SizedBox(height: 20),
        
                /// 🔹 Second Title
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
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "India's Biggest Health Awareness Campaign Free Online Yoga & Interaction Camp",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E75B6), // Blue like screenshot
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                if (isExpanded2) ...[
                  const SizedBox(height: 16),
        
                  const Center(
                    child: Text(
                      "1st June (JIN Reflexology Day) to 21st June (International Yoga Day)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Organized by – International Reflexology JIN Association, Aurangabad District Automobiles "
                    "Tire Dealers Association, Mahavir International Metro City, Aurangabad, Fit Way."
                    "The 21-day free online yoga camp organized by the International Reflexology JIN Association concluded today.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Lokmat Editor-in-Chief Rajendra Darda felicitates the organizers of a free yoga camp at Lokmat Bhavan "
                        "in Aurangabad on Monday. Present on the occasion are, from left, Santosh Kawale, "
                    "Manju Thole, Yatin Thole, convener – JR Anil Jain, Inventor of JIN Reflexology, Rajkumar Banthia, and Naresh Bothra.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The camp, held on June 1st, JIN Reflexology Day, was supported by the Aurangabad District "
                        "Automobile and Tire Dealers Association and Mahavir International Metro City. ",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Rajendra Darda, Editor-in-Chief of Lokmat, presented the ceremony. He honored Manju Thole, "
                        "Yoga instructor and director of Fit Way, and Yatin Thole, Editor, with a shawl. "
                        "Mega event convener and International Reflexology Jain Association president JR Anil Jain was honored with a book."
                    "Co-ordinator Rajkumar Jain Banthia, President of the Aurangabad District Automobile and Tire Dealer Association"
                    "Santosh Kawale, and Mahavir International Metro presented the ceremony.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Representatives of the three organizations jointly honored Rajendra Darda on this occasion. "
                        "The program was broadcast live on YouTube and Facebook. During this yoga festival, "
                        "practical yoga sessions were held daily from 7:00 AM to 7:40 PM. Fit Way director and "
                        "yoga expert Manju Thole provided daily guidance. Similarly, experts on various subjects "
                        "held sessions from 7:40 AM to 8:00 PM.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
        
                  const SizedBox(height: 20),
        
                ],
        
                const SizedBox(height: 12),
        
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
                          isExpanded3 ? Icons.remove : Icons.add,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "National and International Online Gathering Organized for International Reflexology Week Conclude",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E75B6), // Blue like screenshot
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        
                if (isExpanded3) ...[
                  const SizedBox(height: 16),
        
                  Text(
                    "World Reflexology Week 20th to 26th September 2021 Reflexology For Everybody International Reflexology Jain Association",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "JR Shilpa Jain conducting the programme, on the stage from left are Prof. Praveen Vakte, "
                        "JR Anil Jain, Inventor of JIN Reflexology, Prof. Purushottam Lohia, Dr. Md. "
                        "Furkan Amer, in the second picture are JR Sapna Gandhi, JR Anuprita Gandhi, Priyanka Badjate, JR Monica Kathed offering prayers.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Drug-free acupressure, reflexology, sujok, shiatsu, JIN reflexology, reiki, mudra therapy, neuro therapy, etc. "
                        "organized at the conclusion of International Reflexology Week",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The seventh national and second International online meeting of doctors of medical systems was concluded.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "In his introduction, convener JR Anil Jain Inventor of JIN Reflexology stated that working with clinical "
                        "data management could revolutionize the medical field. This year, we also organized "
                        "a continuous online yoga camp and discussion session from JIN Reflexology Day (June 1st) to International "
                        "Yoga Day (June 21st). The session was chaired by Prof. Dr. Praveen Vakte, Pro-Vice Chancellor, "
                        "Dr. Babasaheb Ambedkar Marathwada University, Aurangabad, and Dr. Md. Furqan Amer, Principal, DKMM.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Dr. Praveen, who was present as the chief guest at the Homeopathy Hospital and Medical College, "
                    "said that like developed countries, we too need to work on preventive health.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "This time, on the first day, prominent doctors like Dr. Sarvdev Prasad Gupta, Ajay Prakash Gupta, "
                        "Patna, Dr. Reshma Suryavanshi, Vadodara, Dr. Sudhir Khetawat, Indore, "
                        "Dr. Yogesh Kodakani, Mumbai etc. presented their presentations in the national assembly. On the second day, "
                        "in the international assembly, President of International Council of Reflexologists, Carol Fugi, England gave a congratulatory message and "
                        "appreciated the work of the organization, Prof. Praveen Vakte spoke on Reflexology in the World, "
                    "Prof. Dr. P. B. Lohia on Rest and Ankle Acupuncture, Dr. Cyril Antony, Member of the Board of Governors and Head of the Education "
                    "Committee of the Reflexology Council, on the Role of Reflexology in Covid-19, Dr. Arv Falvik, Norway on The Body as a Hologram, "
                    "Dr. Jyoti Kumbhar, Pune, Medical Officer of National Institute of Naturopathy, Henrik Bergmans, Acupressure, Belgium "
                    "presented on Stress and Trauma Sensitive Reflexology, Murcio Kru Chik, Israel presented on Reflexology for the Treatment of Pain.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The “Mega Event of Free Treatment” campaign was celebrated with great enthusiasm by all physicians "
                        "offering drug-free treatment across the country from September 20th to 26th. "
                    "The organization awarded certificates to all physicians who participated in the campaign.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Doctors who have not received the certificate should send their photo while providing service on the link given below.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "The convener and all the office bearers heartily congratulated Shri Rajendra Babuji Darda and all the editors "
                    "for providing important service as Lokmat Media Partner and guide in making "
                    "these side effect free medical methods reach the common people.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
                  const SizedBox(height: 16),
        
                  const Text(
                    "Organized by the International Jain Reflexology Association, the entire executive committee, including Convener JR Anil Jain, "
                        "Dr. Antony Cyril, Dr. Lohia, Director Anupama Gandhi, Balasaheb Joshi, and Mrs. Prabha Desarda, played a key role in making "
                        "this gathering a success. The program was successfully hosted by JR Shilpa Jain of Aurangabad. "
                    "broadcast on Facebook, YouTube, and the web page www.jinreflexology.in",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
        
        
        
        
                  const SizedBox(height: 20),
        
                ],
        
        
        
                const SizedBox(height: 20),
        
                /// 🔹 Large Image Placeholder
                buildGreyBox(height: 400),
        
                const SizedBox(height: 16),
        
                Center(
                  child: const Text(
                    "Online Interaction and Yoga Camp live on Facebook. Info slide.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
        
                const SizedBox(height: 16),
        
                buildGreyBox(height: 400),
        
                const SizedBox(height: 16),
        
                /// 🔹 Grid Section
                buildGrid(),
        
                const SizedBox(height: 16),
        
                buildGreyBox(height: 200),
        
                const SizedBox(height: 12),
        
                buildGrid(),
        
                const SizedBox(height: 12),
        
                const Text(
                  "World Reflexology Work Event – 2nd International Conference – 2021 – Convener – JR Anil Jain",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        
                const SizedBox(height: 12),
        
                buildGreyBox(height: 200),
        
                const SizedBox(height: 12),
        
                const Text(
                  "World Reflexology Work Event – 7th National Conference – 2021 – Convener – JR Anil Jain",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        
                const SizedBox(height: 12),
        
                buildGreyBox(height: 200),
        
                const SizedBox(height: 12),
        
                const Text(
                  "Glimpses Of Other Health Awareness Campaign – 2021 – Convener – JR Anil Jain",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Simple + Title Row
  Widget buildSimpleTitle(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.add, size: 18, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Grey Placeholder Box
  Widget buildGreyBox({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade400,
    );
  }

  /// 🔹 Grid Builder
  Widget buildGrid() {
    return GridView.builder(
      itemCount: 21,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return Container(color: Colors.grey.shade400);
      },
    );
  }
}
