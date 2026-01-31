import 'package:flutter/material.dart';

class AboutJinReflexologyScreen extends StatelessWidget {
  AboutJinReflexologyScreen({super.key});

  final List<Map<String, String>> awardsList = [
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Yogi Vivekanand Nisargoupchar Sikshan Kendra – 2025"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Metro City, Chhatrapati Sambhajinagar – 2025"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Chhatrapati Sambhajinagar – 2025"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Shri Tulsi Mahapraghya Foundation, Mumbai – 2025"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Bharat Scouts and Guides – 2024"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Jain youth Club, Lions Club of Hyderabad – 2024"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Agarwal Samaj, Telangana – 2024"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Jain Social Group, Vijaypur, Karnataka – 2024"},
    {"title": "INTERNATIONAL ICON OF REFLEXOLOGY", "desc": "Conferred by Akhil Bhartiya Marvadi – Gujrati Manch – 2024"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Praghya Jain Mahila Mandal, Mumbai – 2023"},
    {"title": "JIN REFLEXOLOGY RESEARCH AWARD", "desc": "Conferred by International Holistic Medicine, Indore, 2022"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Main Chhatrapati Sambhaji Nagar – 2022"},
    {"title": "LIFE TIME ACHIEVEMENT AWARD", "desc": "Conferred by Mahavir International, Metro city, Aurangabad, 2022"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Shri All India Svetambara Sthanakvasi Jain Conference Women Wing – 2020"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Chennai Metro, Chennai, 2019"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Metro City, Chhatrapati Sambhajinagar – 2018 October"},
    {"title": "GEMS OF ACUPRESSURE AWARD", "desc": "Conferred by Bihar Acupressure Yoga College, Patna, Bihar, 2018"},
    {"title": "CERTIFICATE OF APPRECIATION AWARD", "desc": "Conferred by Heritage Foundation, Vadodara, 2018"},
    {"title": "CHINMAY CHIKITSA RATNA AWARD", "desc": "Conferred by World Jain Doctors Forum, Shravanbelgola – 2018"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Lokmat Sakhi Manch – 2017"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Lokmat Group of Newspaper – 2017"},
    {"title": "CERTIFICATE OF APPRECIATION AWARD", "desc": "Conferred by Acupressure Health Care, Jamnagar, Gujrat, 2017"},
    {"title": "YOUNGE ENTREPRENEUR AWARD OF MAHARASHTRA", "desc": "Conferred by Maharashtra Pradeshik Marwadi Yuva Manch, Mumbai, 2017"},
    {"title": "YOG MAHRSHI AWARD", "desc": "Conferred by Rural Naturopathy Organization, Chhatrapati Sambhajinagar – 2015"},
    {"title": "CHINMAY RATNA AWARD", "desc": "Conferred by All India Jain Doctors Association, Aurangabad 2013"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Chennai Metro, Chennai, 2013"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Bhartiy Jain Sanghatana, Warora, 2013"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahatma Gandhi Hindi Vishwavidyalaya, Wardha, 2012"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Mahavir International, Suratgadh, 2012"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Lions Club of Dondaicha, Dondaicha, 2012"},
    {"title": "GEM OF ALTERNATIVE MEDICINE", "desc": "Conferred by Indian Boards of Alternative Medicines, 2011"},
    {"title": "SAMTA RATNA PURASKAR", "desc": "Conferred by Maharashtra Equality Welfare Society, 2005"},
    {"title": "MARATHWADA GOURAV PURASKAR", "desc": "Conferred by Value Education Academy, 2004"},
    {"title": "APPRECIATION AWARD", "desc": "Conferred by Lions Club of CIDCO, Aurangabad, 2003"},
  ];

  final List<String> spiritualPlaces = [
    "Mathaniya (Rajasthan) – 1990",
    "Coimbatore (Tamilnadu) – 1992",
    "Chennai (Tamilnadu) – 1993",
    "Rajnandgaon (Chhattisgarh) – 1994",
    "Jay pore Jhadi (Orissa) – 1995",
    "Lasur (Maharashtra) – 1996",
    "Nanded (Maharashtra) – 1997",
    "Shrirampur (Maharashtra) – 1998",
    "Parbhani (Maharashtra) – 1999",
    "Beed (Maharashtra) – 2000",
    "Gangapur (Maharashtra) – 2001",
    "Lasalgaon (Maharashtra) – 2002",
    "Manmad (Maharashtra) – 2003",
    "Nandura (Maharashtra) – 2004",
    "Yeola (Maharashtra) – 2005",
    "Karanja (Maharashtra) – 2006",
    "Deola (Maharashtra) – 2007",
    "Pimpalner (Maharashtra) – 2008",
    "Manur Takli (Maharashtra) – 2009",
    "Beed (Maharashtra) – 2010",
    "Raipur (Chhattisgarh) – 2011",
    "Kolkata (West Bengal) – 2012",
    "Bangalore (Karnataka) – 2013",
    "Mumbai CP Tank (Maharashtra) – 2014",
    "Choumahla (Rajasthan) – 2015",
    "Mumbai Bhainder (Maharashtra) – 2016",
    "Morvan (Madhya Pradesh) – 2017",
    "Ramganjmandi (Rajasthan) – 2018",
    "Mumbai – Marol (Maharashtra) – 2019",
    "Jodhpur (Rajasthan) – 2020 (Corona)",
    "Udaipur (Rajasthan) – 2021 (Corona)",
    "Balod (Chhattisgarh) – 2022",
    "Dhar (Madhya Pradesh) – 2023",
    "Alwar (Rajasthan) – 2024",
    "Mumbai - Thane (Maharashtra) – 2025",
  ];

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xff7b001c),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildContentCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5, right: 8),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwardCard(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xffe8f5e8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
    final double profileImageSize = isLargeScreen ? 100.0 : 80.0;

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: const Color(0xff7b001c),
        title: const Text(
          'About JR Anil Jain',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // PROFILE SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: profileImageSize / 2,
                      backgroundImage:
                          const AssetImage("assets/images/anil_jain.png"),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "JR Anil Suganchand Jain",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Inventor of JIN Reflexology\nPresident - International Reflexology JIN Association",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffe8f5e8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "J – Justify   I – Integrated   N – Natural",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // INVENTION WORK
              _buildSectionHeader("Invention Work - JIN Reflexology"),
              _buildContentCard(
                "After doing research work on 13000 people, on the most ancient Therapy, "
                "it was presented as JIN Reflexology Therapy. There are more than 200 Therapies "
                "in the world for treatment, but the disease cannot be diagnosed accurately. "
                "After Ayurveda, the only therapy in the world for diagnosing the disease is "
                "JIN Reflexology, in which not a single question is asked to the patient, "
                "and he is told what problem he is suffering from.\n\n"
                "Creation of world class software in which complete information of the patient "
                "is stored for research work and to get quick results.",
              ),

              // INDIA'S BIGGEST HEALTH AWARENESS CAMPAIGN
              _buildSectionHeader("India's Biggest Health Awareness Campaign"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                    _buildBulletItem("1st National Conference and Award presentation Ceremony – 2015 at Chhatrapati Sambhaji Nagar, Maharashtra, India"),
                    _buildBulletItem("2nd National Conference and Award presentation Ceremony – 2016 at Mumbai, Maharashtra, India"),
                    _buildBulletItem("3rd National Conference and Award presentation Ceremony – 2017 at Mumbai, Maharashtra, India"),
                    _buildBulletItem("4th National Conference and Award presentation Ceremony – 2018 at Surat, Gujrat, India"),
                    _buildBulletItem("5th National Conference and Award presentation Ceremony – 2019 at Bengaluru, Karnataka, India"),
                    _buildBulletItem("1st International and 6th National Conference Online – 2020"),
                    _buildBulletItem("2nd International and 7th National Conference Online – 2021"),
                    _buildBulletItem("JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2020 21 Days Free Online Power Yoga"),
                    _buildBulletItem("JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2021 Free 21 Days Free Online Power Yoga"),
                    _buildBulletItem("JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2022  21 Days 19 City in Maharashtra 25 Health Awareness and Life Changing Seminars"),
                    _buildBulletItem("JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2023  21 Days 19 City (4 States – Madhya Pradesh, Maharashtra, Gujrat, Rajasthan) 21 Health Awareness and Life Changing Seminars"),
                    _buildBulletItem("JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2024  21 Days 21 City (4 States – Madhya Pradesh, Maharashtra, Karnataka, Telangana Rajasthan) 21 Health Awareness and Life Changing Seminars"),
                    _buildBulletItem("JIN Day Event – 1st June (JIN Reflexology day) to 21st June (International Yoga Day) Health Awareness Campaign – 2025  31 Days 21 City (7 States – Delhi, Madhya Pradesh, Maharashtra, Karnataka, Telangana Rajasthan, Tamil Nadu) 21 Health Awareness and Life Changing Seminars"),
                  ],
                ),
              ),

              // FREE TREATMENT
              _buildSectionHeader("Free Treatment Serve To All"),
              _buildContentCard(
                "A unique act of service to suffering humanity, free treatment was provided "
                "for 2 hours daily for 29 consecutive years.\n\n"
                "1989 to 2018",
              ),

              // ORGANIZING AWARENESS CAMPS
              _buildSectionHeader("Organizing Awareness Camps"),
              _buildContentCard(
                "To make the JIN Reflexology treatment method accessible to the common people, "
                "more than 125 free training camps were organized with the help of various "
                "organizations across the country.",
              ),

              // HEALTH AWARENESS SEMINARS
              _buildSectionHeader("Health Awareness and Life Changing Seminar"),
              _buildContentCard(
                "It is not possible to treat lakhs of people through 'JIN Reflexology', "
                "but crores of people can be saved from getting sick. 'Swasth Bharat Abhiyan' "
                "was started with this feeling. To prevent diseases from which 61% of the people "
                "are dying in the whole of India, seminars on healthy awareness and lifestyle "
                "change are presented through computerized presentations. Till now 165 seminars "
                "of this series have been organized in the whole country.",
              ),

              // JIN REFLEXOLOGY BOOK
              _buildSectionHeader("Write JIN Reflexology Book"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                    const Text(
                      "To make the knowledge gained from research and studies accessible to the common people, "
                      "it was published through the book JIN Reflexology:",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBulletItem("1st Edition – Award-Winning Book – JIN Reflexology – (Hindi) (Released by Honorable Rajendra Darda, Education Minister, Maharashtra)."),
                    _buildBulletItem("2nd Edition – JIN Reflexology (English). (Released by Honorable Gulam Nabi Azad, Union Health & Family Planning Minister. Honorable Vijay Babuji Darda, M. P.)"),
                    _buildBulletItem("3rd Edition – JIN Reflexology (With DVD) (Hindi). (Released by Honorable Prithaviraj Chavhan, (Chief Minister- Maharashtra), Hon'ble Rajendra Darda (Education Minister)."),
                    _buildBulletItem("4th Edition – JIN Reflexology – (Hindi) (Released by Honorable Rajendra Darda, Editor in chief – Lokmat Group on 22 June, 2024. This book is becoming popular as a living teacher, because in it, QR codes have been given after each lesson to easily understand the deepest secrets of the medical system. About 118 QR codes have been given."),
                  ],
                ),
              ),

