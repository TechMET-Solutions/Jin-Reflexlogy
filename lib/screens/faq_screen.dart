import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Simple, modern FAQ screen inspired by your screenshots.
// Save this file as `lib/faq_screen.dart` and add `google_fonts` to pubspec.yaml.

class FaqItem {
  final String question;
  final String answer;
  final Color headerColor;

  FaqItem({
    required this.question,
    required this.answer,
    required this.headerColor,
  });
}

final List<FaqItem> sampleFaqs = [
  FaqItem(
    question:
        'Q1–I am suffering from diabetes and take medicines regularly. Can I stop taking medicines while undergoing acupressure treatment ?',
    answer:
        'You first take acupressure treatment for 15 days. Then get blood test done. After that you can consult your doctor for reducing the dose or stopping it altogether.',
    headerColor: Color(0xFFE57373),
  ),
  FaqItem(
    question:
        'Q2–Does acupressure treatment take longer time for treating a disease ?',
    answer:
        'No, Acupressure gives instant relief for diseases cropping all of a sudden. For the diseases which are there for a long time the therapy should be used for the period of as many months as the years the disease is there.',
    headerColor: Color(0xFF8BC34A),
  ),
  FaqItem(
    question:
        'Q3–I have a pain in my neck for many years. Can I get cured early by giving pressure on the reflex points for seven-eight times?',
    answer:
        'No, do not do it. The pressure on reflected centres should not be more than you can bear. Reflex point are very sensitive. By applying excess pressure on them, their sensitivity might become less. This treatment should be used twice everyday with a gap of eight hours. To cure yourself quickly, take advice from the nearest acupressure specialist.',
    headerColor: Color(0xFF3949AB),
  ),
  FaqItem(
    question:
        'Q4–My digestive system is not working properly. Can I apply pressure on the reflected Point of digestive system and cure it?',
    answer:
        'Yes, you can. Along with it, you should remove the main causes of the disease as well as adopt healthy life style which include avoiding spicy food, after dinner keep a time gap of at least two hours before going to sleep etc.',
    headerColor: Color(0xFF9C27B0),
  ),
  FaqItem(
    question: 'Q5–Does the pain increase by using acupressure therapy ?',
    answer:
        'No. The pain does not increase. But sometimes it is felt that the pain increases. In fact, it is a part of curing process. For example if there is wound on our body and when it starts healing we experience that the pain has increased or it starts itching. If the pain is felt to increase then one can ignore it. However, if remains the same for three days or more, then consult an expert.',
    headerColor: Color(0xFF29B6F6),
  ),
  FaqItem(
    question: 'Q6–Can acupressure therapy benefit all patients ?',
    answer:
        'The research conducted till today has proved that the therapy is beneficial to 90 percent of patients. It is not necessary that each and every patient should be benefitted by this therapy. The disease of each patient is different, so also his physical and mental conditions. Therefore, the effects are also different. In some cases, the disease is cured quickly, while for others, it may take longer time. If the therapy, being given by an acupressure expert continuously for seven days, does not have any effect, then it should be understood that the therapy is not meant for that patient. Therefore, some other therapy should be used.',
    headerColor: Color(0xFF4DB6AC),
  ),
  FaqItem(
    question:
        'Q7–Is there a necessity to press the reflection centres in palms after pressing the reflection centres in feet ?',
    answer:
        'No. There are seperate therapies for reflection centres in palms and feet which are effective. If you have applied pressure on the reflection centres in the feet, there is no need to apply pressure in the reflection centres in palms. Similarly, the use of micro magnets should also be under foot. If you have used the micro magnet for 15 minutes in the reflection centres in the feet, then there is no need to use the micro magnets on the reflection centres on palms.',
    headerColor: Color(0xFFFF9800),
  ),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F3F6),
      appBar: AppBar(
        
        backgroundColor: Color(0xFF041C51),
        leading: Icon(Icons.arrow_back,),
        title: Text(
          'FAQ',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: ListView.separated(
          itemCount: sampleFaqs.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final faq = sampleFaqs[index];
            return FaqCard(faq: faq, index: index + 1);
          },
        ),
      ),
    );
  }
}


class FaqCard extends StatefulWidget {
  final FaqItem faq;
  final int index;

  const FaqCard({Key? key, required this.faq, required this.index})
    : super(key: key);

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F0E3), // light cream background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (Q text + arrow)
            InkWell(
              onTap: () {
                setState(() => isExpanded = !isExpanded);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT STRIPE COLOR
                  Container(
                    width: 6,
                    height: isExpanded ? null : 100,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),

                  // QUESTION TEXT
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Text(
                        widget.faq.question,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF1C1C1C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // ARROW ICON
                  Padding(
                    padding: const EdgeInsets.only(right: 10, top: 5),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF1C1C1C),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // Answer
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Text(
                  widget.faq.answer,
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    color: const Color(0xFF4F4F4F),
                    height: 1.45,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
