// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class DiseaseDataScreen extends StatefulWidget {
//   final String name;

//   final String? host;   
//   final String? host1; 
  
//   const DiseaseDataScreen({
//     Key? key,
//     required this.name,
//     this.host,
//     this.host1,
//   }) : super(key: key);

//   @override
//   State<DiseaseDataScreen> createState() => _DiseaseDataScreenState();
// }

// class _DiseaseDataScreenState extends State<DiseaseDataScreen> {
//   bool _loading = true;
//   String? _error;

//   late String dbUrl;

//   // Fields from API
//   String diseaseDetail = '';
//   String diseaseCauses = '';
//   String diseaseSymptoms = '';
//   String diseaseRegimen = '';
//   String diseaseMainPoint = '';
//   String diseaseRelatedPoints = '';
//   String diseaseMicroMagnet = '';
//   Uint8List? imageBytes;

//   @override
//   void initState() {
//     super.initState();
//     dbUrl = _setDbUrl();   // <-- Android logic added
//     _fetchDisease();
//   }

//   /// Android Java logic converted to Flutter
//   /// if (SDK < 26) use host1
//   /// else use host
//   String _setDbUrl() {
//     final host = widget.host ?? "https://jainacupressure.com/api/";
//     final host1 = widget.host1 ?? "http://jainacupressure.com/api/";

//     try {
//       if (Platform.isAndroid) {
//         final rawVersion = Platform.operatingSystemVersion;
//         final match = RegExp(r"SDK\s+(\d+)").firstMatch(rawVersion);
//         final sdk = match != null ? int.parse(match.group(1)!) : 30;

//         if (sdk < 26) {
//           return "${host1}equest_dwt.php";
//         } else {
//           return "${host}request_dwt.php";
//         }
//       }
//     } catch (_) {}

//     return "${host}request_dwt.php";
//   }

//   Future<void> _fetchDisease() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     try {
//       final uri = Uri.parse(dbUrl);

//       final response = await http.post(uri, body: {
//         'a': '1',
//         'name': widget.name,
//       });

//       if (response.statusCode != 200) {
//         throw Exception('Server returned ${response.statusCode}');
//       }

//       final Map<String, dynamic> json = jsonDecode(response.body);

//       if ((json['success'] is int && json['success'] == 1) ||
//           (json['success'] is String && json['success'] == '1')) {
//         final List<dynamic> data = json['data'] as List<dynamic>;
//         if (data.isEmpty) {
//           throw Exception('No data returned from server');
//         }

//         final Map<String, dynamic> obj = Map<String, dynamic>.from(data[0]);

//         setState(() {
//           diseaseDetail = obj['diseaseDetail']?.toString() ?? '';
//           diseaseCauses = obj['diseaseCauses']?.toString() ?? '';
//           diseaseSymptoms = obj['diseaseSymptoms']?.toString() ?? '';
//           diseaseRegimen = obj['diseaseRegimen']?.toString() ?? '';
//           diseaseMainPoint = obj['diseaseMainPoint']?.toString() ?? '';
//           diseaseRelatedPoints = obj['diseaseRelatedPoints']?.toString() ?? '';
//           diseaseMicroMagnet = obj['diseaseMicroMagnet']?.toString() ?? '';
//           final imageBase64 = obj['image']?.toString() ?? '';
//           if (imageBase64.isNotEmpty) {
//             try {
//               imageBytes = base64Decode(imageBase64);
//             } catch (_) {
//               imageBytes = null;
//             }
//           } else {
//             imageBytes = null;
//           }

//           _loading = false;
//         });
//       } else {
//         final msg = json['data']?.toString() ?? 'Unknown error';
//          throw Exception(msg);
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });  
//     }
//   }

//   Widget _sectionHeader(String text, Color bg,
//       {Color textColor = Colors.white}) {
//     return Container(
//       width: double.infinity,
//       color: bg,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: TextStyle(color: textColor, fontSize: 18),
//       ),
//     );
//   }

//   Widget _borderedBox(String content) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         content,
//         style: const TextStyle(fontSize: 18, color: Colors.black),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.name),
//         centerTitle: true,
//       ),
//       backgroundColor: const Color(0xFFF3F4F6),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Error: $_error', textAlign: TextAlign.center),
//                         const SizedBox(height: 12),
//                         ElevatedButton(
//                           onPressed: _fetchDisease,
//                           child: const Text('Retry'),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Container(
//                           color: Colors.yellow.shade700,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Text(
//                             widget.name,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _borderedBox(diseaseDetail),
//                         const SizedBox(height: 10),
//                         _sectionHeader('Causes : ', Colors.green.shade400),
//                         const SizedBox(height: 6),
//                         _borderedBox(diseaseCauses),
//                         const SizedBox(height: 10),
//                         _sectionHeader('Symptoms : ',
//                             Colors.orange.shade300,
//                             textColor: Colors.black),
//                         const SizedBox(height: 6),
//                         _borderedBox(diseaseSymptoms),
//                         const SizedBox(height: 10),
//                         _sectionHeader('Regimen : ', Colors.blue.shade700),
//                         const SizedBox(height: 6),
//                         _borderedBox(diseaseRegimen),
//                         const SizedBox(height: 10),
//                         _sectionHeader('Main Point : ', Colors.red.shade700),
//                         const SizedBox(height: 6),
//                         _borderedBox(diseaseMainPoint),
//                         const SizedBox(height: 10),
//                         _sectionHeader('Related Points : ',
//                             Colors.purple.shade700),
//                         const SizedBox(height: 6),
//                         _borderedBox(diseaseRelatedPoints),
//                         const SizedBox(height: 10),
//                         _sectionHeader('Using Micro Magnet : ',
//                             const Color(0xFFA28967)),
//                         const SizedBox(height: 6),
//                         _borderedBox(diseaseMicroMagnet),
//                         const SizedBox(height: 12),

//                         Center(
//                           child: imageBytes != null
//                               ? GestureDetector(
//                                   onTap: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (_) => Dialog(
//                                         child: InteractiveViewer(
//                                           child: Image.memory(imageBytes!),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Image.memory(
//                                     imageBytes!,
//                                     width: MediaQuery.of(context).size.width * 0.6,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 )
//                               : Column(
//                                   children: [
//                                     Icon(Icons.image_not_supported, size: 64,
//                                         color: Colors.grey.shade400),
//                                     const SizedBox(height: 6),
//                                     Text('No image available',
//                                         style: theme.textTheme.bodySmall),
//                                   ],
//                                 ),
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     ),
//                   ),
//                 ),
//     );
//   }
// }
