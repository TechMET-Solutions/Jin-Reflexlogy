import 'package:flutter/material.dart';

class ReflexologyScreen extends StatelessWidget {
  const ReflexologyScreen({super.key});

  void _showInfoPopup(BuildContext context, String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imageUrl, height: 150, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2A66),
        title: const Text('JIN Reflexology',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Please touch point to see details and pictures",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/left_hand.png",
                    width: 320,
                    fit: BoxFit.contain,
                  ),

                  // ===================== DOT POSITIONS =====================
                  ..._dotsData(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _dotsData(BuildContext context) {
    // Positions (x,y,color,title,image)
    final List<Map<String, dynamic>> dots = [
      // --- Finger Tips ---
      {'top': 30.0, 'left': 130.0, 'color': Colors.red, 'title': 'Brain', 'img': 'https://cdn.pixabay.com/photo/2016/11/18/14/37/brain-1837417_1280.jpg'},
      {'top': 25.0, 'left': 170.0, 'color': Colors.orange, 'title': 'Sinus', 'img': 'https://cdn.pixabay.com/photo/2020/04/20/16/36/sinus-5069471_1280.jpg'},
      {'top': 20.0, 'left': 210.0, 'color': Colors.yellow, 'title': 'Eyes', 'img': 'https://cdn.pixabay.com/photo/2013/07/12/18/39/eye-153545_1280.png'},
      {'top': 30.0, 'left': 250.0, 'color': Colors.purple, 'title': 'Neck Nerve', 'img': 'https://cdn.pixabay.com/photo/2016/12/19/11/31/neck-1913228_1280.jpg'},
      {'top': 45.0, 'left': 280.0, 'color': Colors.pink, 'title': 'Head', 'img': 'https://cdn.pixabay.com/photo/2014/04/03/10/32/head-309055_1280.png'},

      // --- Upper Palm ---
      {'top': 120.0, 'left': 150.0, 'color': Colors.blue, 'title': 'Throat', 'img': 'https://cdn.pixabay.com/photo/2017/01/29/14/53/throat-2019909_1280.png'},
      {'top': 120.0, 'left': 200.0, 'color': Colors.green, 'title': 'Lungs', 'img': 'https://cdn.pixabay.com/photo/2014/04/02/10/56/lungs-303778_1280.png'},
      {'top': 130.0, 'left': 240.0, 'color': Colors.cyan, 'title': 'Thymus', 'img': 'https://cdn.pixabay.com/photo/2022/02/03/08/49/thymus-6991065_1280.png'},
      {'top': 160.0, 'left': 180.0, 'color': Colors.redAccent, 'title': 'Heart', 'img': 'https://cdn.pixabay.com/photo/2016/03/31/19/14/heart-1290871_1280.png'},

      // --- Center Palm ---
      {'top': 200.0, 'left': 150.0, 'color': Colors.teal, 'title': 'Liver', 'img': 'https://cdn.pixabay.com/photo/2016/04/24/22/14/liver-1355073_1280.png'},
      {'top': 210.0, 'left': 210.0, 'color': Colors.deepOrange, 'title': 'Stomach', 'img': 'https://cdn.pixabay.com/photo/2017/03/02/21/57/stomach-2113942_1280.png'},
      {'top': 230.0, 'left': 170.0, 'color': Colors.lightGreen, 'title': 'Pancreas', 'img': 'https://cdn.pixabay.com/photo/2021/09/16/15/41/pancreas-6630218_1280.png'},
      {'top': 240.0, 'left': 220.0, 'color': Colors.amber, 'title': 'Small Intestine', 'img': 'https://cdn.pixabay.com/photo/2017/03/02/22/02/intestine-2113943_1280.png'},

      // --- Lower Palm ---
      {'top': 270.0, 'left': 180.0, 'color': Colors.brown, 'title': 'Kidney', 'img': 'https://cdn.pixabay.com/photo/2013/07/13/14/15/kidney-162413_1280.png'},
      {'top': 290.0, 'left': 230.0, 'color': Colors.indigo, 'title': 'Colon', 'img': 'https://cdn.pixabay.com/photo/2014/04/03/11/53/colon-311355_1280.png'},
      {'top': 310.0, 'left': 190.0, 'color': Colors.blueGrey, 'title': 'Bladder', 'img': 'https://cdn.pixabay.com/photo/2016/09/07/15/19/urinary-1652202_1280.png'},

      // --- Thumb Side ---
      {'top': 130.0, 'left': 100.0, 'color': Colors.deepPurple, 'title': 'Shoulder', 'img': 'https://cdn.pixabay.com/photo/2016/03/31/20/36/shoulder-1291416_1280.png'},
      {'top': 200.0, 'left': 100.0, 'color': Colors.pinkAccent, 'title': 'Elbow', 'img': 'https://cdn.pixabay.com/photo/2017/03/02/21/57/elbow-2113944_1280.png'},
      {'top': 270.0, 'left': 110.0, 'color': Colors.cyanAccent, 'title': 'Spine', 'img': 'https://cdn.pixabay.com/photo/2012/04/13/12/54/spine-32831_1280.png'},

      // --- Outer Edge (Little Finger Side) ---
      {'top': 130.0, 'left': 270.0, 'color': Colors.redAccent, 'title': 'Neck', 'img': 'https://cdn.pixabay.com/photo/2016/12/19/11/31/neck-1913228_1280.jpg'},
      {'top': 180.0, 'left': 280.0, 'color': Colors.greenAccent, 'title': 'Arm', 'img': 'https://cdn.pixabay.com/photo/2017/03/02/21/57/arm-2113944_1280.png'},
      {'top': 250.0, 'left': 285.0, 'color': Colors.deepOrangeAccent, 'title': 'Hip', 'img': 'https://cdn.pixabay.com/photo/2012/04/13/12/54/pelvis-32832_1280.png'},
      {'top': 300.0, 'left': 290.0, 'color': Colors.tealAccent, 'title': 'Leg', 'img': 'https://cdn.pixabay.com/photo/2017/03/02/21/57/leg-2113944_1280.png'},
    ];

    return dots
        .map((dot) => Positioned(
              top: dot['top'],
              left: dot['left'],
              child: GestureDetector(
                onTap: () => _showInfoPopup(context, dot['title'], dot['img']),
                child: DotWidget(color: dot['color']),
              ),
            ))
        .toList();
  }
}

class DotWidget extends StatelessWidget {
  final Color color;
  const DotWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(1, 1))
        ],
      ),
    );
  }
}
