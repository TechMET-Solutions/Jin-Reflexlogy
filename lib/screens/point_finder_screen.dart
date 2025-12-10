


// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class PointFinderScreen extends StatefulWidget {
//   @override
//   _PointFinderScreenState createState() => _PointFinderScreenState();
// }

// class _PointFinderScreenState extends State<PointFinderScreen> {
//   CameraController? cameraController;
//   List<CameraDescription>? cameras;

//   double imageOpacity = 0.7;
//   double zoomLevel = 1.0;

//   bool isLeft = true;
//   bool isFlashOn = false;

//   int i = -1;
//   int j = 0;
//   int lastPage = -3;

//   ImageProvider overlayImage = const AssetImage("assets/images/point_finder_lf.png");

//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }

//   Future<void> initCamera() async {
//     cameras = await availableCameras();
//     cameraController = CameraController(
//       cameras![0],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );

//     await cameraController!.initialize();
//     setState(() {});
//   }

//   Future<void> toggleFlash() async {
//     if (isFlashOn) {
//       await cameraController!.setFlashMode(FlashMode.off);
//     } else {
//       await cameraController!.setFlashMode(FlashMode.torch);
//     }
//     setState(() {
//       isFlashOn = !isFlashOn;
//     });
//   }

//   Future<void> fetchImage(int page) async {
//     final url = "http://jainacupressure.com/api/pointfinder.php";

//     final res = await http.post(Uri.parse(url), body: {
//       "a": "1",
//       "name": page.toString(),
//     });

//     final json = jsonDecode(res.body);

//     if (json["success"] == 1) {
//       String base64Image = json["data"][0]["image"];
//       lastPage = int.parse(json["data"][0]["lastpage"]);

//       Uint8List bytes = base64Decode(base64Image);

//       setState(() {
//         overlayImage = MemoryImage(bytes);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       body: Stack(
//         children: [
//           // CAMERA PREVIEW
//           CameraPreview(cameraController!),

//           // TRANSPARENT OVERLAY IMAGE
//           Center(
//             child: GestureDetector(
//               onHorizontalDragEnd: (details) {
//                 if (details.primaryVelocity! < 0) {
                 
//                   i++;
//                   fetchImage(i);
//                 } else {
                
//                   if (i > 0) i--;
//                   fetchImage(i);
//                 }
//               },
//               child: Opacity(
//                 opacity: imageOpacity,
//                 child: InteractiveViewer(
//                   child: Image(
//                     image: overlayImage,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // OPACITY SLIDER (TOP)
//           Positioned(
//             top: 20,
//             left: 20,
//             right: 20,
//             child: Slider(
//               value: imageOpacity,
//               min: 0.1,
//               max: 1.0,
//               onChanged: (v) {
//                 setState(() => imageOpacity = v);
//               },
//             ),
//           ),

//           // ZOOM SLIDER (RIGHT)
//           Positioned(
//             right: 20,
//             top: 100,
//             bottom: 100,
//             child: RotatedBox(
//               quarterTurns: 1,
//               child: Slider(
//                 value: zoomLevel,
//                 min: 1.0,
//                 max: 5.0,
//                 onChanged: (v) async {
//                   zoomLevel = v;
//                   await cameraController!.setZoomLevel(v);
//                   setState(() {});
//                 },
//               ),
//             ),
//           ),

//           // FLIP BUTTON
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: IconButton(
//               icon: Icon(Icons.flip_camera_android, size: 40, color: Colors.white),
//               onPressed: () {
//                 setState(() {
//                   isLeft = !isLeft;
//                   overlayImage = AssetImage(
//                     isLeft
//                         ? "assets/images/point_finder_lf.png"
//                         : "assets/images/point_finder_rf.png",
//                   );
//                 });
//               },
//             ),
//           ),

//           // FLASH BUTTON
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: IconButton(
//               icon: Icon(
//                 isFlashOn ? Icons.flash_off : Icons.flash_on,
//                 size: 40,
//                 color: Colors.white,
//               ),
//               onPressed: toggleFlash,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
