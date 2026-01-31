import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, String>> timelineData = [
    {
      'year': '2500 BC',
      'title': 'First Documentation',
      'description':
          'Ed and Ellen Case of Los Angeles was touring Egypt in 1979, they discovered and brought back an ancient Egyptian papyrus scene depicting medical practitioners treating the hands and feet of their patients.',
    },
    {
      'year': '2nd Century B.C.',
      'title': "Early Evidence of Historical \nRecords",
      'description':
          'The early evidence from the "Historical records" written by Sima Qian of Chinese Reflexology dates back to when Dr. Yu Fu (in Chinese Yu means healing and Fu means foot) treated patients without herbs and acupuncture but concentrated on massage, and the illness responded to every stroke of his.',
    },
    {
      'year': '250 B.C.',
      'title': "Buddha's Footprint",
      'description':
          'Dr. Waldemar E. Sailor has searched for Buddha footprints for twenty-five years and has located them in Afghanistan, Bhutan, Cambodia, China, India, Japan, Korea, Laos, Malaysia, the Maldives, Pakistan, Singapore, Sri Lanka, Thailand and the Union of Myanmar. Each footprint symbol was different—some did not have any symbols, it meant a different time and culture.',
    },
    {
      'year': '790 A.D.',
      'title': 'Stone of Buddha\'s foot',
      'description':
          'The stone carving of Buddha\'s foot, with Sanskrit symbols on the sole, was found at the Medicine Teacher Temple in Nara, Japan.',
    },
    {
      'year': '1275-1292',
      'title': 'Marco Polo visits China',
      'description':
          'Marco Polo traveled China and the Dominican and Franciscan missionaries; they are credited with bringing the ancient Chinese massage technique into Europe.',
    },
    {
      'year': '1582',
      'title': 'First book on Zone Therapy',
      'description': "Dr. Adamus and Dr. A'tatis wrote a book on Zone therapy.",
    },
    {
      'year': '1583',
      'title': 'Second book on Zone Therapy',
      'description': "Dr. Ball from Leipzig wrote a book on Zone therapy.",
    },
    {
      'year': '1583',
      'title': 'Second book on Zone Therapy',
      'description': "Dr. Ball from Leipzig wrote a book on Zone therapy.",
    },
    {
      'year': "1690's",
      'title': 'Jim Roll\'s notion',
      'description':
          "Jim Rolls, a Cherokee Indian, said pressure therapy on the feet to restore and balance the body has been passed down through the generations. A Cherokee Indian, Jenny Wallace from Blue Ridge Mountains, North Carolina says the clan of her father (Bear Clan) believes feet are important. Your feet walk upon the earth and through this your spirit is connected to the universe. Our feet are our contact with the Earth and the energies that flow through it.",
    },
    {
      'year': '1771',
      'title': 'Johann Unzer\'s Work',
      'description':
          "German physiologist Johann August Unzer published his work about motor reactions and used the term 'reflex'.",
    },
    {
      'year': '1833',
      'title': 'Marshall Hall\'s explanation',
      'description':
          "English physician and physiologist Marshall Hall was the first to explain the term 'reflex action' because of the result of his experiments on animals. He studied the medulla oblongata and the spinal cord and their reflex actions. He stated: 'That the spinal cord is comprised by a chain of units that functions as an independent reflex arcs, and their activity integrates sensory and motor nerves at the segment of the spinal cord from which these nerves originate.'",
    },
    {
      'year': "1870's",
      'title': 'Ivan Sechenov\'s book',
      'description':
          "Ivan Sechenov, the founder of Russian physiology, wrote a book called 'Reflexes of the Brain'. He brought electrophysiology into the laboratory and taught this method. The Russian physician Dr. Ivan Pavlou, founder of the Russian Brain Institute, used Zone therapy. Pavlov was very interested into the research of physiology of animal digestion which led him logically to create a science of conditioned reflexes. He expanded on his research into the physiology of animal digestion and the subsequent articulation of 'a science of conditioned reflexes'. He was awarded the Nobel Prize in 1904 for his work on pancreatic nerves. He lectured about the conditioned reflexes.",
    },
    {
      'year': '1878',
      'title': 'Babinski\'s essay',
      'description':
          "French physician M.J. Babinski wrote an essay called 'A Phenomenon of the Toes and its Symptomatological Value.' In 1896 he wrote another essay with his new findings called 'Planar Cutaneous Reflexes in Certain Organic Conditions of the Central Nervous System.'",
    },
    {
      'year': '1878',
      'title': 'Dr. Brunton publishes paper',
      'description':
          "Dr. T. Lauter Brunton wrote a paper for the Brain, A Journal of Neurology called 'Reflex action as a Cause of Disease and Means of Cure.'",
    },
    {
      'year': "1880's",
      'title': 'Sir Henry\'s Thesis',
      'description':
          "English Neurologist Sir Henry Head, a doctor of medicine at Cambridge, wrote his thesis on pain in visceral disease. He later published an article in the Brain, A Journal of Neurology titled 'On Disturbances of Sensation with Especial Reference to the Pain of Visceral Disease.' He discovered 'Head Zones' and proved that pressure applied to the skin affects internal organs. He wrote: 'The bladder can be excited to action by stimulating the sole of the foot, and movements of the toes can be revoked by filling the bladder with fluid.'",
    },
    {
      'year': "1890",
      'title': 'Cornelius\' Observations',
      'description':
          "German physician Dr. Alfonso Cornelius tried reflex-massage on certain areas of his body to cure his own disease. He noted improvement when he worked out the painful areas.",
    },
    {
      'year': "1902",
      'title': 'Cornelius\' Observations',
      'description':
          "German physician Dr. Alfonso Cornelius tried reflex-massage on certain areas of his body to cure his own disease. He noted improvement when he worked out the painful areas.",
    },
    {
      'year': "1909",
      'title': 'William Fitzgerald and Zone Therapy',
      'description':
          "American physician Dr. William Fitzgerald, a respected ear, nose, and throat surgeon from Connecticut, was teaching in Vienna. When he came back to America he used Zone therapy to deaden pain, replacing drugs in minor operations. He is accredited for the woodcut body that has the ten zones divided.",
    },
    {
      'year': "1917",
      'title': 'Edwin Bowers and Fitzgerald\'s book',
      'description':
          "Dr. Edwin F. Bowers encouraged and helped Dr. Fitzgerald to write his first book called 'Relieving Pain at Home.'",
    },
    {
      'year': "1930's",
      'title': 'Joe Shelby Riley\'s Book',
      'description':
          "American physician Dr. Joe Shelby Riley of Washington D.C., who Dr. Fitzgerald trained, worked with hand, facial, and ear points. He published a book called 'Zone Therapy Simplified,' which detailed the first diagrams of reflex points found on the feet.",
    },
    {
      'year': "1932",
      'title': 'Eunice Ingham\'s foundings',
      'description':
          "Eunice Ingham, a physiotherapist of St. Petersburg, FL and a student of Dr. Joe Riley, continued to chart the feet and further developed Zone therapy into Reflexology. She found that the 'reflexes on the feet were an exact mirror image of the organs of the body'. In 1938, she published 'Stories the Feet Can Tell' and 'Zone Therapy and Gland Reflexes'. In 1951, she published 'Stories the Feet Have Told'. After publishing the books, she toured America conducting workshops teaching laypersons how they can help themselves, their families, and friends.",
    },
    {
      'year': "1950's",
      'title': 'National Institute of Reflexology',
      'description':
          "Eunice's niece, Eusebia Messenger, R.N., and nephew, Dwight Byers, joined her in conducting the workshops. As interest grew, they started a school called 'National Institute of Reflexology'. Dwight and Eusebia continued teaching and researching Reflexology after Eunice's death in 1974.",
    },
    {
      'year': "1960's",
      'title': 'Mildred Carter\'s Book',
      'description':
          "Mildred Carter, a minister, wrote the self-help book 'Helping Yourself with Reflexology.'",
    },
    {
      'year': "1970's",
      'title': 'Dwight Byers renames school',
      'description':
          "Dwight Byers renamed the St. Petersburg, Florida school 'International Institute of Reflexology'. He wrote a book called 'Better Health with Reflexology' and started schools all across the world.",
    },
    {
      'year': "1991",
      'title': 'ARCB Founded',
      'description':
          "The American leaders of Reflexology created the American Reflexology Certification Board (ARCB) to set national certification standards among professional reflexologists.",
    },
    {
      'year': "1993",
      'title': 'William and Terry\'s research paper',
      'description':
          "William Flocco and Terry Oleson, PhD wrote a research paper and presented it to the American Journal of Obstetrics and Gynecology. It proved how reflexology reduces women's PMS symptoms by 46 percent for eight weeks of weekly treatments, with a 42 percent reduction maintained for eight weeks after treatment. Reflexology was not as effective as drug treatments but lacked their side effects. This study was the first American scientific study accrediting reflexology as an effective therapy for PMS.",
    },
  ];

  final List<Map<String, dynamic>> iconsData = [
    {
      'year': '1993',
      'title': 'Today\'s Well Known Reflexology Icons',
      'left': [
        "Dr. Attar Singh",
        "Chanchalmal Chordia",
        "Dr. Chandraprakash Gupta",
        "Dr. Purshottam Lohia",
        "Shri Sarvdeo Prasad Gupta",
        "J. P. Agarwal",
        "Khemka",
        "Chimabhai Dave",
        "Vipin Shah",
        "Devendra Vora",
      ],
      'right': [
        "Dhiren Gala",
        "Navinchandra Shah",
        "Kelvin Kunj",
        "Dr. Jiten Bhatt",
        "Eduardo Luis",
        "Bill Flocco",
        "Beryl Crane",
        "Doreen Bayly",
        "Hagar Basis",
        "JR Anil Jain, etc.",
      ],
    },
  ];

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 768;
    final bool isMediumScreen = screenSize.width > 600;
    final double horizontalPadding = isLargeScreen
        ? screenSize.width * 0.1
        : isMediumScreen
            ? 24.0
            : 12.0;
    final double imageHeight =
        isLargeScreen ? 280 : isMediumScreen ? 250 : 210;
    final double titleFontSize = isLargeScreen ? 22.0 : 18.0;
    final double bodyFontSize = isLargeScreen ? 16.0 : 14.0;
    final double timelineTitleFontSize = isLargeScreen ? 15.0 : 13.0;
    final double timelineDescFontSize = isLargeScreen ? 15.0 : 14.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        centerTitle: true,
        title: Text(
          'History of Reflexology',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: titleFontSize,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: screenSize.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Introduction Card
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'In India, for thousands of years this type of therapy has been used as a routine lifestyle practice called the Indian life style.',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // 🔹 Images Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: isLargeScreen
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildImageCard(
                              context,
                              'assets/images/history_one.jpg',
                              'At the Feet of the Gods: a very early picture of foot work being offered. Lakshmi working on the feet of the Hindu god Vishnu.',
                              imageHeight,
                              bodyFontSize,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildImageCard(
                              context,
                              'assets/images/history_two.jpg',
                              'Depiction of divine healing through foot massage, representing balance and spiritual connection.',
                              imageHeight,
                              bodyFontSize,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildImageCard(
                            context,
                            'assets/images/history_one.jpg',
                            'At the Feet of the Gods: a very early picture of foot work being offered. Lakshmi working on the feet of the Hindu god Vishnu.',
                            imageHeight,
                            bodyFontSize,
                          ),
                          const SizedBox(height: 16),
                          _buildImageCard(
                            context,
                            'assets/images/history_two.jpg',
                            'Depiction of divine healing through foot massage, representing balance and spiritual connection.',
                            imageHeight,
                            bodyFontSize,
                          ),
                        ],
                      ),
              ),

              // 🔹 Timeline Section
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  16,
                ),
                child: Material(
                  elevation: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          'Timeline',
                          style: TextStyle(
                            fontSize: bodyFontSize + 2,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 🔹 Timeline Items
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: timelineData.asMap().entries.map((entry) {
                    int index = entry.key;
                    var data = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline line and dot (only show on large screens)
                          if (isLargeScreen)
                            SizedBox(
                              width: 30,
                              child: Column(
                                children: [
                                  Container(
                                    width: 2,
                                    height: 20,
                                    color: index == 0
                                        ? Colors.transparent
                                        : const Color.fromARGB(255, 19, 4, 66),
                                  ),
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 19, 4, 66),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: const Color.fromARGB(255, 19, 4, 66),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (isLargeScreen) const SizedBox(width: 16),

                          // Timeline Card
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Year and Title Row
                                    isLargeScreen
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 151, 232, 154),
                                                  border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 151, 232, 154),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    data['year']!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          timelineTitleFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 16),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    data['title']!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          timelineTitleFontSize,
                                                     // textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 151, 232, 154),
                                                  border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 151, 232, 154),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    data['year']!,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          timelineTitleFontSize,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    data['title']!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          timelineTitleFontSize,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 12),
                                    Text(
                                      data['description']!,
                                      style: TextStyle(
                                        fontSize: timelineDescFontSize,
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
                ),
              ),

              // 🔹 Icons Section
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  16,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor("#F7C85A"),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Today\'s Well Known Reflexology Icons',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),

              // 🔹 Icons List
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: iconsData.map((data) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: HexColor("#F0E6D6"),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          isLargeScreen
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['title'],
                                        style: TextStyle(
                                          fontSize: bodyFontSize + 2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      data['year'],
                                      style: TextStyle(
                                        fontSize: bodyFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['title'],
                                      style: TextStyle(
                                        fontSize: bodyFontSize + 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data['year'],
                                      style: TextStyle(
                                        fontSize: bodyFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 12),
                          // Two columns of names
                          isLargeScreen
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: (data['left'] as List<String>)
                                            .map((item) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 6),
                                            child: Text(
                                              "• $item",
                                              style:
                                                  TextStyle(fontSize: bodyFontSize),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            (data['right'] as List<String>)
                                                .map((item) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 6),
                                            child: Text(
                                              "• $item",
                                              style:
                                                  TextStyle(fontSize: bodyFontSize),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (data['left'] as List<String>)
                                          .map((item) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            "• $item",
                                            style:
                                                TextStyle(fontSize: bodyFontSize),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          (data['right'] as List<String>)
                                              .map((item) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: Text(
                                            "• $item",
                                            style:
                                                TextStyle(fontSize: bodyFontSize),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    String imagePath,
    String description,
    double imageHeight,
    double fontSize,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: imageHeight,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: imageHeight,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}