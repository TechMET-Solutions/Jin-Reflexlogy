import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

/* ============================================================
   MAIN SCREEN
============================================================ */

class FeedBackFormNew extends StatefulWidget {
  const FeedBackFormNew({super.key});

  @override
  State<FeedBackFormNew> createState() => _FeedBackFormNewState();
}

class _FeedBackFormNewState extends State<FeedBackFormNew> {
  String? selectedCellId;
  final Map<String, String?> _answers = {};

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  final double imageAspectRatio = 768 / 1536;

  void _onSelect(String key, String value) {
    setState(() {
      _answers[key] = value;
    });
  }

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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _symptomRow(String label) {
    final value = _answers[label];

    return Row(
      children: [
        Expanded(child: Text(label)),
        Checkbox(
          value: value == 'FD',
          onChanged: (_) => _onSelect(label, 'FD'),
        ),
        const Text('FD'),
        Checkbox(
          value: value == 'LD',
          onChanged: (_) => _onSelect(label, 'LD'),
        ),
        const Text('LD'),
      ],
    );
  }

  // =================== NEW HELPER FUNCTIONS ===================

  // Get cell position description
  String _getCellPosition(String cellId) {
    try {
      final cell = bodyCells.firstWhere((c) => c.id == cellId);
      return 'X: ${(cell.x * 100).toStringAsFixed(1)}%, '
          'Y: ${(cell.y * 100).toStringAsFixed(1)}%';
    } catch (e) {
      return 'Position not available';
    }
  }

  // Get cell description
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

  // Count selected symptoms
  int _countSelectedSymptoms() {
    return _answers.values
        .where((value) => value != null && value!.isNotEmpty)
        .length;
  }

  // Build symptoms list for PDF
  List<pw.Widget> _buildPDFSymptomsList() {
    final List<pw.Widget> symptomsWidgets = [];

    // Define sections manually
    final sections = [
      'HEAD',
      'Ears',
      'Mouth',
      'Nose',
      'Neck & Throat',
      'RESPIRATORY',
      'EYES',
      'CARDIOVASCULAR',
      'ALLERGY/IMMUNO',
      'GASTROINTESTINAL',
      'MUSCULOSKELETAL',
      'SKIN',
      'ENDOCRINE & METABOLISM',
      'NEUROLOGICAL & PSYCHOLOGICAL',
      'GENITOURINARY',
      'HEMATOLOGICAL',
      'Miscellaneous',
      'Women only',
      'How would you rate your general health?',
    ];

    // Group symptoms by section
    final Map<String, List<String>> groupedSymptoms = {};

    // Initialize all sections
    for (final section in sections) {
      groupedSymptoms[section] = [];
    }

    // Manually check each symptom
    for (final entry in _answers.entries) {
      if (entry.value != null && entry.value!.isNotEmpty) {
        // Find which section this symptom belongs to
        String? symptomSection;

        // Check which section this symptom belongs to
        if (entry.key == 'None' ||
            entry.key == 'Frequent Headaches' ||
            entry.key == 'Dizziness' ||
            entry.key == 'Severe Headaches' ||
            entry.key == 'Loss of consciousness' ||
            entry.key == 'Light Headedness') {
          symptomSection = 'HEAD';
        } else if (entry.key == 'Pain' && _answers.keys.contains('Pain')) {
          // Check context for Pain symptom
          // This is simplified - you'll need to adjust based on your actual symptom structure
          symptomSection = 'Ears';
        }
        // Add more conditions for other symptoms...

        if (symptomSection != null &&
            groupedSymptoms.containsKey(symptomSection)) {
          groupedSymptoms[symptomSection]!.add('${entry.key}: ${entry.value}');
        } else {
          // If not found in specific sections, add to miscellaneous
          if (groupedSymptoms.containsKey('Miscellaneous')) {
            groupedSymptoms['Miscellaneous']!.add(
              '${entry.key}: ${entry.value}',
            );
          }
        }
      }
    }

    // Add each section to PDF
    groupedSymptoms.forEach((section, symptoms) {
      if (symptoms.isNotEmpty) {
        symptomsWidgets.addAll([
          pw.SizedBox(height: 8),
          pw.Text(
            section,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.Divider(color: PdfColors.grey400, thickness: 0.5),
          ...symptoms.map((symptom) {
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Text('• $symptom'),
            );
          }).toList(),
        ]);
      }
    });

    if (symptomsWidgets.isEmpty) {
      symptomsWidgets.add(
        pw.Text(
          'No symptoms selected',
          style: pw.TextStyle(color: PdfColors.grey),
        ),
      );
    }

    return symptomsWidgets;
  }

