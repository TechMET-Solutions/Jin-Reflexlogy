import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
String getYoutubeThumbnail(String videoUrl) {
    // Extract video ID from URL
    final videoId = videoUrl.split('/').last;
    // Return high quality thumbnail URL
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

class FootRelaxingScreen extends StatelessWidget {
  const FootRelaxingScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // YouTube thumbnail URL generator function
  String getYoutubeThumbnail(String videoUrl) {
    // Extract video ID from URL
    final videoId = videoUrl.split('/').last;
    // Return high quality thumbnail URL
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

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
                youtubeLink: "https://youtu.be/z19XMdXtg04",
              ),
              const SizedBox(height: 20),
              twistingCard(
                "Deep Pressure",
                "assets/images/relax2.jpg",
                "The patient sits with legs stretched while the practitioner sits upright nearby. Treatment begins with the left foot, either on the floor or with the patient seated on a couch. Before applying pressure to reflex points, tension in the legs is released. This preparation ensures better results from the treatment.",
                imageLeft: false,
                youtubeLink: "https://youtu.be/NMS66whOazY",
              ),
              const SizedBox(height: 20),
              twistingCard(
                "Pressure on reflex point of spinal",
                "assets/images/relax3.jpg",
                "Holding the leg firmly with right hand and with the fist of the other hand clenched (as shown in picture) press the feet starting from the upper portion and move downwards pressing gently just like kneading the dough, either on the floor or with the patient seated on a couch. Before applying pressure to reflex points, tension in the legs is released. This preparation ensures better results from the treatment.",
                imageLeft: true,
                youtubeLink: "https://youtu.be/oW_PeDHgkmg",
              ),
              SizedBox(height: 20),
              twistingCard(
                "Rotating of ankle",
                "assets/images/relax4.jpg",
                "Resting all the four fingers of left hand against the foot, apply gentle pressure on the reflex points stretching from thumb to leg.",
                imageLeft: false,
                youtubeLink: "https://youtu.be/k7Rhl1GdJWg",
              ),
              SizedBox(height: 20),
              twistingCard(
                "Foot Massage",
                "assets/images/relax5.jpg",
                "Rotate the leg gently in both directions while holding the ankle to relax the muscles. Foot massage stimulates circulation and releases tension. Pressing reflex points helps identify stressed organs, often using a jimmy or rounded tool. This allows simple, low-cost diagnosis and treatment",
                imageLeft: true,
                youtubeLink: "https://youtu.be/zaMfEmwkiS8",
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
                "Type of pressure to be given on the reflex point of head or brain",
                "assets/images/relax6.jpg",
                "Rotate the leg gently in both directions while holding the ankle to relax the muscles. Foot massage stimulates circulation and releases tension. Pressing reflex points helps identify stressed organs, often using a jimmy or rounded tool. This allows simple, low-cost diagnosis and treatment",
                imageLeft: true,
                youtubeLink: "https://youtu.be/z19XMdXtg04",
              ),
              const SizedBox(height: 20),
              foottwistingCard(
                "Type of pressure to be given on the other reflex point",
                "assets/images/relax7.jpg",
                "Hold the foot with one hand firmly with Jimmy in another hand. Put the normal pressure according to the comfort level of the patient. We can increase the pressure gradually as per the comfort level of the patient. Pressure could be given for three to five seconds which could be repeated for three times intermittently.",
                imageLeft: false,
                youtubeLink: "https://youtu.be/NMS66whOazY",
              ),
              const SizedBox(height: 20),
              foottwistingCard(
                "Sitting Position (Self-Therapy)",
                "assets/images/relax8.jpg",
                "If one has to take the acupressure treatment oneself, sit on chair or couch, fold one leg and rest it on the other (as shown in the picture) and apply pressure on the reflex points",
                imageLeft: false,
                youtubeLink: "https://youtu.be/oW_PeDHgkmg",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget twistingCard(String title, String img, String text, {bool imageLeft = true, String? youtubeLink}) {
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
            child: Center(
              child: Text(
                title,
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

          // ---------------- YOUTUBE THUMBNAIL ----------------
          if (youtubeLink != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: GestureDetector(
                onTap: () => _launchURL(youtubeLink),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Thumbnail Image
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          getYoutubeThumbnail(youtubeLink),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.videocam_off, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'Video Preview',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // Play Button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    
                    // "Watch Video" Text
                    Positioned(
                      bottom: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Watch Video Tutorial',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget foottwistingCard(String title, String img, String text, {bool imageLeft = true, String? youtubeLink}) {
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
            child: Center(
              child: Text(
                title,
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

          // ---------------- YOUTUBE THUMBNAIL ----------------
          if (youtubeLink != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              child: GestureDetector(
                onTap: () => _launchURL(youtubeLink),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Thumbnail Image
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          getYoutubeThumbnail(youtubeLink),
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.videocam_off, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'Video Preview',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // Play Button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    
                    // "Watch Video" Text
                    Positioned(
                      bottom: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Watch Video Tutorial',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}