import 'package:flutter/material.dart';

/// Model for a body cell with normalized coordinates
class BodyCell {
  final String id;
  final double x; // Left position (0.0 to 1.0)
  final double y; // Top position (0.0 to 1.0)
  final double w; // Width (0.0 to 1.0)
  final double h; // Height (0.0 to 1.0)

  const BodyCell({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  /// Check if a normalized point (tapX, tapY) is inside this cell
  bool contains(double tapX, double tapY) {
    return tapX >= x && 
           tapX <= (x + w) && 
           tapY >= y && 
           tapY <= (y + h);
  }

  /// Get the center point of this cell
  Offset get center => Offset(x + w / 2, y + h / 2);

  /// Get the bounds as a Rect
  Rect get rect => Rect.fromLTWH(x, y, w, h);

  @override
  String toString() => 'BodyCell($id: x=$x, y=$y, w=$w, h=$h)';
}

/// All body cells with normalized coordinates
const List<BodyCell> bodyCells = [
  // Row A - Head area
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

  // Row B - Upper chest/shoulders
  BodyCell(id: 'B1', x: 0.06, y: 0.246, w: 0.17, h: 0.09),
  BodyCell(id: 'B2', x: 0.24, y: 0.246, w: 0.07, h: 0.04),
  BodyCell(id: 'B3', x: 0.31, y: 0.246, w: 0.06, h: 0.04),
  BodyCell(id: 'B4', x: 0.37, y: 0.246, w: 0.07, h: 0.04),
  BodyCell(id: 'B5', x: 0.44, y: 0.246, w: 0.077, h: 0.04),
  BodyCell(id: 'B6', x: 0.522, y: 0.246, w: 0.0733, h: 0.04),
  BodyCell(id: 'B7', x: 0.59, y: 0.246, w: 0.07, h: 0.04),
  BodyCell(id: 'B8', x: 0.66, y: 0.246, w: 0.06, h: 0.04),
  BodyCell(id: 'B9', x: 0.72, y: 0.246, w: 0.07, h: 0.04),
  BodyCell(id: 'B10', x: 0.81, y: 0.246, w: 0.166, h: 0.04),

  // Row C - Chest/abdomen
  BodyCell(id: 'C1', x: 0.06, y: 0.346, w: 0.17, h: 0.12),
  BodyCell(id: 'C2', x: 0.24, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C3', x: 0.31, y: 0.440, w: 0.06, h: 0.05),
  BodyCell(id: 'C4', x: 0.37, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C5', x: 0.44, y: 0.440, w: 0.077, h: 0.05),
  BodyCell(id: 'C6', x: 0.522, y: 0.440, w: 0.0733, h: 0.05),
  BodyCell(id: 'C7', x: 0.59, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C8', x: 0.66, y: 0.440, w: 0.06, h: 0.05),
  BodyCell(id: 'C9', x: 0.72, y: 0.440, w: 0.07, h: 0.05),
  BodyCell(id: 'C10', x: 0.81, y: 0.440, w: 0.166, h: 0.05),

  // Row D - Lower abdomen/hips
  BodyCell(id: 'D1', x: 0.06, y: 0.475, w: 0.17, h: 0.07),
  BodyCell(id: 'D2', x: 0.24, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D3', x: 0.31, y: 0.488, w: 0.06, h: 0.03),
  BodyCell(id: 'D4', x: 0.37, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D5', x: 0.44, y: 0.488, w: 0.077, h: 0.03),
  BodyCell(id: 'D6', x: 0.522, y: 0.488, w: 0.0733, h: 0.03),
  BodyCell(id: 'D7', x: 0.59, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D8', x: 0.66, y: 0.488, w: 0.06, h: 0.03),
  BodyCell(id: 'D9', x: 0.72, y: 0.488, w: 0.07, h: 0.03),
  BodyCell(id: 'D10', x: 0.81, y: 0.488, w: 0.166, h: 0.03),

  // Row E - Legs
  BodyCell(id: 'E1', x: 0.06, y: 0.550, w: 0.17, h: 0.37),
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

/// Helper class to detect which cell was tapped
class BodyCellDetector {
  /// Find which cell contains the tap position
  /// Returns null if no cell was tapped
  static BodyCell? detectCell(Offset tapPosition, Size imageSize) {
    // Normalize tap coordinates (0.0 to 1.0)
    final normalizedX = tapPosition.dx / imageSize.width;
    final normalizedY = tapPosition.dy / imageSize.height;

    debugPrint('🎯 Tap detected at: dx=${tapPosition.dx}, dy=${tapPosition.dy}');
    debugPrint('📐 Image size: ${imageSize.width} x ${imageSize.height}');
    debugPrint('📍 Normalized: x=$normalizedX, y=$normalizedY');

    // Find the cell that contains this point
    for (final cell in bodyCells) {
      if (cell.contains(normalizedX, normalizedY)) {
        debugPrint('✅ Cell found: ${cell.id}');
        debugPrint('   Cell bounds: x=${cell.x}, y=${cell.y}, w=${cell.w}, h=${cell.h}');
        return cell;
      }
    }

    debugPrint('❌ No cell found at this position');
    return null;
  }

  /// Get all cells in a specific row
  static List<BodyCell> getCellsInRow(String row) {
    return bodyCells.where((cell) => cell.id.startsWith(row)).toList();
  }

  /// Get all cells in a specific column
  static List<BodyCell> getCellsInColumn(int column) {
    return bodyCells.where((cell) => cell.id.endsWith('$column')).toList();
  }

  /// Get cell by ID
  static BodyCell? getCellById(String id) {
    try {
      return bodyCells.firstWhere((cell) => cell.id == id);
    } catch (e) {
      return null;
    }
  }
}
