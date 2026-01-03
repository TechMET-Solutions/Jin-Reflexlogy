import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FootRelaxingScreen extends StatelessWidget {
  const FootRelaxingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color(0xFF130442),
        title: const Text(
          'Relaxing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange.shade300, width: 2),
                ),
                child: Icon(Icons.phone),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "Foot Relaxing",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              twistingCard(
                "Twisting of legs", 
                "assets/images/relaxing.png",
                "The patient sits with legs stretched while the practitioner sits upright nearby. Treatment begins with the left foot, either on the floor or with the patient seated on a couch. Before applying pressure to reflex points, tension in the legs is released. This preparation ensures better results from the treatment.",
              ),
              const SizedBox(height: 20),
              twistingCard(
                "Deep Pressure",
                "assets/images/relax2.jpg",
                "The patient sits with legs stretched while the practitioner sits upright nearby. Treatment begins with the left foot, either on the floor or with the patient seated on a couch. Before applying pressure to reflex points, tension in the legs is released. This preparation ensures better results from the treatment.",
                imageLeft: false,
              ),
              const SizedBox(height: 20),
              twistingCard(
                "Pressure on reflex point of spinal",
                "assets/images/relax3.jpg",
                "Holding the leg firmly with right hand and with the fist of the other hand clenched (as shown in picture) press the feet starting from the upper portion and move downwards pressing gently just like kneading the dough, either on the floor or with the patient seated on a couch. Before applying pressure to reflex points, tension in the legs is released. This preparation ensures better results from the treatment.",
                imageLeft: true,
              ),
              SizedBox(height: 20),
              twistingCard(
                "Rotating of ankle",
                "assets/images/relax4.jpg",
                "Resting all the four fingers of left hand against the foot, apply gentle pressure on the reflex points stretching from thumb to leg.",
                imageLeft: false,
              ),
               SizedBox(height: 20),
              twistingCard(
                "Foot Massage",
                "assets/images/relax5.jpg",
                "Rotate the leg gently in both directions while holding the ankle to relax the muscles. Foot massage stimulates circulation and releases tension. Pressing reflex points helps identify stressed organs, often using a jimmy or rounded tool. This allows simple, low-cost diagnosis and treatmen",
                imageLeft: true,
              ),

              SizedBox(height: 15,),
                   Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: HexColor("#D7B59E"),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "Foot Relaxing",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
               foottwistingCard(
                "ype of pressure to be given on the reflex point of head or brain",
                "assets/images/relax6.jpg",
                "Rotate the leg gently in both directions while holding the ankle to relax the muscles. Foot massage stimulates circulation and releases tension. Pressing reflex points helps identify stressed organs, often using a jimmy or rounded tool. This allows simple, low-cost diagnosis and treatmen",
                imageLeft: true,
              ),
               const SizedBox(height: 20),
               foottwistingCard(
                "Type of pressure to be given on the other reflex point",
                "assets/images/relax7.jpg",
                "Hold the foot with one hand firmly with Jimmy in another hand. Put the normal pressure according to the comfort level of the patient. We can increase the pressure gradually as per the comfort level of the patient. Pressure could be given for three to five seconds which could be repeated for three times intermittently.",
                imageLeft: false,
              ),
                const SizedBox(height: 20),
               foottwistingCard(
                "Sitting Position (Self-Therapy)",
                "assets/images/relax8.jpg",
                "If one has to take the acupressure treatment oneself, sit on chair or couch, fold one leg and rest it on the other (as shown in the picture) and apply pressure on the reflex points",
                imageLeft: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget twistingCard(String title, String img, String text, {bool imageLeft = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------------- TITLE ----------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE1A8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child:  Center(
              child: Text(
                "$title",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ---------------- IMAGE + TEXT ROW ----------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  imageLeft
                      ? [
                        // IMAGE LEFT
                        ClipOval(
                          child: Image.asset(
                            img,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // TEXT RIGHT
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ]
                      : [
                        // TEXT LEFT
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // IMAGE RIGHT
                        ClipOval(
                          child: Image.asset(
                            img,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
            ),
          ),
        ],
      ),
    );
  }

  Widget foottwistingCard(String title, String img, String text, {bool imageLeft = true}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HexColor("#D7B59E"), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------------- TITLE ----------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: HexColor("#D7B59E").withOpacity(0.30),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              border: Border.all(color: const Color(0xFFFFE1A8), width: 1),
            ),
            child:  Center(
              child: Text(
                "$title",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ---------------- IMAGE + TEXT ROW ----------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  imageLeft
                      ? [
                        // IMAGE LEFT
                        ClipOval(
                          child: Image.asset(
                            img,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // TEXT RIGHT
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ]
                      : [
                        // TEXT LEFT
                        Expanded(
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // IMAGE RIGHT
                        ClipOval(
                          child: Image.asset(
                            img,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
            ),
          ),
        ],
      ),
    );
  }
}
