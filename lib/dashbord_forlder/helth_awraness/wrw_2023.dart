import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/health_campaign_pdf_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Wrw2023Screen extends StatefulWidget {
  const Wrw2023Screen({super.key});

  @override
  State<Wrw2023Screen> createState() => _Wrw2023ScreenState();
}

class _Wrw2023ScreenState extends State<Wrw2023Screen> {
  bool _expanded = false;

  static const String _pdfUrl =
      "https://jinreflexology.in/wp-content/uploads/2026/01/2023Glimpsesall.pdf";

  Future<void> _openPdf() async {
    final uri = Uri.tryParse(_pdfUrl);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Health Awareness – 2023"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _expandableHeader("Health awareness seminars conclude"),
                if (_expanded) ...[
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      "India’s Biggest Health Awareness Campaign",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "22 seminars held in 18 cities across 4 states.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "The International Reflexology JIN Association organizes various health awareness programs every year from JIN Reflexology Day (June 1st) to International Yoga Day (June 21st). Continuing this tradition, this year, 22 health awareness seminars were organized in 18 cities over these 21 days, from June 1st to June 21st.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The program concluded on Sunday, July 2nd, in Kukshi, Dhar district, with an event organized by Allegiance Academy, coinciding with the 100th birth anniversary of the respected Jawaharlal Darda, a senior freedom fighter and founder and editor of the Lokmat Group.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The program began with tributes to Jawaharlal Darda.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The main speaker, JIN Reflexology researcher JR Anil Jain, highlighted the unique features of JIN Reflexology, stating that among the more than 200 medical systems available worldwide, JIN Reflexology is the only one after Ayurveda that accurately diagnoses diseases without asking the patient any questions, and informs the patient about all their ailments.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "There is a great need for health awareness seminars today. In India, 61 percent of deaths each year are due to non-communicable diseases. No significant efforts are being made across the country to prevent this. After conducting research on thousands of patients, it was concluded that the root cause of even the most serious diseases, whether it be a heart attack, kidney failure, ankylosing spondylitis, or Parkinson’s disease, is a disorganized lifestyle. These seminars were organized to protect people from serious illnesses in the future and to bring beautiful smiles to their faces.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The International Reflexology JIN Association celebrates June 1st every year as JIN Reflexology Day. Over the past two years, 55 health seminars have been organized through this series of health seminars by leading institutions across the country. These seminars explained topics such as JIN Reflexology, healthy lifestyle, and other important life-changing factors through computerized PowerPoint presentations, and participants’ questions were also addressed. Thousands of people have benefited from these seminars.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This grand campaign was launched two years ago under the guidance of the Chief Editor of the Lokmat Group, the respected Rajendra Babuji Darda. Lokmat has played a crucial role as a media partner in taking this initiative to the masses.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "The success of the 21-day programs was largely due to the contributions of the main speaker, JIN Reflexology Inventor, JR Anil Jain, along with JR Shilpa Jain, JR Anuprita Gandhi, JR Sapna Gandhi, JR Monika Kathed, JR Mayuri Surana, and JR Anita Surana from Mumbai. A committee of 10 members was also formed to systematically implement all these activities. Key members of this committee included the guide Rajendra Babuji Darda, Rajkumar Jain, Lalit Gandhi, Dr. Nirmala Parghi (Mumbai), Dr. Sapna Patni (Dhule), Naresh Lalwani, Sandeep Kathed, Vimlesh Gandhi, and Kalpesh Gandhi. This information was provided by the convener, JR Anil Jain. For participation in free seminars and to view them on YouTube and Facebook.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  "2023 Glimpses PDF",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Center(
                //   child: OutlinedButton.icon(
                //     onPressed: _openPdf,
                //     icon: const Icon(Icons.open_in_new),
                //     label: const Text("Open PDF"),
                //   ),
                // ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 560,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const CampaignPdfViewer(year: 2023),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
