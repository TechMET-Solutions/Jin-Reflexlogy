import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MarkingProcedureScreen extends StatelessWidget {
  const MarkingProcedureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        "step": "Step 1",
        "color": Colors.green,
        "desc":
            "Mark the cervical end point C1 and after T1. Draw vertical and horizontal line as shown in figure.",
        "images": "assets/images/marking_two.png",
      },
      {
        "step": "Step 2",
        "color": Colors.orange,
        "desc":
            "Mark the spinal cord and reflex point on foot as shown in the picture.",
        "images": "assets/images/marking_three.png",
      },
      {
        "step": "Step 3",
        "color": Colors.purple,
        "desc":
            "Draw line from Coccyx to Lumber-3 (slight tilt insight from L4).",
        "images": "assets/images/marking_four.png",
      },
      {
        "step": "Step 4",
        "color": Colors.green,
        "desc":
            "With the help of scale, keeping it straight on the foot, draw a straight line on sole between the marked reflex point cervical and spinal cord end point as shown in picture.",
        "images": "assets/images/marking_five.png",
      },
      {
        "step": "Step 5",
        "color": Colors.blue,
        "desc":
            "Mark the cervical (C1–C7) reflex point on the sole as shown in picture.",
        "images": "assets/images/marking_seven.png",
      },
      {
        "step": "Step 6",
        "color": Colors.red,
        "desc": "Mark the diaphragm line on the sole as shown in the picture.",
        "images": "assets/images/marking_eight.png",
      },
      {
        "step": "Step 7",
        "color": Colors.orange,
        "desc": "Mark the sciatica line on the sole as shown in the picture.",
        "images": "assets/images/marking_nine.png",
      },
      {
        "step": "Step 8",
        "color": Colors.red,
        "desc":
            "Mark the Thoracic T1–T12 reflex point as shown in the picture.",
        "images": "assets/images/marking_ten.png",
      },
      {
        "step": "Step 9",
        "color": Colors.purple,
        "desc": "Mark the Lumbar L1–L5 reflex point as shown in the picture.",
        "images": "assets/images/marking_eleven.png",
      },
      {
        "step": "Step 10",
        "color": Colors.green,
        "desc":
            "Mark the Sacrum and Coccyx reflex point position as shown in the picture.",
        "images": "assets/images/marking_twelve.png",
      },
      {
        "step": "Step 11",
        "color": Colors.orange,
        "desc":
            "Once you get the marking on your foot, you are now ready for diagnosis and treatment by Jain Reflexology Acupressure Therapy.",
        "images": "assets/images/marking_thirteen.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF130442),
        title: const Text(
          'Marking Procedures',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(12),
              //   child: Image.asset(
              //     'assets/images/head_marking.png',
              //     fit: BoxFit.cover,
              //   ),
              // ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:  EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: HexColor("#F7C85A"),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Center(
                  child: Text(
                    'Marking Procedures',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/marking_one.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

          GridView.builder(
            padding: const EdgeInsets.all(12),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.55,
            ),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return Card(
                color: HexColor("#F7C85A").withOpacity(0.50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        step["images"].toString(), // first image for card
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // TEXT AREA
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step["step"].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            step["desc"].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