  // Clear form after submission
  void _clearForm() {
    setState(() {
      nameController.clear();
      mobileController.clear();
      selectedDate = DateTime.now();
      selectedCellId = null;
      _answers.clear();
    });
  }

  Future<void> _uploadPDF(Uint8List pdfBytes, String formId) async {
    final dio = Dio(
      BaseOptions(
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    final formData = FormData.fromMap({
      'patientName': nameController.text.trim(),
      'form': MultipartFile.fromBytes(
        pdfBytes,
        filename: 'patient_feedback_$formId.pdf',
        contentType: DioMediaType('application', 'pdf'),
      ),
    });

    final response = await dio.post(
      'https://admin.jinreflexology.in/api/patientFeedbackForm',
      data: formData,
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('RESPONSE: ${response.data}');
  }

  Future<void> _generateAndUploadPDF() async {
    try {
      final pdfDoc = pw.Document();
      final timestamp = DateTime.now();
      final formId = 'FBF${timestamp.millisecondsSinceEpoch}';
      pdfDoc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    'PATIENT FEEDBACK FORM',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Divider(thickness: 2, color: PdfColors.black),
                pw.SizedBox(height: 15),

                // Form ID and Timestamp
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Form ID: $formId'),
                    pw.Text(
                      'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(timestamp)}',
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Personal Details Section
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.blue, width: 1),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  padding: const pw.EdgeInsets.all(12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'PERSONAL DETAILS',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Name: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            nameController.text.isNotEmpty
                                ? nameController.text
                                : 'Not provided',
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Mobile: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            mobileController.text.isNotEmpty
                                ? mobileController.text
                                : 'Not provided',
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Date of Visit: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            DateFormat('dd-MM-yyyy').format(selectedDate),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Body Map Section
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.green, width: 1),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  padding: const pw.EdgeInsets.all(12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'BODY MAP SELECTION',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      if (selectedCellId != null)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(
                                  'Selected Body Cell: ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(selectedCellId!),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              'Body Area: ${_getCellDescription(selectedCellId!)}',
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              'Coordinates: ${_getCellPosition(selectedCellId!)}',
                            ),
                          ],
                        )
                      else
                        pw.Text(
                          'No body area selected',
                          style: pw.TextStyle(color: PdfColors.red),
                        ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Symptoms Review Section
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red, width: 1),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  padding: const pw.EdgeInsets.all(12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SYMPTOMS REVIEW',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      ..._buildPDFSymptomsList(),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Summary
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SUMMARY',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Total Symptoms Selected: ${_countSelectedSymptoms()}',
                      ),
                      if (selectedCellId != null)
                        pw.Text(
                          'Body Area of Concern: ${_getCellDescription(selectedCellId!)}',
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Generate PDF bytes
      final Uint8List pdfBytes = await pdfDoc.save();
      debugPrint('PDF Generated: ${pdfBytes.length} bytes');

      // Upload to server
      await _uploadPDF(pdfBytes, formId);
    } catch (e) {
      debugPrint('PDF Generation Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    }
  }

  void _submit() async {
    // Validation
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    if (mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile number')),
      );
      return;
    }

    if (selectedCellId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a body area on the map')),
      );
      return;
    }

    if (_countSelectedSymptoms() == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Generating PDF...'),
              ],
            ),
          ),
    );

    try {
      await _generateAndUploadPDF();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Map + Review'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* ================= PERSONAL DETAILS ================= */
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(selectedDate),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // const Divider(),

            /* ================= BODY MAP ================= */
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = width / imageAspectRatio;

                return GestureDetector(
                  onTapDown: (details) {
                    final dx = details.localPosition.dx / width;
                    final dy = details.localPosition.dy / height;

                    for (final cell in bodyCells) {
                      if (cell.contains(dx, dy)) {
                        setState(() {
                          selectedCellId = cell.id;
                        });
                        break;
                      }
                    }
                  },
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/fedback.jpeg',
                          width: width,
                          height: height,
                          fit: BoxFit.contain,
                        ),
                        CustomPaint(
                          size: Size(width, height),
                          painter: BodyHighlightPainter(
                            selectedCellId: selectedCellId,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (selectedCellId != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Selected Body Cell: $selectedCellId',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            // const Divider(),

            /* ================= REVIEW SYSTEM ================= */
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('HEAD'),
                  _symptomRow('None'),
                  _symptomRow('Frequent Headaches'),
                  _symptomRow('Dizziness'),
                  _symptomRow('Severe Headaches'),
                  _symptomRow('Loss of consciousness'),
                  _symptomRow('Light Headedness'),

                  _sectionTitle('Ears'),
                  _symptomRow('Pain'),
                  _symptomRow('Discharge'),
                  _symptomRow('Hearing Problems'),
                  _symptomRow('Ringing'),
                  _symptomRow('Infections'),
                  _symptomRow('Hearing Aid'),

                  _sectionTitle('Mouth'),
                  _symptomRow('Pain'),
                  _symptomRow('Ulcers/cold sores'),
                  _symptomRow('Change in Taste'),
                  _symptomRow('Dentures'),
                  _symptomRow('Dry Mouth'),
                  _symptomRow('Periodontal Disease'),
                  _symptomRow('Partial Plates'),
                  _symptomRow('Tongue: Sore, Enlarged'),
                  _symptomRow('Teeth Problem'),

                  _sectionTitle('Nose'),
                  _symptomRow('Sinus Problems'),
                  _symptomRow('Change in Smell'),
                  _symptomRow('Nose Bleeds'),
                  _symptomRow('Nasal Obstruction'),

                  _sectionTitle('Neck & Throat'),
                  _symptomRow('Hoarseness'),
                  _symptomRow('Change in Voice'),
                  _symptomRow('Difficulty swallowing'),
                  _symptomRow('Large thyroid/goiter'),
                  _symptomRow('Overactive thyroid'),
                  _symptomRow('Underactive thyroid'),
                  _symptomRow('Enlarged lymph glands'),

                  _sectionTitle('RESPIRATORY'),
                  _symptomRow('Chest Pain or tightness'),
                  _symptomRow('Fever'),
                  _symptomRow('Coughing'),
                  _symptomRow('Coughing Blood'),
                  _symptomRow('Chills'),
                  _symptomRow('Shortness of Breath'),
                  _symptomRow('Wheezing'),
                  _symptomRow('Night Sweats'),
                  _symptomRow('Stridor'),

                  _sectionTitle('EYES'),
                  _symptomRow('Glasses'),
                  _symptomRow('Dry Eyes'),
                  _symptomRow('Color Blindness'),
                  _symptomRow('Contacts'),
                  _symptomRow('Tearing'),
                  _symptomRow('Vision: Blurred/Double'),
                  _symptomRow('Pain'),
                  _symptomRow('Shimmering Spots'),
                  _symptomRow('Blind Spots, Blindness'),
                  _symptomRow('Eye itching'),
                  _symptomRow('Eye redness'),
                  _symptomRow('Photophobia'),
                  _symptomRow('Congestion'),
                  _symptomRow('Dental problem'),
                  _symptomRow('Facial swelling'),
                  _symptomRow('Rhinorrhea'),
                  _symptomRow('Sneezing'),
                  _symptomRow('Sore throat'),
                  _symptomRow('Tinnitus'),
                  _symptomRow('Apnea'),
                  _symptomRow('Choking'),

                  _sectionTitle('CARDIOVASCULAR'),
                  _symptomRow('Pain: Jaw, Neck, Chest, Mid-Back'),
                  _symptomRow('Leg Cramps / Leg swelling'),
                  _symptomRow('Varicose Veins or Phlebitis'),
                  _symptomRow('Swollen Feet or Ankles'),
                  _symptomRow('Chest tightness'),
                  _symptomRow('Angina'),
                  _symptomRow('Abnormal Cardiogram (EKG)'),
                  _symptomRow('Shortness of Breath'),
                  _symptomRow('Rapid Heart Beat'),
                  _symptomRow('Irregular Heart Beat (Palpitations)'),
                  _symptomRow('Heart murmur'),
                  _symptomRow('Snoring'),

                  _sectionTitle('ALLERGY/IMMUNO'),
                  _symptomRow('Environmental allergies'),
                  _symptomRow('Food allergies'),
                  _symptomRow('Immunocompromised'),

                  _sectionTitle('GASTROINTESTINAL'),
                  _symptomRow('Poor Appetite'),
                  _symptomRow('Abdominal Pain'),
                  _symptomRow('Food Intolerance or Allergy'),
                  _symptomRow('Nausea'),
                  _symptomRow('Vomiting'),
                  _symptomRow('Vomiting Blood'),
                  _symptomRow('Diarrhea'),
                  _symptomRow('Laxative Use'),
                  _symptomRow('Belching'),
                  _symptomRow('Rectal Bleeding'),
                  _symptomRow('Bloating'),
                  _symptomRow('Change in Stool Size'),
                  _symptomRow('Jaundice'),
                  _symptomRow('Constipation'),
                  _symptomRow('Black, White, Bloody Stool'),
                  _symptomRow('Heartburn'),
                  _symptomRow('Trouble Chewing'),
                  _symptomRow('Hemorrhoids'),
                  _symptomRow('Trouble Swallowing'),
                  _symptomRow('Gallbladder Problems'),
                  _symptomRow('Diverticulitis'),
                  _symptomRow('Recent change in bowels'),
                  _symptomRow('Dark black/\"tarry\" stools'),
                  _symptomRow('Colitis/enteritis'),
                  _symptomRow('Abdominal distention'),
                  _symptomRow('Anal bleeding'),
                  _symptomRow('Rectal pain'),

                  _sectionTitle('MUSCULOSKELETAL'),
                  _symptomRow('Bone Pain'),
                  _symptomRow('Muscle Pain'),
                  _symptomRow('Back Pain'),
                  _symptomRow('Arthralgias'),
                  _symptomRow('Gait problems'),
                  _symptomRow('Myalgias'),
                  _symptomRow('Neck stiffness'),
                  _symptomRow('Joint: Stiffness'),
                  _symptomRow('Joint: Swelling'),
                  _symptomRow('Joint: Pain'),
                  _symptomRow('Joint: Redness'),

                  _sectionTitle('SKIN'),
                  _symptomRow('Rash'),
                  _symptomRow('Dryness'),
                  _symptomRow('Sore which does not heal'),
                  _symptomRow('Itch'),
                  _symptomRow('Burning'),
                  _symptomRow('Skin disorders'),
                  _symptomRow('Changing skin spots'),
                  _symptomRow('Persistent skin pain'),
                  _symptomRow('Recent change in skin'),
                  _symptomRow('Easy bruising'),
                  _symptomRow('Color change'),
                  _symptomRow('Pallor'),
                  _symptomRow('Birthmarks'),
                  _symptomRow('Change in: Hair'),
                  _symptomRow('Change in: Nails'),
                  _symptomRow('Change in: moles'),

                  _sectionTitle('ENDOCRINE & METABOLISM'),
                  _symptomRow('Poor Energy'),
                  _symptomRow('Increased Thirst'),
                  _symptomRow('Appetite Change'),
                  _symptomRow('Cold intolerance'),
                  _symptomRow('Heat intolerance'),
                  _symptomRow('Polyuria'),
                  _symptomRow('Polyphagia'),
                  _symptomRow('Polydipsia'),
                  _symptomRow('Recent Weight Gain'),
                  _symptomRow('Recent Weight Loss'),
                  _symptomRow('Feel Too Hot'),
                  _symptomRow('Feel Too Cold'),

                  _sectionTitle('NEUROLOGICAL & PSYCHOLOGICAL'),
                  _symptomRow('Fainting'),
                  _symptomRow('Dizziness'),
                  _symptomRow('Loneliness'),
                  _symptomRow('Tingling'),
                  _symptomRow('Numbness'),
                  _symptomRow('Depression'),
                  _symptomRow('Personality Change'),
                  _symptomRow('Nervousness'),
                  _symptomRow('Worry'),
                  _symptomRow('Incoordination'),
                  _symptomRow('Paralysis'),
                  _symptomRow('Weakness'),
                  _symptomRow('Unconsciousness'),
                  _symptomRow('Irritability'),
                  _symptomRow('Thick Speech'),
                  _symptomRow('Suicidal Thoughts'),
                  _symptomRow('Seizures'),
                  _symptomRow('Convulsions'),
                  _symptomRow('Daydreaming'),
                  _symptomRow('Loss of Temper'),
                  _symptomRow('Fatigue'),
                  _symptomRow('Difficulty Walking in the Dark'),
                  _symptomRow('Emotional'),
                  _symptomRow('Bipolar illness'),
                  _symptomRow('Sleeping problems'),
                  _symptomRow('Receiving psychiatric care'),
                  _symptomRow('Excessive worrying'),
                  _symptomRow('Fears/phobias'),
                  _symptomRow('Crying spells'),
                  _symptomRow('Feelings of hopelessness'),
                  _symptomRow('Stroke/weakness of limbs'),
                  _symptomRow('Epilepsy'),
                  _symptomRow('Loss of sensation in limbs'),
                  _symptomRow('Loss of sensation in body'),
                  _symptomRow('Facial asymmetry'),
                  _symptomRow('Headaches'),
                  _symptomRow('Light-headedness'),
                  _symptomRow('Syncope'),
                  _symptomRow('Tremors'),

                  _sectionTitle('GENITOURINARY'),
                  _symptomRow('Pain with Urination or Intercourse'),
                  _symptomRow('Urinate Frequently Day'),
                  _symptomRow('Urinate Frequently Night'),
                  _symptomRow('Incontinence'),
                  _symptomRow('Dark or Red Urine'),
                  _symptomRow('Are you sexually active?'),
                  _symptomRow('Dysuria'),
                  _symptomRow('Enuresis'),
                  _symptomRow('Flank pain'),
                  _symptomRow('Genital sore'),
                  _symptomRow('Hematuria'),
                  _symptomRow('Penile discharge'),
                  _symptomRow('Penile pain'),
                  _symptomRow('Penile swelling'),
                  _symptomRow('Scrotal swelling'),
                  _symptomRow('Testicular pain'),
                  _symptomRow('Urgency'),
                  _symptomRow('Kidney stones/colic'),
                  _symptomRow('Urine/kidney infection'),
                  _symptomRow('Protein/albumin in urine'),
                  _symptomRow('Damaged kidneys'),
                  _symptomRow('History of dialysis'),

                  _sectionTitle('HEMATOLOGICAL'),
                  _symptomRow('Easy Bruising or Bleeding'),
                  _symptomRow('Swollen Lymph Nodes: Neck, Groin, Under Arms'),
                  _symptomRow('Adenopathy'),

                  _sectionTitle('Miscellaneous'),
                  _symptomRow('Bleeding from dental treatments'),
                  _symptomRow('Increased or excessive thirst'),
                  _symptomRow('Frequently too hot or cold'),
                  _symptomRow('Smoke cigarettes:'),
                  _symptomRow('Drink alcohol:'),
                  _symptomRow('Prostate infection:'),
                  _symptomRow('Difficulty urinating:'),
                  _symptomRow('Mass in testicles:'),
                  _symptomRow('Pain in testicles:'),
                  _symptomRow('Venereal diseases (VD):'),

                  _sectionTitle('Women only'),
                  _symptomRow('Pregnant:'),
                  _symptomRow('Venereal diseases (VD):'),
                  _symptomRow('Sexual problems:'),
                  _symptomRow('Fertility treatments:'),
                  _symptomRow('Hormones used:'),
                  _symptomRow('Menstrual periods regular:'),
                  _symptomRow('Menses: Irregular'),
                  _symptomRow('Menses: Heavy'),
                  _symptomRow('Menses: Painful'),
                  _symptomRow('Menses: Abnormal Bleeding'),
                  _symptomRow('Menses: Discharge'),
                  _symptomRow('Use any contraception:'),
                  _symptomRow('Breast: Lump'),
                  _symptomRow('Breast: Discharge'),
                  _symptomRow('Breast: Pain'),
                  _symptomRow('Breast: Swelling'),

                  _sectionTitle('How would you rate your general health?'),
                  _symptomRow('Excellent'),
                  _symptomRow('Good'),
                  _symptomRow('Fair'),
                  _symptomRow('Poor'),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('SUBMIT'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= BODY CELL ================= */

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

/* ================= PAINTER ================= */

class BodyHighlightPainter extends CustomPainter {
  final String? selectedCellId;

  BodyHighlightPainter({this.selectedCellId});

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedCellId == null) return;

    final cell = bodyCells.firstWhere((e) => e.id == selectedCellId);

    final paint =
        Paint()
          ..color = Colors.yellow.withOpacity(0.45)
          ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      cell.x * size.width,
      cell.y * size.height,
      cell.w * size.width,
      cell.h * size.height,
    );

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
