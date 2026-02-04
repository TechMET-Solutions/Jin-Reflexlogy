import 'package:flutter/material.dart';

class InteractiveBodyMap extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;
  final List<String> initialSelection;

  const InteractiveBodyMap({
    super.key,
    required this.onSelectionChanged,
    this.initialSelection = const [],
  });

  @override
  State<InteractiveBodyMap> createState() => _InteractiveBodyMapState();
}

class _InteractiveBodyMapState extends State<InteractiveBodyMap> {
  Set<String> selectedCells = {};

  // Grid configuration: 5 rows (A-E) x 10 columns (1-10)
  final List<String> rows = ['A', 'B', 'C', 'D', 'E'];
  final List<int> columns = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    super.initState();
    selectedCells = widget.initialSelection.toSet();
  }

  void _toggleCell(String cellId) {
    setState(() {
      if (selectedCells.contains(cellId)) {
        selectedCells.remove(cellId);
      } else {
        selectedCells.add(cellId);
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
        color: Colors.pink,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Background body image
            Image.asset(
              'assets/images/fedback.jpeg',
              fit: BoxFit.contain,
              height: 300,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 400,
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
                          Icons.image_not_supported_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Body Map Image Not Found",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Interactive Grid Overlay
            Positioned.fill(
              child: _buildGridOverlay(),
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
          height: 30,
          color: Colors.black.withOpacity(0.05),
          child: Row(
            children: [
              // Empty corner for row labels
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              // Column numbers
              ...columns.map((col) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$col',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
              Column(
                children: rows.map((row) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          row,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
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

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _toggleCell(cellId),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.red.withOpacity(0.5)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red[900],
                                          size: 16,
                                        ),
                                      )
                                    : null,
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
