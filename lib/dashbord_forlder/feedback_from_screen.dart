import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class FeedBackFormNew extends StatefulWidget {
  const FeedBackFormNew({super.key});

  @override
  State<FeedBackFormNew> createState() => _FeedBackFormNewState();
}

class _FeedBackFormNewState extends State<FeedBackFormNew> {
  List<String> selectedCellIds = [];
  final Map<String, String?> _answers = {};

  // Screenshot controller
  final ScreenshotController _screenshotController = ScreenshotController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final double imageAspectRatio = 768 / 1536;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  String _getCellDescription(String cellId) {
    final Map<String, String> descriptions = {
      'A1': 'Left Shoulder/Upper Arm',
      'A2': 'Left Elbow',
      'A3': 'Left Forearm',
      'A4': 'Left Wrist',
      'A5': 'Left Hand',
      'A6': 'Right Hand',
      'A7': 'Right Wrist',
      'A8': 'Right Forearm',
      'A9': 'Right Elbow',
      'A10': 'Right Shoulder/Upper Arm',
      'B1': 'Left Chest/Upper Torso',
      'B2': 'Left Ribs',
      'B3': 'Left Upper Abdomen',
      'B4': 'Left Lower Abdomen',
      'B5': 'Left Hip',
      'B6': 'Right Hip',
      'B7': 'Right Lower Abdomen',
      'B8': 'Right Upper Abdomen',
      'B9': 'Right Ribs',
      'B10': 'Right Chest/Upper Torso',
      'C1': 'Left Thigh',
      'C2': 'Left Knee',
      'C3': 'Left Shin',
      'C4': 'Left Ankle',
      'C5': 'Left Foot',
      'C6': 'Right Foot',
      'C7': 'Right Ankle',
      'C8': 'Right Shin',
      'C9': 'Right Knee',
      'C10': 'Right Thigh',
      'D1': 'Left Lower Back',
      'D2': 'Left Middle Back',
      'D3': 'Left Upper Back',
      'D4': 'Neck/Spine Area',
      'D5': 'Right Upper Back',
      'D6': 'Right Middle Back',
      'D7': 'Right Lower Back',
      'E1': 'Head - Left Side',
      'E2': 'Left Ear/Temple',
      'E3': 'Left Eye/Cheek',
      'E4': 'Left Jaw/Mouth',
      'E5': 'Chin/Throat',
      'E6': 'Right Jaw/Mouth',
      'E7': 'Right Eye/Cheek',
      'E8': 'Right Ear/Temple',
      'E9': 'Head - Right Side',
    };

    return descriptions[cellId] ?? 'Body Area $cellId';
  }

  void _clearForm() {
    setState(() {
      nameController.clear();
      mobileController.clear();
      selectedDate = DateTime.now();
      selectedCellIds.clear();
      _answers.clear();
    });
  }

  void _toggleCellSelection(String cellId) {
    setState(() {
      if (selectedCellIds.contains(cellId)) {
        selectedCellIds.remove(cellId);
      } else {
        selectedCellIds.add(cellId);
      }
    });
  }

  void _clearSelectedCells() {
    setState(() {
      selectedCellIds.clear();
    });
  }

