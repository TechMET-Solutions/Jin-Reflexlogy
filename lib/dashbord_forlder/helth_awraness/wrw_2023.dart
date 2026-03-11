import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
class Wrw2023Screen extends StatelessWidget {
  const Wrw2023Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Health Awareness – 2023"),
    
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

          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("JIN Reflexology Day Event -2023"),
                        Container(
                          height: 230,
                          color: Colors.grey,
                        )
                      ],

                    ),
                  ),
                ),
              ),
              SizedBox(width: 7,),
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("JIN Reflexology Day Event -2023"),
                        Container(
                          height: 230,
                          color: Colors.grey,
                        )
                      ],

                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10,),

          const Text(
            "Health awareness seminars conclude,",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "22 seminars held in 19 cities across 4 states.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text(
            "The International Reflexology Jain Association organizes various "
                "health awareness programs every year from Jain Reflexology Day "
                "(June 1) to International Yoga Day (June 21). Continuing this "
                "tradition, this year 22 health awareness seminars were organized "
                "in 18 cities over these 21 days, from June 1 to June 21.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "The program concluded on Sunday, July 2, in Kukshi, Dhar district, "
                "with an event organized by Allegiance Academy, coinciding with the "
                "100th birth anniversary of the respected Jawaharlal Darda, a senior "
                "freedom fighter and founder and editor of the Lokmat Group.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The program began with tributes to Jawaharlal Darda.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The main speaker, Jin Reflexology researcher G.R. Anil Jain, "
                "highlighted the unique features of Jin Reflexology, stating that "
                "among the more than 200 medical systems available worldwide, "
                "Jin Reflexology is the only one after Ayurveda that accurately "
                "diagnoses diseases without asking the patient any questions and "
                "informs the patient about all their ailments.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "There is a great need for health awareness seminars today. In India, "
                "61 percent of deaths each year are due to non-communicable diseases. "
                "No significant efforts are being made across the country to prevent this.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "After conducting research on thousands of patients, it was concluded "
                "that the root cause of even the most serious diseases—whether it be a "
                "heart attack, kidney failure, ankylosing spondylitis or Parkinson’s "
                "disease—is a disorganized lifestyle. These seminars were organized "
                "to protect people from serious illnesses in the future and to bring "
                "beautiful smiles to their faces.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The International Reflexology Jain Association celebrates June 1 "
                "every year as Jin Reflexology Day. Over the past two years, 55 health "
                "seminars have been organized through this series by leading "
                "institutions across the country. These seminars explained topics such "
                "as Jin Reflexology, healthy lifestyle practices, and other important "
                "life-changing factors through computerized PowerPoint presentations, "
                "and participants’ questions were also addressed. Thousands of people "
                "have benefited from these seminars.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "This grand campaign was launched two years ago under the guidance "
                "of the Chief Editor of the Lokmat Group, the respected Rajendra "
                "Babuji Darda. Lokmat has played a crucial role as a media partner "
                "in taking this initiative to the masses.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "The success of the 21-day programs was largely due to the "
                "contributions of the main speaker, JIN Reflexology Inventor "
                "JR Anil Jain, along with JR Shilpa Jain, JR Anuprita Gandhi, "
                "JR Sapna Gandhi, JR Monika Kathed, JR Mayuri Surana and "
                "JR Anita Surana from Mumbai. A committee of 10 members was "
                "also formed to systematically implement all these activities. "
                "Key members of this committee included the guide Rajendra "
                "Babuji Darda, Rajkumar Jain, Lalit Gandhi, Dr. Nirmala Parghi "
                "(Mumbai), Dr. Sapna Patni (Dhule), Naresh Lalwani, Sandeep "
                "Kathed, Vimlesh Gandhi and Kalpesh Gandhi. This information "
                "was provided by the coordinator, JR Anil Jain. For participation "
                "in free seminars and to view them on YouTube and Facebook, "
                "please use the following link:",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 10,),

          const Text(
            "www.jinreflexology.in/jin23",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),

          SizedBox(height: 16,),

          const Text(
            "Schedule of JIN Reflexology Day Event – 1st to 21st June, 2023",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 16,),

          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey,
          ),

          SizedBox(height: 16,),

          const Text(
            "Glimpses of JIN Reflexology Day Event – 2022 ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                height: 1.6,
                fontWeight: FontWeight.w600
            ),
          ),

          SizedBox(height: 16,),

          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey,
          ),





        ],
      ),
    );
  }
}