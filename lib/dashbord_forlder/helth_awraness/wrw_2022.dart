import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
class Wrw2022Screen extends StatelessWidget {
  const Wrw2022Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CommonAppBar(title: "Health Awareness – 2022"),
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
        
              articleSection(),
        
              const SizedBox(height: 30),
            ],
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
          const Text(
            "Health awareness campaign on the occasion of JIN Reflexology Day",
          textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "Starting from June 1st: 21 days, 25 seminars in 19 cities",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "Lokmat News Network    Aurangabad:  The International Reflexology "
                "JIN Association will celebrate JIN Reflexology Day on June 1. On this "
                "occasion, a health awareness campaign will be conducted in the state "
                "from June 1 to 21.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),


          const Text(
            "Between JIN Reflexology Day and International Yoga Day, 25 health "
                "awareness campaigns have been organized in 19 cities in these 21 days. "
                "Detailed information on how to prevent serious diseases in the future "
                "through JIN Reflexology will be given in all these campaigns. The media "
                "partner of this campaign is 'Lokmat'.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "In this campaign, the International Reflexology JIN Association along "
                "with Sudharma Jain Shravak Sangh, Himayatnagar, Bharatiya Jain Sanghatana, "
                "Sillod and Lasalgaon, National Institute of Naturopathy, Pune, Pragya "
                "Jain Mahila Jain Mandal, Mumbai, Jai Bhagwan Acupressure Center, Mumbai, "
                "Digambar Jain Sangh, Bhiwandi, Oswal Social Group and Jain Sangh, Jamner, "
                "Shrimunisuvrat Jain Samaj, Paithan, Shantinath Digambar Jain Mandir, "
                "Dhule, Balasaheb Community Development Center, Kannada, A. Bha. Terapanth "
                "Mahila Mandal, Dakshin Madhya Jain Shravak Sangh, Indian Medical "
                "Association, Mahavir International, Metrocity, Aurangabad District "
                "Automobiles Association, Marwari Yuva Manch, Jalna, Matsyodari Mahila "
                "Midtown Branch, Ambad, Lions Club of Aurangabad-Midtown, Parshwanath "
                "Brahmachari Ashram, Verul and other institutions and organizations are "
                "making efforts.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The keynote speaker of this program will be JR Anil Jain, Inventor of "
                "JIN Reflexology, along with JR Shilpa Jain, JR Anupreeta Gandhi, "
                "JR Sapna Gandhi, JR Monica Kathed and JR Mayuri Surana.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The campaign will conclude on June 26 in Aurangabad. The program will "
                "be presided over by Rajendra Darda, Editor-in-Chief of 'Lokmat'.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10,),


          const Text(
            "media partner",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10,),


          const Text(
            "Lokmat Lokmat News Lokmat Times",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "Starting from Himayatnagar on June 1, the health awareness seminar "
                "campaign will begin in Nanded district. JIN Reflexology Day will be "
                "held at Himayatnagar on June 1. The inauguration will be conducted by "
                "A. Madhavrao Patil Jabalgaonkar. This seminar has been organized by "
                "Sudharma Jain Shravak Sangh.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The 10-member committee for planning the campaign includes Rajendra "
                "Darda, Lalit Gandhi, Dr. Nirmala Pardhi, Mumbai, Sanjay Mantri, "
                "Dr. Sapna Patni, Dhule, Naresh Lalwani, Sandeep Kated, "
                "Vimlesh Gandhi and Supriya Surana.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),



          SizedBox(height: 10,),

          const Text(
            "Convener JR Anil Jain informed that the seminars in the campaign are "
                "free of cost, and to participate, one should use the website given "
                "below or watch the sessions on YouTube and Facebook.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "www.jinreflexology.in/jinday22",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 20,),

          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 20,),


        ],
      ),
    );
  }
}