import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});

  // /assets/images/history_one.jpg  -> hero image (big)
  // /assets/images/history_two.jpg  -> secondary image
  // /assets/images/icon_reflex.png  -> small circular icon shown in intro cards

  final List<String> features = [
    'Perfect Diagnosis and Fast Result',
    'Energetic and stress free.',
    'Reduce monthly expenses incurred by family on medicines.',
    'Painless and safe.',
    'Easy to learn and practice.',
    'Helpful in all types of ailments.',
    'A completely natural and non-violent remedy.',
    'Self-treatment is possible.',
    'Early diagnosis and cure of disease affecting the body.',
    'Free from all types of harmful side effects.',
    'Rejuvenates the body by creating vitality and vigour.',
    'Facilitates the spread of essential elements and makes the muscles supple.',
    'Helps in boosting immunity against diseases.',
    'Controls the juices secreted by endocrine glands.',
    'Instant remedy for ailments cropping up suddenly.',
    'Equally beneficial for children, youth, women and men.',
  ];

  final List<Map<String, String>> rules = const [
    {
      'no': '01',
      'text': 'Give treatment in a peaceful and suitable atmosphere.',
    },
    {'no': '02', 'text': 'The feet of the patient must be clean.'},
    {
      'no': '03',
      'text':
          "Don't stop the patient if he is already receiving any other treatment.",
    },
    {
      'no': '04',
      'text': 'The person providing treatment must keep his/her nails trimmed.',
    },
    {'no': '05', 'text': 'Keep 1-hour gap between meal and treatment.'},
    {
      'no': '06',
      'text': 'Apply acupressure therapy in 8-hour gap during the day.',
    },
    {
      'no': '07',
      'text':
          'Apply pressure therapy keeping in view the mental and physical condition of the patient.',
    },
    {'no': '08', 'text': 'Treat the patient only after easing his tension.'},
    {'no': '09', 'text': "Don't provide treatment to others if yourself sick."},
    {'no': '10', 'text': "Don't deride the patient"},
    {
      'no': '11',
      'text': 'Pressure can be applied for 3 to 7 seconds on reflex points.',
    },
    {
      'no': '12',
      'text':
          "Treat the ailment with concentration. Don't let attention be diverted.",
    },
    {'no': '13', 'text': "Give treatment with a relaxed and cheerful mind."},
    {
      'no': '14',
      'text':
          "Apply pressure on main pressure points and also to the related pressure points.",
    },
    {
      'no': '15',
      'text':
          "First treat the ailments which are troublesome followed by other.",
    },
    {
      'no': '16',
      'text': "Symptoms may worsen briefly, but it’s a normal part of healing.",
    },
    {'no': '17', 'text': "Take precautions in diet"},
  ];

  final List<Map<String, String>> dont = const [
    {'no': '01', 'text': 'To Pregnent women.'},
    {'no': '02', 'text': 'On the swollen portion of the body.'},
    {'no': '03', 'text': "To a heavily drunk person."},
    {
      'no': '04',
      'text': 'On the portion that has been operated or have sustained injury.',
    },
    {'no': '05', 'text': 'To a famished (very hungry) person.'},
    {
      'no': '06',
      'text': 'On the portion of the body having suffered fracture.',
    },
    {
      'no': '07',
      'text':
          'On points in case there is too much pain,swelling or body is rddish.',
    },
    {'no': '08', 'text': 'During mestruation.'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: CommonAppBar(title: "Info"),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 9),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/classification.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // border: Border.all(
                        //  // color: HexColor("#F7C85A"),
                        //   width: 3,
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      "assets/images/feet.png",
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5),
                                Text(
                                  'Reflexology',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(thickness: 2, color: Colors.blue),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Reflexology is a holistic treatment based on the principle that there are areas and points on the feet, hands and ears. Applying pressure to these points stimulates energy along nerve channels and helps restore balance.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                child: Column(
                  children: [
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                // backgroundColor: HexColor("#D7B59E"),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                    "assets/images/questionmark.png",
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'What is JIN Reflexology',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Reflexology is the most effective therapy which is used without medicine in the world. The JIN Reflexology is the advanced version of this therapy.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                //border: Border.all(color: HexColor("#F7C85A"), width: 5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _sectionHeader(
                      'Rules-Essentials of JIN Reflexology',
                      "assets/images/box.png",
                    ),
                    const SizedBox(height: 12),
                    ...features.asMap().entries.map((e) {
                      final idx = e.key + 1;
                      final text = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _numberedTile(index: idx, text: text),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: Colors.yellow,
                border: Border.all(color: HexColor("#F7C85A"), width: 5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _sectionHeader(
                      'Features of JIN Reflexology Accupressure',
                      "assets/images/box.png",
                    ),
                    const SizedBox(height: 12),
                    ...features.asMap().entries.map((e) {
                      final idx = e.key + 1;
                      final text = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _numberedTile(index: idx, text: text),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: Colors.yellow,
                border: Border.all(color: HexColor("#F7C85A"), width: 5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _sectionHeader(
                      "Don't provide JIN treatment in the following condtions",
                      "assets/images/featuresphoto.png",
                    ),
                    const SizedBox(height: 12),
                    ...features.asMap().entries.map((e) {
                      final idx = e.key + 1;
                      final text = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _numberedTile(index: idx, text: text),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 16),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF0FA3C1),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: const Center(
            //     child: Text(
            //       'Learn More About JIN Reflexology',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String img) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.transparent,
        // color: HexColor("#D7B59E"),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: HexColor("#F7C85A"), width: 5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("${img}"),
            SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineCard({
    required String year,
    required String title,
    required String desc,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Row(
          children: [
            // year badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB00020),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                year,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberedTile({required int index, required String text}) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // // LEFT SIDE YELLOW CURVED SHAPE
            // Container(
            //   width: 22,
            //   height: 38,
            //   decoration: const BoxDecoration(
            //     color: Color(0xFFF7C548),
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(100),
            //       bottomRight: Radius.circular(100),
            //     ),
            //   ),
            // ),
            const SizedBox(width: 12),

            // NUMBER + TEXT
            Expanded(
              child: Text(
                "$index-  $text",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
