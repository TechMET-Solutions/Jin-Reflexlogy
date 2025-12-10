import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

// class RightLage extends StatefulWidget {
//   const RightLage({super.key});

//   @override
//   State<RightLage> createState() => _RightLageState();
// }

// class _RightLageState extends State<RightLage> {
//   // FIXED original image size
//   final double imageWidth = 400;
//   final double imageHeight = 900;

//   double ringX = 200;
//   double ringY = 400;
//   double ringRadius = 80;
//   double angle = 0;

//   // STATIC DOTS — ORIGINAL COORDINATES (NEVER CHANGE)
//   List<Map<String, dynamic>> circles = [
//     {"x": 47.9, "y": 188.2, "state": 0},
//     {"x": 92.0, "y": 98.0, "state": 0},
//     {"x": 137.0, "y": 61.0, "state": 0},
//     {"x": 178.6, "y": 28.4, "state": 0},
//     {"x": 278.3, "y": 48.6, "state": 0},
//     {"x": 302.0, "y": 48.6, "state": 0},
//     {"x": 298.6, "y": 123.0, "state": 0},
//     {"x": 345.9, "y": 97.6, "state": 0},
//     {"x": 344.2, "y": 126.4, "state": 0},
//     {"x": 271.6, "y": 165.2, "state": 0},
//     {"x": 293.5, "y": 168.6, "state": 0},
//     {"x": 322.2, "y": 166.9, "state": 0},
//     {"x": 347.6, "y": 158.4, "state": 0},
//     {"x": 266.5, "y": 204.1, "state": 0},
//     {"x": 296.9, "y": 200.7, "state": 0},
//     {"x": 327.3, "y": 205.7, "state": 0},
//     {"x": 352.6, "y": 193.9, "state": 0},
//     {"x": 356.0, "y": 226.0, "state": 0},
//     {"x": 323.9, "y": 241.2, "state": 0},
//     {"x": 296.9, "y": 241.2, "state": 0},
//     {"x": 268.2, "y": 241.2, "state": 0},
//     {"x": 361.1, "y": 259.8, "state": 0},
//     {"x": 361.1, "y": 288.5, "state": 0},
//     {"x": 325.6, "y": 286.8, "state": 0},
//     {"x": 296.9, "y": 280.1, "state": 0},
//     {"x": 264.8, "y": 286.8, "state": 0},
//     {"x": 356.0, "y": 317.2, "state": 0},
//     {"x": 178.6, "y": 151.7, "state": 0},
//     {"x": 149.9, "y": 156.8, "state": 0},
//     {"x": 143.2, "y": 178.7, "state": 0},
//     {"x": 124.6, "y": 192.2, "state": 0},
//     {"x": 139.8, "y": 197.3, "state": 0},
//     {"x": 134.7, "y": 210.8, "state": 0},
//     {"x": 126.3, "y": 227.7, "state": 0},
//     {"x": 116.1, "y": 242.9, "state": 0},
//     {"x": 75.6, "y": 226.0, "state": 0},
//     {"x": 60.4, "y": 256.4, "state": 0},
//     {"x": 41.8, "y": 280.1, "state": 0},
//     {"x": 36.8, "y": 305.4, "state": 0},
//     {"x": 33.4, "y": 330.7, "state": 0},
//     {"x": 31.7, "y": 357.8, "state": 0},
//     {"x": 35.1, "y": 383.1, "state": 0},
//     {"x": 40.1, "y": 415.2, "state": 0},
//     {"x": 48.6, "y": 449.0, "state": 0},
//     {"x": 52.0, "y": 477.7, "state": 0},
//     {"x": 53.6, "y": 506.4, "state": 0},
//     {"x": 57.0, "y": 538.5, "state": 0},
//     {"x": 63.8, "y": 565.5, "state": 0},
//     {"x": 67.2, "y": 599.3, "state": 0},
//     {"x": 70.5, "y": 628.0, "state": 0},
//     {"x": 77.3, "y": 658.4, "state": 0},
//     {"x": 75.6, "y": 690.5, "state": 0},
//     {"x": 77.3, "y": 722.6, "state": 0},
//     {"x": 75.6, "y": 751.4, "state": 0},
//     {"x": 75.6, "y": 778.4, "state": 0},
//     {"x": 84.1, "y": 803.7, "state": 0},
//     {"x": 104.3, "y": 830.7, "state": 0},
//     {"x": 175.3, "y": 874.7, "state": 0},
//     {"x": 236.1, "y": 832.4, "state": 0},
//     {"x": 205.7, "y": 830.7, "state": 0},
//     {"x": 173.6, "y": 830.7, "state": 0},
//     {"x": 136.4, "y": 832.4, "state": 0},
//     {"x": 249.6, "y": 803.7, "state": 0},
//     {"x": 222.6, "y": 803.7, "state": 0},
//     {"x": 192.2, "y": 802.0, "state": 0},
//     {"x": 166.8, "y": 805.4, "state": 0},
//     {"x": 141.5, "y": 803.7, "state": 0},
//     {"x": 112.8, "y": 803.7, "state": 0},
//     {"x": 254.7, "y": 780.1, "state": 0},
//     {"x": 229.3, "y": 778.4, "state": 0},
//     {"x": 204.0, "y": 778.4, "state": 0},
//     {"x": 170.2, "y": 778.4, "state": 0},
//     {"x": 138.1, "y": 780.1, "state": 0},
//     {"x": 106.0, "y": 778.4, "state": 0},
//     {"x": 273.2, "y": 749.7, "state": 0},
//     {"x": 249.6, "y": 748.0, "state": 0},
//     {"x": 219.2, "y": 748.0, "state": 0},
//     {"x": 193.9, "y": 746.3, "state": 0},
//     {"x": 170.2, "y": 748.0, "state": 0},
//     {"x": 148.2, "y": 746.3, "state": 0},
//     {"x": 122.9, "y": 751.4, "state": 0},
//     {"x": 100.9, "y": 749.7, "state": 0},
//     {"x": 271.6, "y": 724.3, "state": 0},
//     {"x": 247.9, "y": 724.3, "state": 0},
//     {"x": 220.9, "y": 719.3, "state": 0},
//     {"x": 192.2, "y": 720.9, "state": 0},
//     {"x": 158.4, "y": 715.9, "state": 0},
//     {"x": 131.4, "y": 715.9, "state": 0},
//     {"x": 104.3, "y": 717.6, "state": 0},
//     {"x": 269.9, "y": 697.3, "state": 0},
//     {"x": 268.2, "y": 673.6, "state": 0},
//     {"x": 269.1, "y": 651.0, "state": 0},
//     {"x": 272.2, "y": 619.9, "state": 0},
//     {"x": 275.3, "y": 593.3, "state": 0},
//     {"x": 275.3, "y": 566.8, "state": 0},
//     {"x": 275.3, "y": 543.5, "state": 0},
//     {"x": 278.4, "y": 516.9, "state": 0},
//     {"x": 278.4, "y": 492.0, "state": 0},
//     {"x": 280.0, "y": 465.5, "state": 0},
//     {"x": 284.7, "y": 445.2, "state": 0},
//     {"x": 289.4, "y": 423.4, "state": 0},
//     {"x": 295.6, "y": 396.9, "state": 0},
//     {"x": 309.6, "y": 375.1, "state": 0},
//     {"x": 325.2, "y": 359.5, "state": 0},
//     {"x": 340.8, "y": 336.1, "state": 0},
//     {"x": 203.6, "y": 325.2, "state": 0},
//     {"x": 184.9, "y": 323.6, "state": 0},
//     {"x": 156.8, "y": 322.0, "state": 0},
//     {"x": 77.3, "y": 409.4, "state": 0},
//     {"x": 83.5, "y": 435.9, "state": 0},
//     {"x": 80.4, "y": 460.8, "state": 0},
//     {"x": 82.0, "y": 492.0, "state": 0},
//     {"x": 82.0, "y": 516.9, "state": 0},
//     {"x": 86.7, "y": 545.0, "state": 0},
//     {"x": 92.9, "y": 573.1, "state": 0},
//     {"x": 94.4, "y": 594.9, "state": 0},
//     {"x": 99.1, "y": 619.9, "state": 0},
//     {"x": 102.2, "y": 641.7, "state": 0},
//     {"x": 103.8, "y": 669.8, "state": 0},
//     {"x": 105.4, "y": 693.1, "state": 0},
//     {"x": 135.0, "y": 683.8, "state": 0},
//     {"x": 131.9, "y": 654.2, "state": 0},
//     {"x": 130.3, "y": 624.5, "state": 0},
//     {"x": 130.3, "y": 598.0, "state": 0},
//     {"x": 121.0, "y": 570.0, "state": 0},
//     {"x": 119.4, "y": 540.3, "state": 0},
//     {"x": 116.3, "y": 506.0, "state": 0},
//     {"x": 121.0, "y": 473.3, "state": 0},
//     {"x": 113.2, "y": 440.5, "state": 0},
//     {"x": 147.5, "y": 435.9, "state": 0},
//     {"x": 155.3, "y": 468.6, "state": 0},
//     {"x": 155.3, "y": 493.6, "state": 0},
//     {"x": 158.4, "y": 520.1, "state": 0},
//     {"x": 158.4, "y": 571.5, "state": 0},
//     {"x": 156.8, "y": 596.5, "state": 0},
//     {"x": 156.8, "y": 618.3, "state": 0},
//     {"x": 161.5, "y": 657.3, "state": 0},
//     {"x": 163.1, "y": 682.2, "state": 0},
//     {"x": 195.8, "y": 683.8, "state": 0},
//     {"x": 158.4, "y": 543.5, "state": 0},
//     {"x": 247.3, "y": 697.8, "state": 0},
//     {"x": 222.3, "y": 682.2, "state": 0},
//     {"x": 96.0, "y": 381.3, "state": 0},
//     {"x": 122.5, "y": 365.7, "state": 0},
//     {"x": 150.6, "y": 362.6, "state": 0},
//     {"x": 108.5, "y": 415.6, "state": 0},
//     {"x": 133.4, "y": 396.9, "state": 0},
//     {"x": 183.3, "y": 381.3, "state": 0},
//     {"x": 211.4, "y": 381.3, "state": 0},
//     {"x": 181.8, "y": 378.2, "state": 0},
//     {"x": 180.2, "y": 410.9, "state": 0},
//     {"x": 180.2, "y": 435.9, "state": 0},
//     {"x": 181.8, "y": 465.5, "state": 0},
//     {"x": 192.7, "y": 658.8, "state": 0},
//     {"x": 244.1, "y": 378.2, "state": 0},
//     {"x": 209.8, "y": 409.4, "state": 0},
//     {"x": 205.2, "y": 432.7, "state": 0},
//     {"x": 203.6, "y": 460.8, "state": 0},
//     {"x": 198.9, "y": 490.4, "state": 0},
//     {"x": 197.4, "y": 516.9, "state": 0},
//     {"x": 198.9, "y": 541.9, "state": 0},
//     {"x": 198.9, "y": 571.5, "state": 0},
//     {"x": 197.4, "y": 601.1, "state": 0},
//     {"x": 192.7, "y": 630.8, "state": 0},
//     {"x": 248.8, "y": 668.2, "state": 0},
//     {"x": 225.4, "y": 655.7, "state": 0},
//     {"x": 225.4, "y": 630.8, "state": 0},
//     {"x": 230.1, "y": 605.8, "state": 0},
//     {"x": 228.5, "y": 577.8, "state": 0},
//     {"x": 230.1, "y": 551.2, "state": 0},
//     {"x": 245.7, "y": 669.8, "state": 0},
//     {"x": 248.8, "y": 644.8, "state": 0},
//     {"x": 248.8, "y": 624.5, "state": 0},
//     {"x": 250.4, "y": 596.5, "state": 0},
//     {"x": 251.9, "y": 571.5, "state": 0},
//     {"x": 178.6, "y": 351.7, "state": 0},
//     {"x": 244.1, "y": 410.9, "state": 0},
//     {"x": 236.3, "y": 439.0, "state": 0},
//     {"x": 259.7, "y": 442.1, "state": 0},
//     {"x": 236.3, "y": 471.7, "state": 0},
//     {"x": 198.9, "y": 490.4, "state": 0},
//     {"x": 200.5, "y": 516.9, "state": 0},
//     {"x": 197.4, "y": 541.9, "state": 0},
//     {"x": 259.7, "y": 462.4, "state": 0},
//     {"x": 233.2, "y": 499.8, "state": 0},
//     {"x": 233.2, "y": 526.3, "state": 0},
//     {"x": 256.6, "y": 552.8, "state": 0},
//     {"x": 259.7, "y": 520.1, "state": 0},
//     {"x": 256.6, "y": 490.4, "state": 0},
//     {"x": 261.3, "y": 467.0, "state": 0},
//     // {"x": , "y": , "state": 0},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,

