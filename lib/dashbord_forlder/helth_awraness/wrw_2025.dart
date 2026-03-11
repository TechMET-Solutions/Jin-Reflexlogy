import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class Wrw2025Screen extends StatelessWidget {
  const Wrw2025Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Health Awareness – 2025"),

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
              "JIN Reflexology Day to International Yoga Day",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(height: 16),

          const Text(
            "India’s Biggest Health Awareness Campaign ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "Lokmat News – Health awareness seminars conclude Seminars organized in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "9 cities across 7 states, training provided in self-treatment.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          const Text(
            "Health Awaerness+ Seff Treatment Training Program Theoretical and Practical Supported by",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 10),

          const Text(
            "Arihant North Town Owners and Resients Welfare Associaton",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 10),

          const Text(
            "Your Healthy Life Is Our Priority",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "International Reflexology JIN Association in the closing ceremony of JIN Reflexology Day every year, JR Anil Jain, "
            "Inventor of JIN Reflexology, JR Harshit Jain, JR Rishabh Jain, Vice President of Mahavir International Vir Ghyanchand Kothari and others.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "Lokmat News Service    Chhatrapati Sambhajinagar:  The International "
            "Reflexology JIN Association organizes various health awareness "
            "programs every year from JIN Reflexology Day on June 1 to "
            "International Yoga Day on June 21, which has become India’s "
            "biggest health awareness campaign. In the same series, this year "
            "from June 1 to June 21, 20 highly inspiring health awareness and "
            "life-changing seminars were organized in 19 cities over 21 days, "
            "which concluded on June 29. Mahavir International North Town "
            "Center organized a two-day health awareness and self-treatment "
            "training camp through JIN Reflexology at the clubhouse premises, "
            "which concluded with great joy.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "Coordinator of this campaign, key speaker JR Anil Jain, Inventor of JIN Reflexology, while explaining the specialty of JIN Reflexology",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),

          SizedBox(height: 10),

          const Text(
            "He said that there are more than 200 medical systems available "
            "in the world. Among them, after Ayurveda, reflexology is the "
            "only medical system that accurately diagnoses diseases without "
            "asking the patient a single question and informs the patient "
            "about all his or her health problems.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "There is a great need for health awareness seminars these days. "
            "Non-communicable diseases account for 61 percent of deaths in "
            "India each year. No significant efforts are being made nationwide "
            "to prevent them.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "After conducting research on thousands of patients, it was "
            "concluded that the root cause of any major illness—whether it is "
            "a heart attack, kidney failure, spondylitis or Parkinson’s "
            "disease—is a chaotic lifestyle. These seminars were organized "
            "to prevent future serious illnesses and bring beautiful smiles "
            "to people’s faces. All attendees at these two-hour seminars were "
            "given the opportunity to practice healthy eating habits.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "It was explained in a very simple and effective manner that by "
            "making some necessary changes in our daily lifestyle, we can "
            "not only achieve good health but also live a mentally calm and "
            "stress-free life.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "Over the past five years, 144 seminars in this series of health "
            "awareness programs have been organized through major institutions "
            "across the country. Reflexology, a healthy lifestyle and key "
            "life-changing factors were explained through computerized "
            "PowerPoint presentations, and participants’ questions were also "
            "addressed. This initiative has already brought positive change "
            "to the lives of millions of people.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "This massive campaign was launched five years ago under the "
            "guidance of Lokmat Group Editor-in-Chief Rajendra Darda. "
            "Lokmat, as the media partner, is playing a crucial role in "
            "disseminating it to the masses. Rajendra Darda was instrumental "
            "in making the 21-day program a success and systematically "
            "implementing all the initiatives.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "JIN REFLEXOLOGY DAY 1st JUNE HEALTHY & NATURAL LIFE",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "media partner = Lokmat, Lokmat Samachar, LOKMAT TIMES",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10),

          const Text(
            "Along with Honorable Rajendra Babuji Darda, Prof. PB Lohia, Vimal Bafna, JR Harshit Jain, JR Rishabh Jain, "
            " JR Anand Chopra, Mahavir Banthia, Lalit Gandhi etc. had important contributions.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "Mahavir International’s International Vice President Ghyanchand "
            "Kothari, Mahavir Sabdada, Shantilal Chaudhary, Ramesh Nahata and "
            "Budhprakash Doshi contributed to the successful closing ceremony. "
            "This year, for 21 days, from 8 to 9 pm daily, expert speeches on "
            "various health-related topics were also presented on the JIN "
            "Reflexology YouTube and Facebook channels. Based on those speeches, "
            "on July 11th",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 10),

          const Text(
            "A “Gyan Badhao” contest has also been organized, in which five questions will be asked. The first three contestants "
            "to answer correctly will be awarded prizes. Use the following link to join this campaign.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [Container(height: 250, color: Colors.grey)],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [Container(height: 250, color: Colors.grey)],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          const Text(
            "Glimpses of India’s Biggest Health Awareness Campaign – 2025",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 16),

          Container(color: Colors.grey, height: 200, width: double.infinity),

          SizedBox(height: 16),

          Column(
            children: [
              Container(
                color: Colors.red,
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Increase your health knowledge through live content.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey.shade200,
                width: double.infinity,
                height: 80,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Daily 8 to 9 pm on Facebook and Youtube Channel by our prominent speakers.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 22,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey,
                height: 200,
                width: double.infinity,
              );
            },
          ),
        ],
      ),
    );
  }
}