  // स्क्रीनशॉट घेण्याची method
  Future<void> _captureAndShowScreenshot() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Capturing screenshot...'),
                ],
              ),
            ),
      );

      // Screenshot capture करा
      final Uint8List? imageBytes = await _screenshotController.capture(
        pixelRatio: 2.0, // High resolution
        delay: const Duration(milliseconds: 200),
      );

      // Close loading
      if (Navigator.canPop(context)) Navigator.pop(context);

      if (imageBytes == null) {
        throw Exception('Failed to capture screenshot');
      }

      // Preview dialog मध्ये दाखवा
      _showScreenshotPreview(imageBytes);
    } catch (e) {
      // Close loading if still showing
      if (Navigator.canPop(context)) Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // Preview dialog दाखवा
  void _showScreenshotPreview(Uint8List imageBytes) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.camera_alt, color: Colors.green),
                SizedBox(width: 8),
                Text('Form Screenshot Preview'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(imageBytes),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Patient Name:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(nameController.text),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Mobile:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(mobileController.text),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Date:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Selected Areas:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${selectedCellIds.length} areas'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              // ElevatedButton.icon(
              //   onPressed: () => _saveToGallery(imageBytes),
              //   icon: const Icon(Icons.save, size: 18),
              //   label: const Text('Save'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue.shade100,
              //     foregroundColor: Colors.blue.shade800,
              //   ),
              // ),
              ElevatedButton.icon(
                onPressed: () => _submitForm(imageBytes),
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
    );
  }

  // // Gallery मध्ये save करा
  // Future<void> _saveToGallery(Uint8List imageBytes) async {
  //   try {
  //     // Permission check
  //     var status = await Permission.storage.status;
  //     if (!status.isGranted) {
  //       status = await Permission.storage.request();
  //     }

  //     if (status.isGranted) {
  //       // Show saving indicator
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Row(
  //             children: [
  //               CircularProgressIndicator(color: Colors.white),
  //               SizedBox(width: 16),
  //               Text('Saving to gallery...'),
  //             ],
  //           ),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );

  //       final result = await ImageGallerySaver.saveImage(imageBytes);

  //       if (result['isSuccess'] == true) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Row(
  //               children: [
  //                 Icon(Icons.check_circle, color: Colors.white),
  //                 SizedBox(width: 8),
  //                 Text('Screenshot saved to gallery!'),
  //               ],
  //             ),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Failed to save: ${result['errorMessage']}'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Storage permission required'),
  //           backgroundColor: Colors.orange,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error saving: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  // Form submit करा
  Future<void> _submitForm(Uint8List screenshotBytes) async {
    try {
      // Close preview dialog
      Navigator.pop(context);

      // Show submitting indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Submitting form...'),
                ],
              ),
            ),
      );

      // Convert to base64
      String base64Image = base64Encode(screenshotBytes);

      // Prepare form data
      Map<String, dynamic> formData = {
        'patient_name': nameController.text,
        'mobile_number': mobileController.text,
        'visit_date': DateFormat('dd-MM-yyyy').format(selectedDate),
        'selected_areas': selectedCellIds,
        'screenshot_image': base64Image,
        'areas_details':
            selectedCellIds
                .map(
                  (id) => {'area_id': id, 'area_name': _getCellDescription(id)},
                )
                .toList(),
        'submitted_at': DateTime.now().toIso8601String(),
      };

      // TODO: Replace with your server URL
      const String serverUrl = 'YOUR_SERVER_API_ENDPOINT_HERE';

      // Send to server (mock for now - uncomment when you have server)
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // Uncomment this for actual server call:
      /*
        final response = await http.post(
          Uri.parse(serverUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(formData),
        ).timeout(const Duration(seconds: 30));
        
        if (response.statusCode != 200) {
          throw Exception('Server error: ${response.statusCode}');
        }
        */

      // Close loading
      if (Navigator.canPop(context)) Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Form submitted successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Clear form after successful submission
      _clearForm();
    } catch (e) {
      // Close loading if still showing
      if (Navigator.canPop(context)) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Map Feedback Form'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearForm,
            tooltip: 'Clear form',
          ),
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Add your personal details form here
                    ],
                  ),
                ),
                */

              // Body Map Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.medical_services, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Body Areas Selection',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Areas: ${selectedCellIds.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Tap on body map to select/deselect',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          if (selectedCellIds.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: _clearSelectedCells,
                              icon: const Icon(Icons.clear, size: 16),
                              label: const Text('Clear All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade50,
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Body Map Image - FIXED LAYOUT
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;

                            return AspectRatio(
                              aspectRatio: imageAspectRatio, // correct ratio
                              child: GestureDetector(
                                onTapDown: (details) {
                                  final box =
                                      context.findRenderObject() as RenderBox;
                                  final local = box.globalToLocal(
                                    details.globalPosition,
                                  );

                                  final dx = local.dx / box.size.width;
                                  final dy = local.dy / box.size.height;

                                  for (final cell in bodyCells) {
                                    if (cell.contains(dx, dy)) {
                                      _toggleCellSelection(cell.id);
                                      break;
                                    }
                                  }
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/fedback.jpeg',
                                      fit: BoxFit.contain, // ✅ No stretch
                                    ),

                                    CustomPaint(
                                      painter: BodyHighlightPainter(
                                        selectedCellIds: selectedCellIds,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Selected Areas List - या भागातील space दुरुस्त केला
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                color: Colors.grey.shade50,
                child: ElevatedButton.icon(
                  onPressed: _captureAndShowScreenshot,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text(
                    'CAPTURE & SUBMIT FORM',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 18,
                    ),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.green.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BodyCell {
  final String id;
  final double x, y, w, h;

  const BodyCell({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  bool contains(double px, double py) {
    return px >= x && px <= x + w && py >= y && py <= y + h;
  }
}

// Body Cells Data
const List<BodyCell> bodyCells = [
  // Row A
  BodyCell(id: 'A1', x: 0.06, y: 0.344, w: 0.17, h: 0.05),
  BodyCell(id: 'A2', x: 0.24, y: 0.344, w: 0.07, h: 0.05),
  BodyCell(id: 'A3', x: 0.31, y: 0.344, w: 0.06, h: 0.05),
  BodyCell(id: 'A4', x: 0.37, y: 0.344, w: 0.07, h: 0.05),
  BodyCell(id: 'A5', x: 0.44, y: 0.344, w: 0.077, h: 0.05),
  BodyCell(id: 'A6', x: 0.522, y: 0.344, w: 0.0733, h: 0.05),
  BodyCell(id: 'A7', x: 0.59, y: 0.344, w: 0.07, h: 0.05),
  BodyCell(id: 'A8', x: 0.66, y: 0.344, w: 0.06, h: 0.05),
  BodyCell(id: 'A9', x: 0.72, y: 0.344, w: 0.07, h: 0.05),
  BodyCell(id: 'A10', x: 0.81, y: 0.344, w: 0.166, h: 0.05),

  // Row B
  BodyCell(id: 'B1', x: 0.06, y: 0.3999, w: 0.17, h: 0.04),
  BodyCell(id: 'B2', x: 0.24, y: 0.3999, w: 0.07, h: 0.04),
  BodyCell(id: 'B3', x: 0.31, y: 0.3999, w: 0.06, h: 0.04),
  BodyCell(id: 'B4', x: 0.37, y: 0.3999, w: 0.07, h: 0.04),
  BodyCell(id: 'B5', x: 0.44, y: 0.3999, w: 0.077, h: 0.04),
  BodyCell(id: 'B6', x: 0.522, y: 0.3999, w: 0.0733, h: 0.04),
  BodyCell(id: 'B7', x: 0.59, y: 0.3999, w: 0.07, h: 0.04),
  BodyCell(id: 'B8', x: 0.66, y: 0.3999, w: 0.06, h: 0.04),
  BodyCell(id: 'B9', x: 0.72, y: 0.3999, w: 0.07, h: 0.04),
  BodyCell(id: 'B10', x: 0.81, y: 0.3999, w: 0.166, h: 0.04),

  // Row C
  BodyCell(id: 'C1', x: 0.06, y: 0.440, w: 0.17, h: 0.05),
  BodyCell(id: 'C2', x: 0.24, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C3', x: 0.31, y: 0.440, w: 0.06, h: 0.05),
  BodyCell(id: 'C4', x: 0.37, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C5', x: 0.44, y: 0.440, w: 0.077, h: 0.05),
  BodyCell(id: 'C6', x: 0.522, y: 0.440, w: 0.0733, h: 0.05),
  BodyCell(id: 'C7', x: 0.59, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C8', x: 0.66, y: 0.440, w: 0.06, h: 0.05),
  BodyCell(id: 'C9', x: 0.72, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C10', x: 0.81, y: 0.440, w: 0.166, h: 0.05),

  // Row D
  BodyCell(id: 'D1', x: 0.06, y: 0.488, w: 0.17, h: 0.03),
  BodyCell(id: 'D2', x: 0.24, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D3', x: 0.31, y: 0.488, w: 0.06, h: 0.03),
  BodyCell(id: 'D4', x: 0.37, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D5', x: 0.44, y: 0.488, w: 0.077, h: 0.03),
  BodyCell(id: 'D6', x: 0.522, y: 0.488, w: 0.0733, h: 0.03),
  BodyCell(id: 'D7', x: 0.59, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D8', x: 0.66, y: 0.488, w: 0.06, h: 0.03),
  BodyCell(id: 'D9', x: 0.72, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D10', x: 0.81, y: 0.488, w: 0.166, h: 0.03),

  // Row E
  BodyCell(id: 'E1', x: 0.06, y: 0.5222, w: 0.17, h: 0.14),
  BodyCell(id: 'E2', x: 0.24, y: 0.5222, w: 0.07, h: 0.14),
  BodyCell(id: 'E3', x: 0.31, y: 0.5222, w: 0.06, h: 0.14),
  BodyCell(id: 'E4', x: 0.37, y: 0.5222, w: 0.07, h: 0.14),
  BodyCell(id: 'E5', x: 0.44, y: 0.5222, w: 0.077, h: 0.14),
  BodyCell(id: 'E6', x: 0.522, y: 0.5222, w: 0.0733, h: 0.14),
  BodyCell(id: 'E7', x: 0.59, y: 0.5222, w: 0.07, h: 0.14),
  BodyCell(id: 'E8', x: 0.66, y: 0.5222, w: 0.06, h: 0.14),
  BodyCell(id: 'E9', x: 0.72, y: 0.5222, w: 0.07, h: 0.14),
  BodyCell(id: 'E10', x: 0.81, y: 0.5222, w: 0.166, h: 0.14),
];

// Body Highlight Painter
class BodyHighlightPainter extends CustomPainter {
  final List<String> selectedCellIds;

  BodyHighlightPainter({required this.selectedCellIds});

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedCellIds.isEmpty) return;

    final colors = [
      Colors.red.withOpacity(0.5),
      Colors.red.withOpacity(0.5),
      Colors.red.withOpacity(0.5),
      Colors.red.withOpacity(0.5),
      Colors.red.withOpacity(0.5),
      Colors.red.withOpacity(0.5),
    ];

    for (int i = 0; i < selectedCellIds.length; i++) {
      final cellId = selectedCellIds[i];
      final cell = bodyCells.firstWhere(
        (e) => e.id == cellId,
        orElse: () => BodyCell(id: '', x: 0, y: 0, w: 0, h: 0),
      );

      if (cell.id.isEmpty) continue;

      final paint =
          Paint()
            ..color = colors[i % colors.length]
            ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        cell.x * size.width,
        cell.y * size.height,
        cell.w * size.width,
        cell.h * size.height,
      );

      canvas.drawRect(rect, paint);

      final borderPaint =
          Paint()
            ..color = Colors.black.withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0;

      canvas.drawRect(rect, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