//         /// FIXED ASPECT-RATIO CANVAS (400×900)
//         body: Center(
//           child: Transform.scale(
//             scale: 0.8, // <<< IMAGE + CANVAS 20% SMALLER
//             child: AspectRatio(
//               aspectRatio: imageWidth / imageHeight,
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   double scaleW = constraints.maxWidth / imageWidth;
//                   double scaleH = constraints.maxHeight / imageHeight;

//                   double ballX = ringX + ringRadius * cos(angle);
//                   double ballY = ringY + ringRadius * sin(angle);

//                   double ballImageX = ballX;
//                   double ballImageY = ballY;

//                   return Stack(
//                     children: [
//                       Positioned.fill(
//                         child: Image.asset(
//                           'assets/fright.jpeg',
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       ...circles.map((circle) {
//                         return Positioned(
//                           left: circle["x"] * scaleW,
//                           top: circle["y"] * scaleH,
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 circle["state"] = (circle["state"] + 1) % 3;
//                               });
//                             },
//                             child: Container(
//                               width: 20 * scaleW,
//                               height: 20 * scaleW,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: circle["state"] == 1
//                                     ? Colors.red
//                                     : circle["state"] == 2
//                                         ? Colors.green
//                                         : Colors.transparent,
//                                 border: Border.all(
//                                   color: circle["state"] == 1
//                                       ? Colors.red
//                                       : circle["state"] == 2
//                                           ? Colors.green
//                                           : Colors.grey,
//                                   width: 2,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ));
//   }
// }




class RightLage extends StatefulWidget {
  final String diagnosisId;

  const RightLage({super.key, required this.diagnosisId});

  @override
  State<RightLage> createState() => _RightLageState();
}

class _RightLageState extends State<RightLage> {
  final double imageWidth = 400;
  final double imageHeight = 900;

  GlobalKey screenshotKey = GlobalKey();

   List<Map<String, dynamic>> circles = [
    {"x": 47.9, "y": 188.2, "state": 0},
    {"x": 92.0, "y": 98.0, "state": 0},
    {"x": 137.0, "y": 61.0, "state": 0},
    {"x": 178.6, "y": 28.4, "state": 0},
    {"x": 278.3, "y": 48.6, "state": 0},
    {"x": 302.0, "y": 48.6, "state": 0},
    {"x": 298.6, "y": 123.0, "state": 0},
    {"x": 345.9, "y": 97.6, "state": 0},
    {"x": 344.2, "y": 126.4, "state": 0},
    {"x": 271.6, "y": 165.2, "state": 0},
    {"x": 293.5, "y": 168.6, "state": 0},
    {"x": 322.2, "y": 166.9, "state": 0},
    {"x": 347.6, "y": 158.4, "state": 0},
    {"x": 266.5, "y": 204.1, "state": 0},
    {"x": 296.9, "y": 200.7, "state": 0},
    {"x": 327.3, "y": 205.7, "state": 0},
    {"x": 352.6, "y": 193.9, "state": 0},
    {"x": 356.0, "y": 226.0, "state": 0},
    {"x": 323.9, "y": 241.2, "state": 0},
    {"x": 296.9, "y": 241.2, "state": 0},
    {"x": 268.2, "y": 241.2, "state": 0},
    {"x": 361.1, "y": 259.8, "state": 0},
    {"x": 361.1, "y": 288.5, "state": 0},
    {"x": 325.6, "y": 286.8, "state": 0},
    {"x": 296.9, "y": 280.1, "state": 0},
    {"x": 264.8, "y": 286.8, "state": 0},
    {"x": 356.0, "y": 317.2, "state": 0},
    {"x": 178.6, "y": 151.7, "state": 0},
    {"x": 149.9, "y": 156.8, "state": 0},
    {"x": 143.2, "y": 178.7, "state": 0},
    {"x": 124.6, "y": 192.2, "state": 0},
    {"x": 139.8, "y": 197.3, "state": 0},
    {"x": 134.7, "y": 210.8, "state": 0},
    {"x": 126.3, "y": 227.7, "state": 0},
    {"x": 116.1, "y": 242.9, "state": 0},
    {"x": 75.6, "y": 226.0, "state": 0},
    {"x": 60.4, "y": 256.4, "state": 0},
    {"x": 41.8, "y": 280.1, "state": 0},
    {"x": 36.8, "y": 305.4, "state": 0},
    {"x": 33.4, "y": 330.7, "state": 0},
    {"x": 31.7, "y": 357.8, "state": 0},
    {"x": 35.1, "y": 383.1, "state": 0},
    {"x": 40.1, "y": 415.2, "state": 0},
    {"x": 48.6, "y": 449.0, "state": 0},
    {"x": 52.0, "y": 477.7, "state": 0},
    {"x": 53.6, "y": 506.4, "state": 0},
    {"x": 57.0, "y": 538.5, "state": 0},
    {"x": 63.8, "y": 565.5, "state": 0},
    {"x": 67.2, "y": 599.3, "state": 0},
    {"x": 70.5, "y": 628.0, "state": 0},
    {"x": 77.3, "y": 658.4, "state": 0},
    {"x": 75.6, "y": 690.5, "state": 0},
    {"x": 77.3, "y": 722.6, "state": 0},
    {"x": 75.6, "y": 751.4, "state": 0},
    {"x": 75.6, "y": 778.4, "state": 0},
    {"x": 84.1, "y": 803.7, "state": 0},
    {"x": 104.3, "y": 830.7, "state": 0},
    {"x": 175.3, "y": 874.7, "state": 0},
    {"x": 236.1, "y": 832.4, "state": 0},
    {"x": 205.7, "y": 830.7, "state": 0},
    {"x": 173.6, "y": 830.7, "state": 0},
    {"x": 136.4, "y": 832.4, "state": 0},
    {"x": 249.6, "y": 803.7, "state": 0},
    {"x": 222.6, "y": 803.7, "state": 0},
    {"x": 192.2, "y": 802.0, "state": 0},
    {"x": 166.8, "y": 805.4, "state": 0},
    {"x": 141.5, "y": 803.7, "state": 0},
    {"x": 112.8, "y": 803.7, "state": 0},
    {"x": 254.7, "y": 780.1, "state": 0},
    {"x": 229.3, "y": 778.4, "state": 0},
    {"x": 204.0, "y": 778.4, "state": 0},
    {"x": 170.2, "y": 778.4, "state": 0},
    {"x": 138.1, "y": 780.1, "state": 0},
    {"x": 106.0, "y": 778.4, "state": 0},
    {"x": 273.2, "y": 749.7, "state": 0},
    {"x": 249.6, "y": 748.0, "state": 0},
    {"x": 219.2, "y": 748.0, "state": 0},
    {"x": 193.9, "y": 746.3, "state": 0},
    {"x": 170.2, "y": 748.0, "state": 0},
    {"x": 148.2, "y": 746.3, "state": 0},
    {"x": 122.9, "y": 751.4, "state": 0},
    {"x": 100.9, "y": 749.7, "state": 0},
    {"x": 271.6, "y": 724.3, "state": 0},
    {"x": 247.9, "y": 724.3, "state": 0},
    {"x": 220.9, "y": 719.3, "state": 0},
    {"x": 192.2, "y": 720.9, "state": 0},
    {"x": 158.4, "y": 715.9, "state": 0},
    {"x": 131.4, "y": 715.9, "state": 0},
    {"x": 104.3, "y": 717.6, "state": 0},
    {"x": 269.9, "y": 697.3, "state": 0},
    {"x": 268.2, "y": 673.6, "state": 0},
    {"x": 269.1, "y": 651.0, "state": 0},
    {"x": 272.2, "y": 619.9, "state": 0},
    {"x": 275.3, "y": 593.3, "state": 0},
    {"x": 275.3, "y": 566.8, "state": 0},
    {"x": 275.3, "y": 543.5, "state": 0},
    {"x": 278.4, "y": 516.9, "state": 0},
    {"x": 278.4, "y": 492.0, "state": 0},
    {"x": 280.0, "y": 465.5, "state": 0},
    {"x": 284.7, "y": 445.2, "state": 0},
    {"x": 289.4, "y": 423.4, "state": 0},
    {"x": 295.6, "y": 396.9, "state": 0},
    {"x": 309.6, "y": 375.1, "state": 0},
    {"x": 325.2, "y": 359.5, "state": 0},
    {"x": 340.8, "y": 336.1, "state": 0},
    {"x": 203.6, "y": 325.2, "state": 0},
    {"x": 184.9, "y": 323.6, "state": 0},
    {"x": 156.8, "y": 322.0, "state": 0},
    {"x": 77.3, "y": 409.4, "state": 0},
    {"x": 83.5, "y": 435.9, "state": 0},
    {"x": 80.4, "y": 460.8, "state": 0},
    {"x": 82.0, "y": 492.0, "state": 0},
    {"x": 82.0, "y": 516.9, "state": 0},
    {"x": 86.7, "y": 545.0, "state": 0},
    {"x": 92.9, "y": 573.1, "state": 0},
    {"x": 94.4, "y": 594.9, "state": 0},
    {"x": 99.1, "y": 619.9, "state": 0},
    {"x": 102.2, "y": 641.7, "state": 0},
    {"x": 103.8, "y": 669.8, "state": 0},
    {"x": 105.4, "y": 693.1, "state": 0},
    {"x": 135.0, "y": 683.8, "state": 0},
    {"x": 131.9, "y": 654.2, "state": 0},
    {"x": 130.3, "y": 624.5, "state": 0},
    {"x": 130.3, "y": 598.0, "state": 0},
    {"x": 121.0, "y": 570.0, "state": 0},
    {"x": 119.4, "y": 540.3, "state": 0},
    {"x": 116.3, "y": 506.0, "state": 0},
    {"x": 121.0, "y": 473.3, "state": 0},
    {"x": 113.2, "y": 440.5, "state": 0},
    {"x": 147.5, "y": 435.9, "state": 0},
    {"x": 155.3, "y": 468.6, "state": 0},
    {"x": 155.3, "y": 493.6, "state": 0},
    {"x": 158.4, "y": 520.1, "state": 0},
    {"x": 158.4, "y": 571.5, "state": 0},
    {"x": 156.8, "y": 596.5, "state": 0},
    {"x": 156.8, "y": 618.3, "state": 0},
    {"x": 161.5, "y": 657.3, "state": 0},
    {"x": 163.1, "y": 682.2, "state": 0},
    {"x": 195.8, "y": 683.8, "state": 0},
    {"x": 158.4, "y": 543.5, "state": 0},
    {"x": 247.3, "y": 697.8, "state": 0},
    {"x": 222.3, "y": 682.2, "state": 0},
    {"x": 96.0, "y": 381.3, "state": 0},
    {"x": 122.5, "y": 365.7, "state": 0},
    {"x": 150.6, "y": 362.6, "state": 0},
    {"x": 108.5, "y": 415.6, "state": 0},
    {"x": 133.4, "y": 396.9, "state": 0},
    {"x": 183.3, "y": 381.3, "state": 0},
    {"x": 211.4, "y": 381.3, "state": 0},
    {"x": 181.8, "y": 378.2, "state": 0},
    {"x": 180.2, "y": 410.9, "state": 0},
    {"x": 180.2, "y": 435.9, "state": 0},
    {"x": 181.8, "y": 465.5, "state": 0},
    {"x": 192.7, "y": 658.8, "state": 0},
    {"x": 244.1, "y": 378.2, "state": 0},
    {"x": 209.8, "y": 409.4, "state": 0},
    {"x": 205.2, "y": 432.7, "state": 0},
    {"x": 203.6, "y": 460.8, "state": 0},
    {"x": 198.9, "y": 490.4, "state": 0},
    {"x": 197.4, "y": 516.9, "state": 0},
    {"x": 198.9, "y": 541.9, "state": 0},
    {"x": 198.9, "y": 571.5, "state": 0},
    {"x": 197.4, "y": 601.1, "state": 0},
    {"x": 192.7, "y": 630.8, "state": 0},
    {"x": 248.8, "y": 668.2, "state": 0},
    {"x": 225.4, "y": 655.7, "state": 0},
    {"x": 225.4, "y": 630.8, "state": 0},
    {"x": 230.1, "y": 605.8, "state": 0},
    {"x": 228.5, "y": 577.8, "state": 0},
    {"x": 230.1, "y": 551.2, "state": 0},
    {"x": 245.7, "y": 669.8, "state": 0},
    {"x": 248.8, "y": 644.8, "state": 0},
    {"x": 248.8, "y": 624.5, "state": 0},
    {"x": 250.4, "y": 596.5, "state": 0},
    {"x": 251.9, "y": 571.5, "state": 0},
    {"x": 178.6, "y": 351.7, "state": 0},
    {"x": 244.1, "y": 410.9, "state": 0},
    {"x": 236.3, "y": 439.0, "state": 0},
    {"x": 259.7, "y": 442.1, "state": 0},
    {"x": 236.3, "y": 471.7, "state": 0},
    {"x": 198.9, "y": 490.4, "state": 0},
    {"x": 200.5, "y": 516.9, "state": 0},
    {"x": 197.4, "y": 541.9, "state": 0},
    {"x": 259.7, "y": 462.4, "state": 0},
    {"x": 233.2, "y": 499.8, "state": 0},
    {"x": 233.2, "y": 526.3, "state": 0},
    {"x": 256.6, "y": 552.8, "state": 0},
    {"x": 259.7, "y": 520.1, "state": 0},
    {"x": 256.6, "y": 490.4, "state": 0},
    {"x": 261.3, "y": 467.0, "state": 0},
    // {"x": , "y": , "state": 0},
  ];

  String baseUrl = "https://jainacupressure.com/api/get_data.php";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Right Foot Diagnosis"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: submitDiagnosis,
          ),
        ],
      ),

      body: Center(
        child: RepaintBoundary(
          key: screenshotKey,
          child: Transform.scale(
            scale: 0.85,
            child: AspectRatio(
              aspectRatio: imageWidth / imageHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double scaleW = constraints.maxWidth / imageWidth;
                  double scaleH = constraints.maxHeight / imageHeight;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/fright.jpeg",
                          fit: BoxFit.fill,
                        ),
                      ),

                     
                      ...List.generate(circles.length, (index) {
                        var circle = circles[index];
                        return Positioned(
                          left: circle["x"] * scaleW,
                          top: circle["y"] * scaleH,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                circle["state"] =
                                    (circle["state"] + 1) % 3;
                              });
                            },
                            child: Container(
                              width: 20 * scaleW,
                              height: 20 * scaleW,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: circle["state"] == 1
                                    ? Colors.red
                                    : circle["state"] == 2
                                        ? Colors.green
                                        : Colors.white.withOpacity(0.0),
                                border: Border.all(
                                  color: circle["state"] == 1
                                      ? Colors.red
                                      : circle["state"] == 2
                                          ? Colors.green
                                          : Colors.grey,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  //  STEP 1 → Screenshot Base64
  // ---------------------------------------------------------
Future<String> captureScreenshot(GlobalKey screenshotKey) async {
  final renderObject = screenshotKey.currentContext!.findRenderObject();

  if (renderObject is RenderRepaintBoundary) {
    RenderRepaintBoundary boundary = renderObject;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    return base64Encode(pngBytes);
  }

  throw Exception("Not a repaint boundary!");
}
  // ---------------------------------------------------------
  //  STEP 2 → Prepare Dot Data same as Java Code
  // ---------------------------------------------------------
  Map<String, dynamic> prepareDiagnosisData() {
    String mapRightFoot = "";
    List<String> normal = [];
    List<String> endocrine = [];
    List<String> spinal = [];

    for (int i = 0; i < circles.length; i++) {
      var c = circles[i];

      /// format: index:state;
      mapRightFoot += "$i:${c["state"]};";

      /// Groups -> normal | endocrine | spinal
      if (c["state"] != 0) {
        if (c["group"] == "normal") normal.add(c["tag"]);
        if (c["group"] == "endocrine") endocrine.add(c["tag"]);
        if (c["group"] == "spinal") spinal.add(c["tag"]);
      }
    }

    /// Final: “A1;A2;|B1;|C1;C2;”
    String resultRight =
        "${normal.join(";")}|${endocrine.join(";")}|${spinal.join(";")}";

    return {
      "map": mapRightFoot,
      "result": resultRight,
    };
  }

  // ---------------------------------------------------------
  //  STEP 3 → API Submit
  // ---------------------------------------------------------
  Future<void> submitDiagnosis() async {
    String encodedImg = await captureScreenshot(screenshotKey);
    var data = prepareDiagnosisData();

    var body = {
      "pid": "1",
      "diagnosisId": widget.diagnosisId,
      "which": "rf",
      "map_data": data["map"],
      "result": data["result"],
      "image": encodedImg,
    };

    var response = await http.post(
      Uri.parse(baseUrl),
      body: body,
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json["success"] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Right Foot Saved Successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${json["data"]}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error")),
      );
    }
  }
}
