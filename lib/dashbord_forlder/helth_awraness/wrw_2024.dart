import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2024Screen extends StatelessWidget {
  const Wrw2024Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(title: "Health Awareness – 2024"),
      backgroundColor: Colors.white,
    
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [articleSection(), const SizedBox(height: 30)],
          ),
        ),
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
          SizedBox(height: 10),
          Center(
            child: const Text(
              "JIN Reflexology Day – 2024 ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(height: 16),

          const Text(
            "JIN Reflexology Day (1st June) to International Yoga Day (21st June)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "Health Awareness and Life Changing Seminars",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "‘Swasth Bharat Abhiyan’ to be implemented on the occasion of Gin Reflexology Day",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "Starting today: 4 states, 21 days, 18 cities, 21 seminars",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Lokmat News Network Chhatrapati Sambhajinagar: International",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 10),

          const Text(
            "The International  JIN Reflexology Association will celebrate JIN Reflexology Day on June 1. "
            "On this occasion, the ‘Swasth Bharat Abhiyan’ will be implemented from June 1st to 21st.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "There will be a ‘Swasth Bharat Abhiyan’ between JIN Reflexology Day and International Yoga Day. "
            " Under this, 21 seminars have been organized in 21 days, in 4 states, and 18 cities. "
            " ‘Detailed information on how to prevent serious diseases in the future through JIN Reflexology"
            "will be given during all these campaigns. ‘Lokmat’ is the media partner of this campaign.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "In this campaign, the International Reflexology JIN Association "
            "along with Mahavir International (Balaghat, Ahmednagar, Jodhpur), "
            "Majestic and Magic, Chhatrapati Sambhajinagar, Oswal Jain Samaj, "
            "Amravati, Bharatiya Jain Sanghatana, Warora, Navkar Sangeet "
            "Mandal, Niphad, Shri Parshwanath Digambar Jain Trust, Pune, "
            "Jai Bhagwan Acupressure Center, Mumbai, Sukrut and other "
            "institutions extended their support.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "The campaign begins from Balaghat.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 10),

          const Text(
            "The launch of the Swasthya Bharat Abhiyan will be held on Thursday, June 1, in Balaghat "
            " (Madhya Pradesh). The event is organized by Mahavir International. ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "Campaign closing ceremony in the city on June 25",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15, height: 1.6,fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 10),

          const Text(
            "‘Healthy India Campaign’ concludes in Chhatrapati Sambhajinagar",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "It will be held on June 25. Rajendra Darda, Editor-in-Chief of Lokmat Group, will preside.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 10),

          const Text(
            "JIN REFLEXOLOGY DAY  1st JUNE HEALTHY & NATURAL LIFE",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 10),

          const Text(
            "media partner = Lokmat, Lokmat Samachar, LOKMAT TIMES",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6,fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 10),

          const Text(
            "The keynote speakers of this program will be JR Anil Jain, "
            "Inventor of JIN Reflexology, along with JR Shilpa Jain, "
            "JR Anupreeta Gandhi, JR Sapna Gandhi, JR Monica Kathed, "
            "JR Mayuri Surana and JR Anita Surana (Mumbai).",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "The 10-member committee for planning the campaign includes "
            "Rajendra Darda, Rajkumar Jain, Lalit Gandhi, Dr. Nirmal Pardhi, "
            "Dr. Sapna Patni (Dhule), Naresh Lalwani, Sandeep Kathed, "
            "Vimlesh Gandhi and Kalpesh Gandhi.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "The seminars in this campaign are free, and to participate, one should use the website to view YouTube and Facebook, said organizer JR Anil Jain.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "Sukrut Trust Naturopathy and Yoga Center Malad, Mumbai, along with other institutions and"
            "organizations, are working hard to make the campaign a success.  Organized by -International Reflexology JIN Association",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "www.jinreflexology.in/jin24",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "Media Partner",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "लोकमत Maharashtra No. 1 Daily Newspaper",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),

            ],
          )


        ],
      ),
    );
  }
}
