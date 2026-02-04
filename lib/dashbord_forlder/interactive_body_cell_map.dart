import 'package:flutter/material.dart';
import 'body_cell_model.dart';

/// Interactive body map that detects cell taps and highlights them
class InteractiveBodyCellMap extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;
  final List<String> initialSelection;
  final String imageAsset;

  const InteractiveBodyCellMap({
    super.key,
    required this.onSelectionChanged,
    this.initialSelection = const [],
    this.imageAsset = 'assets/images/fedback.jpeg',
  });

  @override
  State<InteractiveBodyCellMap> createState() => _InteractiveBodyCellMapState();
}

class _InteractiveBodyCellMapState extends State<InteractiveBodyCellMap> {
  Set<String> selectedCellIds = {};
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedCellIds = widget.initialSelection.toSet();
  }

  void _handleTap(TapDownDetails details) {
    // Get the RenderBox of the image
    final RenderBox? renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      debugPrint('❌ RenderBox is null');
      return;
    }

    // Get local position relative to the image
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final imageSize = renderBox.size;

    debugPrint('\n🖱️ ========== TAP DETECTED ==========');
    debugPrint('Global position: ${details.globalPosition}');
    debugPrint('Local position: $localPosition');
    debugPrint('Image size: $imageSize');

    // Detect which cell was tapped
    final tappedCell = BodyCellDetector.detectCell(localPosition, imageSize);

    if (tappedCell != null) {
      setState(() {
        if (selectedCellIds.contains(tappedCell.id)) {
          selectedCellIds.remove(tappedCell.id);
          debugPrint('🔴 Cell ${tappedCell.id} DESELECTED');
        } else {
          selectedCellIds.add(tappedCell.id);
          debugPrint('🟢 Cell ${tappedCell.id} SELECTED');
        }
      });

      // Notify parent
      widget.onSelectionChanged(selectedCellIds.toList());

      debugPrint('📋 Total selected cells: ${selectedCellIds.length}');
      debugPrint('📋 Selected: ${selectedCellIds.toList()}');
    }
    debugPrint('====================================\n');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border(
                  bottom: BorderSide(color: Colors.blue[100]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Tap body areas to mark affected regions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Body map with overlay
            Expanded(
              child: GestureDetector(
                onTapDown: _handleTap,
                child: Stack(
                  children: [
                    // Background image
                    Image.asset(
                      widget.imageAsset,
                      key: _imageKey,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.accessibility_new_rounded,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Body Map",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Cell overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BodyCellPainter(
                          selectedCellIds: selectedCellIds,
                          showGrid: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer with selection count
            if (selectedCellIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border(
                    top: BorderSide(color: Colors.red[100]!, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.red[900],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${selectedCellIds.length} area${selectedCellIds.length > 1 ? 's' : ''} marked',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
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

/// Custom painter to draw cell overlays
class BodyCellPainter extends CustomPainter {
  final Set<String> selectedCellIds;
  final bool showGrid;

  BodyCellPainter({
    required this.selectedCellIds,
    this.showGrid = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw each cell
    for (final cell in bodyCells) {
      final rect = Rect.fromLTWH(
        cell.x * size.width,
        cell.y * size.height,
        cell.w * size.width,
        cell.h * size.height,
      );

      final isSelected = selectedCellIds.contains(cell.id);

      // Draw cell background if selected
      if (isSelected) {
        final paint = Paint()
          ..color = Colors.red.withOpacity(0.5)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);
      }

      // Draw grid lines if enabled
      if (showGrid) {
        final borderPaint = Paint()
          ..color = isSelected
              ? Colors.red.withOpacity(0.8)
              : Colors.black.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.0 : 0.5;
        canvas.drawRect(rect, borderPaint);
      }

      // Draw cell ID for selected cells
      if (isSelected) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: cell.id,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            rect.center.dx - textPainter.width / 2,
            rect.center.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(BodyCellPainter oldDelegate) {
    return oldDelegate.selectedCellIds != selectedCellIds ||
        oldDelegate.showGrid != showGrid;
  }
}
