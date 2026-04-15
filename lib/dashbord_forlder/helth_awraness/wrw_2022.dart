import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/health_campaign_pdf_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2022Screen extends StatefulWidget {
  const Wrw2022Screen({super.key});

  @override
  State<Wrw2022Screen> createState() => _Wrw2022ScreenState();
}

class _Wrw2022ScreenState extends State<Wrw2022Screen> {
  bool _expanded = false;

  Widget _expandableHeader(String title) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              _expanded ? Icons.remove : Icons.add,
              size: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Health Awareness – 2022"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _expandableHeader(
                  "India’s Biggest Health Awareness Campaign – on the occasion of JIN Reflexology Day",
                ),
                if (_expanded) ...[
                  const SizedBox(height: 10),
                  const Text(
                    "Starting from June 1st: 21 days, 25 seminars in 19 cities",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Lokmat News Network Aurangabad: The International Reflexology JIN Association will celebrate JIN Reflexology Day on June 1st. On this occasion, a health awareness campaign will be conducted in the state from June 1st to June 21st.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Between JIN Reflexology Day and International Yoga Day, 25 health "
                    "awareness campaigns have been organized in 19 cities in these 21 days. "
                    "Detailed information on how to prevent serious diseases in the future "
                    "through JIN Reflexology will be given in all these campaigns. The media "
                    "partner of this campaign is ‘Lokmat’.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
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
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  const Text(
                    "The campaign will conclude on June 26 in Aurangabad. The program will "
                    "be presided over by Rajendra Darda, Editor-in-Chief of ‘Lokmat’.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Media partner: Lokmat, Lokmat News, Lokmat Times.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Starting from Himayatnagar from June 1st, the health awareness seminar campaign begins in Nanded district. JIN Reflexology Day will be held at Himayatnagar on June 1st. The inauguration will be held by A. Madhavrao Patil Jabalgaonkar. This seminar has been organized by Sudharma Jain Shravak Sangh.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The 10-member committee for planning the campaign includes Rajendra Darda, Lalit Gandhi, Dr. Nirmala Pardhi (Mumbai), Sanjay Mantri, Dr. Sapna Patni (Dhule), Naresh Lalwani, Sandeep Kathed, Vimlesh Gandhi, Supriya Surana.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Convener JR Anil Jain informed that the seminars in the campaign are free, and to participate, one should use the website given below to watch on YouTube and Facebook.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "www.jinreflexology.in/jinday22",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "2022 Glimpses PDF",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 560,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const CampaignPdfViewer(year: 2022),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
