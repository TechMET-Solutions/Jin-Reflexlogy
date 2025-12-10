import 'package:flutter/material.dart';

class Treatment extends StatelessWidget {
  Treatment({super.key});

  final List<String> items = [
    "Acidity", "Anaemia", "Anorexia", "Arthritis", "Asthma", "Headache",
    "Blood Pressure Low", "Blood Pressure High", "Cold", "Cough",
    "Flatulence", "Constipation", "Diabetes", "Diarrhoea", "Ear Ache",
    "Eczema", "Epilepsy", "Epistaxis", "Eye Diseases", "Piles / Hemorrhoid",
    "Osteomalacia", "Giddiness / vertigo", "Gout / Rheumatism", "Urticaria",
    "Acne", "Lumbago", "Sciatica", "Deafness", "Gall Stone",
    "Jaundice / Icterus", "Dysmenorrhoea", "Obesity",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0E6D6), width: 2),
          ),
          child: Column(
            children: [
              // IMAGE BOX
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF7C85A), width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50),
                ),
              ),

              const SizedBox(height: 10),

              // TITLE
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "JIN Reflexology E-Book (English)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ITEMS GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => TreatmentDetailsScreen(
                          title: items[index],
                        ),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8E8C5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF7C85A), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          items[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}






class TreatmentDetailsScreen extends StatelessWidget {
  final String title;

  const TreatmentDetailsScreen({super.key, required this.title});

  Widget sectionBox(String heading, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7C85A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF7C85A), width: 2),
          ),
          child: Text(
            "$heading :",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 5),

        // Description Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8E8C5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF7C85A), width: 2),
          ),
          child: Text(
            desc,
            style: const TextStyle(fontSize: 15),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const sampleText =
        "Hold the upper portion of leg with left hand and lower portion "
        "with right hand (as depicted in picture) and move the foot "
        "twist just as clothes are squeezed after having been washed.";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7C85A),
        title: Text(title),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            sectionBox("Acidity", sampleText),
            sectionBox("Causes", sampleText),
            sectionBox("Symptoms", sampleText),
            sectionBox("Regimen", sampleText),
            sectionBox("Main Point", sampleText),
            sectionBox("Related Points", sampleText),
            sectionBox("Using Micro Magnet", sampleText),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF7C85A)),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF7C85A)),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
