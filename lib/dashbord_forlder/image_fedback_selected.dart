import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class ImagesSelectedBodyPart extends StatefulWidget {
  final Set<String> selectedCellIds;
  final Function(String) onCellSelectionChanged;
  final String day; // 'first' or 'last'
  final bool isReadOnly; // ✅ NEW: Added this parameter

  const ImagesSelectedBodyPart({
    super.key,
    required this.selectedCellIds,
    required this.onCellSelectionChanged,
    required this.day,
    this.isReadOnly = false, // ✅ Default to false
  });

  @override
  State<ImagesSelectedBodyPart> createState() => _ImagesSelectedBodyPartState();
}

class _ImagesSelectedBodyPartState extends State<ImagesSelectedBodyPart> {
  Set<String> get selectedCellIds => widget.selectedCellIds;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  final double imageAspectRatio = 980 / 768;

  void _handleCellTap(String cellId) {
    // ✅ Check if read-only mode
    if (widget.isReadOnly) {
      // Don't allow selection in read-only mode
      return;
    }
    widget.onCellSelectionChanged(cellId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = width / imageAspectRatio;

            return GestureDetector(
              onTapDown:
                  widget.isReadOnly
                      ? null
                      : (details) {
                        final dx = details.localPosition.dx / width;
                        final dy = details.localPosition.dy / height;

                        for (final cell in bodyCells) {
                          if (cell.contains(dx, dy)) {
                            _handleCellTap(cell.id);
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
                        selectedCellIds: selectedCellIds,
                        isReadOnly: widget.isReadOnly,
                        day: widget.day,
                        // ✅ Pass read-only status
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        if (selectedCellIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Text(
                //   'Selected Body Cells: ${selectedCellIds.join(', ')}',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: widget.isReadOnly ? Colors.grey[600] : Colors.black,
                //   ),
                // ),
                if (widget.isReadOnly)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.lock, size: 16, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),

        // Read-only warning
        if (widget.isReadOnly)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Viewing in read-only mode',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
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
  BodyCell(id: 'A1', x: 0.06, y: 0.110, w: 0.17, h: 0.13),
  BodyCell(id: 'A2', x: 0.24, y: 0.110, w: 0.07, h: 0.13),
  BodyCell(id: 'A3', x: 0.31, y: 0.110, w: 0.06, h: 0.13),
  BodyCell(id: 'A4', x: 0.37, y: 0.110, w: 0.07, h: 0.13),
  BodyCell(id: 'A5', x: 0.44, y: 0.110, w: 0.077, h: 0.13),
  BodyCell(id: 'A6', x: 0.522, y: 0.110, w: 0.0733, h: 0.13),
  BodyCell(id: 'A7', x: 0.59, y: 0.110, w: 0.07, h: 0.13),
  BodyCell(id: 'A8', x: 0.66, y: 0.110, w: 0.06, h: 0.13),
  BodyCell(id: 'A9', x: 0.72, y: 0.110, w: 0.07, h: 0.13),
  BodyCell(id: 'A10', x: 0.81, y: 0.110, w: 0.166, h: 0.13),

  // Row B
  BodyCell(id: 'B1', x: 0.06, y: 0.246, w: 0.17, h: 0.09),
  BodyCell(id: 'B2', x: 0.24, y: 0.246, w: 0.07, h: 0.09),
  BodyCell(id: 'B3', x: 0.31, y: 0.246, w: 0.06, h: 0.09),
  BodyCell(id: 'B4', x: 0.37, y: 0.246, w: 0.07, h: 0.09),
  BodyCell(id: 'B5', x: 0.44, y: 0.246, w: 0.077, h: 0.09),
  BodyCell(id: 'B6', x: 0.522, y: 0.246, w: 0.0733, h: 0.09),
  BodyCell(id: 'B7', x: 0.59, y: 0.246, w: 0.07, h: 0.09),
  BodyCell(id: 'B8', x: 0.66, y: 0.246, w: 0.06, h: 0.09),
  BodyCell(id: 'B9', x: 0.72, y: 0.246, w: 0.07, h: 0.09),
  BodyCell(id: 'B10', x: 0.81, y: 0.246, w: 0.166, h: 0.09),

  // Row C
  BodyCell(id: 'C1', x: 0.06, y: 0.346, w: 0.17, h: 0.12),
  BodyCell(id: 'C2', x: 0.24, y: 0.346, w: 0.07, h: 0.12),
  BodyCell(id: 'C3', x: 0.31, y: 0.346, w: 0.06, h: 0.12),
  BodyCell(id: 'C4', x: 0.37, y: 0.346, w: 0.07, h: 0.12),
  BodyCell(id: 'C5', x: 0.44, y: 0.346, w: 0.077, h: 0.12),
  BodyCell(id: 'C6', x: 0.522, y: 0.346, w: 0.0733, h: 0.12),
  BodyCell(id: 'C7', x: 0.59, y: 0.346, w: 0.07, h: 0.12),
  BodyCell(id: 'C8', x: 0.66, y: 0.346, w: 0.06, h: 0.12),
  BodyCell(id: 'C9', x: 0.72, y: 0.346, w: 0.07, h: 0.12),
  BodyCell(id: 'C10', x: 0.81, y: 0.346, w: 0.166, h: 0.12),

  // Row D
  BodyCell(id: 'D1', x: 0.06, y: 0.475, w: 0.17, h: 0.07),
  BodyCell(id: 'D2', x: 0.24, y: 0.475, w: 0.07, h: 0.07),
  BodyCell(id: 'D3', x: 0.31, y: 0.475, w: 0.06, h: 0.07),
  BodyCell(id: 'D4', x: 0.37, y: 0.475, w: 0.07, h: 0.07),
  BodyCell(id: 'D5', x: 0.44, y: 0.475, w: 0.077, h: 0.07),
  BodyCell(id: 'D6', x: 0.522, y: 0.475, w: 0.0733, h: 0.07),
  BodyCell(id: 'D7', x: 0.59, y: 0.475, w: 0.07, h: 0.07),
  BodyCell(id: 'D8', x: 0.66, y: 0.475, w: 0.06, h: 0.07),
  BodyCell(id: 'D9', x: 0.72, y: 0.475, w: 0.07, h: 0.07),
  BodyCell(id: 'D10', x: 0.81, y: 0.475, w: 0.166, h: 0.07),

  // Row E
  BodyCell(id: 'E1', x: 0.06, y: 0.550, w: 0.17, h: 0.37),
  BodyCell(id: 'E2', x: 0.24, y: 0.550, w: 0.07, h: 0.37),
  BodyCell(id: 'E3', x: 0.31, y: 0.550, w: 0.06, h: 0.37),
  BodyCell(id: 'E4', x: 0.37, y: 0.550, w: 0.07, h: 0.37),
  BodyCell(id: 'E5', x: 0.44, y: 0.550, w: 0.077, h: 0.37),
  BodyCell(id: 'E6', x: 0.522, y: 0.550, w: 0.0733, h: 0.37),
  BodyCell(id: 'E7', x: 0.59, y: 0.550, w: 0.07, h: 0.37),
  BodyCell(id: 'E8', x: 0.66, y: 0.550, w: 0.06, h: 0.37),
  BodyCell(id: 'E9', x: 0.72, y: 0.550, w: 0.07, h: 0.37),
  BodyCell(id: 'E10', x: 0.81, y: 0.550, w: 0.166, h: 0.37),
];

/* ================= PAINTER ================= */

class BodyHighlightPainter extends CustomPainter {
  final Set<String> selectedCellIds;
  final bool isReadOnly; // ✅ NEW: Added this parameter
  final String day;

  BodyHighlightPainter({
    required this.selectedCellIds,
    this.isReadOnly = false, // ✅ Default to false
    required this.day,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Color fillColor;
    Color borderColor;

    // ✅ Day based color
    if (day.toLowerCase() == 'last') {
      fillColor = Colors.green.withOpacity(0.45);
      borderColor = Colors.green.shade700;
    } else {
      // First day default
      fillColor = Colors.red.withOpacity(0.45);
      borderColor = Colors.red.shade700;
    }

    // ✅ Read only override
    if (isReadOnly) {
      fillColor = Colors.grey.withOpacity(0.3);
      borderColor = Colors.grey.shade600;
    }

    final paint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

    final borderSee =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    for (final cell in bodyCells) {
      if (selectedCellIds.contains(cell.id)) {
        final rect = Rect.fromLTWH(
          cell.x * size.width,
          cell.y * size.height,
          cell.w * size.width,
          cell.h * size.height,
        );

        canvas.drawRect(rect, paint);
        canvas.drawRect(rect, borderSee);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BodyHighlightPainter oldDelegate) {
    return oldDelegate.selectedCellIds != selectedCellIds ||
        oldDelegate.isReadOnly != isReadOnly;
  }
}