              // HONORS & AWARDS
              _buildSectionHeader("Honors & Awards"),
              _buildContentCard(
                "For the work of research and service, he has been honored with more than 35 "
                "national and international awards like International Icon of Reflexology, "
                "Yoga Maharishi, Gems of Alternative Therapy, Maharashtra Gaurav, "
                "Yuva Gaurav, Samaj Bhushan, Chinmaya Chikitsa etc.",
              ),
              ...awardsList.map(
                (award) => _buildAwardCard(award["title"]!, award["desc"]!),
              ),

              // SPIRITUAL
              _buildSectionHeader("Spiritual"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                    const Text(
                      "For the past 34 years, every year during the 8 days of 'Paryushan festival', "
                      "I go to those places where the saints do not observe 'Chaturmas', as a 'Swadhyayi' "
                      "and participate in the worship of my religion and that of all the members of the organization.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...spiritualPlaces.map((place) => _buildBulletItem(place)),
                  ],
                ),
              ),

              // SOCIAL
              _buildSectionHeader("Social"),
              _buildContentCard(
                "Founder President of Mahavir International, Metro City, an organization working "
                "on the principle of service to all, love to all, and live and let live. "
                "Currently working as the Zone Chairman of Mahavir International, Central Maharashtra. "
                "Successfully organized five national and one international convention through "
                "the International Reflexology JIN Organization.",
              ),

              // AWARD IMAGE
              Container(
                width: double.infinity,
                height: isLargeScreen ? 250 : 200,
                margin: const EdgeInsets.only(top: 16, bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/award.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.emoji_events,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}