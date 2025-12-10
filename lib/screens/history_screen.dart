import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> timelineData = [
    {
      'year': '2500 BC',
      'title': 'First Documentation',
      'description':
          'Earliest record of foot therapy found in ancient Egypt, showing reflexology as a healing art.',
    },
    {
      'year': '790 A.D',
      'title': "Stone of Buddha's Foot",
      'description':
          'Stone carving with Sanskrit symbols found in Japan, showing early reflexology references.',
    },
    {
      'year': '1582',
      'title': 'First Book on Zone Therapy',
      'description':
          'Dr. Adamus and Dr. A’tatis wrote one of the earliest books on Zone Therapy.',
    },
    {
      'year': '1833',
      'title': 'Marshall Hall’s Explanation',
      'description':
          'Explained “reflex action” through studies on the spinal cord and reflexes.',
    },
    {
      'year': '1870s',
      'title': 'Ivan Sechenov’s Work',
      'description':
          'Introduced “Reflexes of the Brain”, expanding research into conditioned reflexes.',
    },
    {
      'year': '1993',
      'title': 'William & Terry’s Research Paper',
      'description':
          'First American study showing Reflexology as an effective therapy for PMS symptoms.',
    },
  ];

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        centerTitle: true,
        title: const Text(
          'History of Reflexology',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
        
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: HexColor("#F0E6D6"),
              borderRadius: BorderRadius.circular(10),
              border: Border(
                left: BorderSide(color: HexColor("#F7C85A"), width: 5),
                right: BorderSide(color: HexColor("#F7C85A"), width: 5),
              ),
            ),
            child: const Text(
              'In India, for thousands of years this type of therapy has been used as a routine lifestyle practice called the Indian life style.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Image 1
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#F0E6D6"),
                border: Border(
                  left: BorderSide(color: HexColor("#F7C85A"), width: 5),
                  right: BorderSide(color: HexColor("#F7C85A"), width: 5),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Image.asset(
                      'assets/images/history_one.jpg',
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  const Text(
                    'At the Feet of the Gods: a very early picture of foot work being offered. Lakshmi working on the feet of the Hindu god Vishnu.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#F0E6D6"),
                border: Border(
                  left: BorderSide(color: HexColor("#F7C85A"), width: 5),
                  right: BorderSide(color: HexColor("#F7C85A"), width: 5),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/history_two.jpg',
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Depiction of divine healing through foot massage, representing balance and spiritual connection.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 08.0,
            ),
            decoration: BoxDecoration(
              color: HexColor("#F7C85A"),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Timeline',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          ...timelineData.asMap().entries.map((entry) {
            int index = entry.key;
            var data = entry.value;
            bool isLast = index == timelineData.length - 1;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Line + Dot
                  Column(
                    children: [
                      // Container(
                      //   width: 2,
                      //   height: 20,
                      //   color:
                      //       index == 0
                      //           ? Colors.transparent
                      //           : const Color.fromARGB(255, 19, 4, 66),
                      // ),
                      // Container(
                      //   width: 14,
                      //   height: 14,
                      //   decoration: const BoxDecoration(
                      //     color: const Color.fromARGB(255, 19, 4, 66),
                      //     shape: BoxShape.circle,
                      //   ),
                      // ),
                      // if (!isLast)
                      //   Container(
                      //     width: 2,
                      //     height: 80,
                      //     color: const Color.fromARGB(255, 19, 4, 66),
                      //   ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Timeline Card
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor("#F0E6D6"),
                        border: Border(
                          left: BorderSide(
                            color: HexColor("#F7C85A"),
                            width: 5,
                          ),
                          right: BorderSide(
                            color: HexColor("#F7C85A"),
                            width: 5,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  data['year']!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data['description']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
