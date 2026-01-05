// main.dart
import 'package:flutter/material.dart';


/* ============================================================
   MAIN SCREEN (BODY MAP + REVIEW OF SYSTEMS)
============================================================ */

class FeedBackForm extends StatefulWidget {
  const FeedBackForm({super.key});

  @override
  State<FeedBackForm> createState() =>
      _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBackForm> {
  String? selectedCellId;

  /// Review of system answers
  final Map<String, String?> _answers = {};

  final double imageAspectRatio = 768 / 1536;

  void _onSelect(String key, String value) {
    setState(() {
      _answers[key] = value; // FD & LD mutually exclusive
    });
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Checkbox(
            value: value == 'FD',
            onChanged: (_) => _onSelect(label, 'FD'),
          ),
          const Text('FD'),
          const SizedBox(width: 6),
          Checkbox(
            value: value == 'LD',
            onChanged: (_) => _onSelect(label, 'LD'),
          ),
          const Text('LD'),
        ],
      ),
    );
  }

  void _submit() {
    debugPrint('Selected Cell: $selectedCellId');
    debugPrint('Selected Symptoms:');

    _answers.forEach((key, value) {
      if (value != null) {
        debugPrint('$key : $value');
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Map + Review'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* ================= BODY MAP ================= */

            LayoutBuilder(
              builder: (context, constraints) {
                final double screenWidth = constraints.maxWidth;
                final double imageHeight =
                    screenWidth / imageAspectRatio;

                return GestureDetector(
                  onTapDown: (details) {
                    final tap = details.localPosition;

                    final double localX = tap.dx / screenWidth;
                    final double localY = tap.dy / imageHeight;

                    for (final cell in bodyCells) {
                      if (cell.contains(localX, localY)) {
                        setState(() {
                          selectedCellId = cell.id;
                        });
                        break;
                      }
                    }
                  },
                  child: SizedBox(
                    width: screenWidth,
                    height: imageHeight,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/body_map.png',
                          width: screenWidth,
                          height: imageHeight,
                          fit: BoxFit.contain,
                        ),
                        CustomPaint(
                          size: Size(screenWidth, imageHeight),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const Divider(thickness: 1),

            /* ================= REVIEW OF SYSTEM ================= */

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('HEAD'),
                  _symptomRow('Frequent Headaches'),
                  _symptomRow('Severe Headaches'),
                  _symptomRow('Dizziness'),
                  _symptomRow('Loss of consciousness'),
                  _symptomRow('Congestion'),

                  _sectionTitle('EYES'),
                  _symptomRow('Pain'),
                  _symptomRow('Dry Eyes'),
                  _symptomRow('Tearing'),

                  _sectionTitle('RESPIRATORY'),
                  _symptomRow('Chest Pain or Tightness'),
                  _symptomRow('Shortness of Breath'),
                  _symptomRow('Coughing'),

                  _sectionTitle('CARDIOVASCULAR'),
                  _symptomRow('Chest Tightness'),
                  _symptomRow('Palpitations'),

                  _sectionTitle('GASTROINTESTINAL'),
                  _symptomRow('Poor Appetite'),
                  _symptomRow('Nausea'),
                  _symptomRow('Vomiting'),

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

/* ================= BODY CELL MODEL ================= */

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
  BodyCell(id: 'A7', x: 0.59, y: 0.344, w:  0.07, h: 0.05),
  BodyCell(id: 'A8', x: 0.66, y: 0.344, w: 0.06, h: 0.05),
  BodyCell(id: 'A9', x: 0.72, y: 0.344, w: 0.07, h: 0.05),
  BodyCell(id: 'A10', x:0.81, y: 0.344, w: 0.166, h: 0.05),

  // Row B
  BodyCell(id: 'B1', x: 0.06, y: 0.3999, w: 0.17, h: 0.04),
  BodyCell(id: 'B2', x:  0.24, y: 0.3999, w:  0.07, h: 0.04),
  BodyCell(id: 'B3', x: 0.31, y: 0.3999, w: 0.06, h: 0.04),  
  BodyCell(id: 'B4', x: 0.37, y: 0.3999, w: 0.07, h: 0.04), 
  BodyCell(id: 'B5', x: 0.44, y: 0.3999, w: 0.077, h: 0.04),
  BodyCell(id: 'B6', x: 0.522, y: 0.3999, w: 0.0733, h: 0.04),
  BodyCell(id: 'B7', x: 0.59, y: 0.3999, w:  0.07, h: 0.04),
  BodyCell(id: 'B8', x: 0.66, y: 0.3999, w: 0.06, h: 0.04),
  BodyCell(id: 'B9', x: 0.72, y: 0.3999, w: 0.07, h: 0.04),
  BodyCell(id: 'B10', x:0.81, y: 0.3999, w: 0.166, h: 0.04),

  // Row C
  BodyCell(id: 'C1', x: 0.06, y: 0.440, w:0.17, h: 0.05),
  BodyCell(id: 'C2', x: 0.24, y: 0.440, w:  0.07, h: 0.05),
  BodyCell(id: 'C3', x: 0.31, y: 0.440, w: 0.06, h: 0.05),
  BodyCell(id: 'C4', x: 0.37, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C5', x: 0.44, y: 0.440, w: 0.077, h: 0.05),    
  BodyCell(id: 'C6', x: 0.522, y: 0.440, w: 0.0733, h: 0.05),     
  BodyCell(id: 'C7', x: 0.59, y: 0.440, w:  0.07, h: 0.05),
  BodyCell(id: 'C8', x: 0.66, y: 0.440, w: 0.06, h: 0.05),
  BodyCell(id: 'C9', x: 0.72, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C10', x: 0.81, y: 0.440, w: 0.166, h: 0.05),

  // Row D
  BodyCell(id: 'D1', x: 0.06, y: 0.488, w: 0.17, h: 0.03),
  BodyCell(id: 'D2', x:  0.24, y: 0.488, w:  0.07, h: 0.03),
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
  BodyCell(id: 'E2', x:  0.24, y: 0.5222, w:  0.07, h: 0.14),
  BodyCell(id: 'E3', x: 0.31, y: 0.5222, w: 0.06, h: 0.14),
  BodyCell(id: 'E4', x: 0.37, y: 0.5222, w: 0.07, h: 0.14),
  BodyCell(id: 'E5', x: 0.44, y: 0.5222, w: 0.077, h: 0.14),
  BodyCell(id: 'E6', x: 0.522, y: 0.5222, w: 0.0733, h: 0.14),
  BodyCell(id: 'E7', x: 0.59, y: 0.5222, w:  0.07, h: 0.14),
  BodyCell(id: 'E8', x: 0.66, y: 0.5222, w: 0.06, h: 0.14),
  BodyCell(id: 'E9', x: 0.72, y: 0.5222, w: 0.07, h: 0.14),   
  BodyCell(id: 'E10', x: 0.81, y: 0.5222, w: 0.166, h: 0.14),   /// <= kam karene E9
];

/* ================= PAINTER ================= */

class BodyHighlightPainter extends CustomPainter {
  final String? selectedCellId;

  BodyHighlightPainter({this.selectedCellId});

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedCellId == null) return;

    final fadePaint =
        Paint()..color = Colors.black.withOpacity(0.6);
    final clearPaint = Paint()..blendMode = BlendMode.clear;

    final cell =
        bodyCells.firstWhere((e) => e.id == selectedCellId);

    canvas.saveLayer(null, Paint());
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      fadePaint,
    );

    final rect = Rect.fromLTWH(
      cell.x * size.width,
      cell.y * size.height,
      cell.w * size.width,
      cell.h * size.height,
    );

    canvas.drawRect(rect, clearPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
