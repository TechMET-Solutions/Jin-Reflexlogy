import 'package:flutter/material.dart';

class EnhancedBodyMap extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;
  final List<String> initialSelection;
  final String imageAsset;

  const EnhancedBodyMap({
    super.key,
    required this.onSelectionChanged,
    this.initialSelection = const [],
    this.imageAsset = 'assets/images/fedback.jpeg',
  });

  @override
  State<EnhancedBodyMap> createState() => _EnhancedBodyMapState();
}

class _EnhancedBodyMapState extends State<EnhancedBodyMap>
    with SingleTickerProviderStateMixin {
  Set<String> selectedCells = {};
  String? hoveredCell;

  // Grid configuration: 5 rows (A-E) x 10 columns (1-10)
  final List<String> rows = ['A', 'B', 'C', 'D', 'E'];
  final List<int> columns = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    selectedCells = widget.initialSelection.toSet();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCell(String cellId) {
    setState(() {
      if (selectedCells.contains(cellId)) {
        selectedCells.remove(cellId);
      } else {
        selectedCells.add(cellId);
        _animationController.forward(from: 0);
      }
    });
    widget.onSelectionChanged(selectedCells.toList());
  }

  String _getCellId(String row, int col) {
    return '$row$col';
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
            // Legend
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
                    'Tap grid cells to mark affected areas',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Body map with grid
            Expanded(
              child: Stack(
                children: [
                  // Background body image
                  Positioned.fill(
                    child: Image.asset(
                      widget.imageAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey[100]!, Colors.grey[200]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
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
                  ),

                  // Interactive Grid Overlay
                  Positioned.fill(
                    child: _buildGridOverlay(),
                  ),
                ],
              ),
            ),

            // Selection count footer
            if (selectedCells.isNotEmpty)
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
                            '${selectedCells.length} area${selectedCells.length > 1 ? 's' : ''} marked',
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

  Widget _buildGridOverlay() {
    return Column(
      children: [
        // Column headers (1-10)
        Container(
          height: 35,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.08),
                Colors.black.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              // Empty corner for row labels
              SizedBox(
                width: 45,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
              // Column numbers
              ...columns.map((col) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$col',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        // Grid rows with cells
        Expanded(
          child: Row(
            children: [
              // Row labels (A-E)
              Container(
                width: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.08),
                      Colors.black.withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  children: rows.map((row) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            row,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Grid cells
              Expanded(
                child: Column(
                  children: rows.map((row) {
                    return Expanded(
                      child: Row(
                        children: columns.map((col) {
                          final cellId = _getCellId(row, col);
                          final isSelected = selectedCells.contains(cellId);
                          final isHovered = hoveredCell == cellId;

                          return Expanded(
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  hoveredCell = cellId;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  hoveredCell = null;
                                });
                              },
                              child: GestureDetector(
                                onTap: () => _toggleCell(cellId),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.red.withOpacity(0.6)
                                        : isHovered
                                            ? Colors.blue.withOpacity(0.2)
                                            : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.red[700]!
                                          : Colors.black,
                                      width: isSelected ? 2.0 : 1.5,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      if (isSelected)
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red[900],
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      if (isHovered && !isSelected)
                                        Center(
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.blue[700],
                                            size: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
