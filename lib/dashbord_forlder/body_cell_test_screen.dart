import 'package:flutter/material.dart';
import 'interactive_body_cell_map.dart';
import 'body_cell_model.dart';

/// Test screen for body cell detection
class BodyCellTestScreen extends StatefulWidget {
  const BodyCellTestScreen({super.key});

  @override
  State<BodyCellTestScreen> createState() => _BodyCellTestScreenState();
}

class _BodyCellTestScreenState extends State<BodyCellTestScreen> {
  List<String> selectedCells = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Body Cell Detection Test",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                selectedCells.clear();
              });
              debugPrint('🗑️ All selections cleared');
            },
            tooltip: "Clear All",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How to test:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap anywhere on the body map. The cell ID will be printed in the terminal and highlighted in red.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[800],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Body Map
            SizedBox(
              height: 500,
              child: InteractiveBodyCellMap(
                initialSelection: selectedCells,
                onSelectionChanged: (selected) {
                  setState(() {
                    selectedCells = selected;
                  });
                  
                  // Print to terminal
                  debugPrint('\n📊 ========== SELECTION UPDATE ==========');
                  debugPrint('Total selected: ${selected.length}');
                  debugPrint('Selected cells: $selected');
                  debugPrint('=========================================\n');
                },
              ),
            ),

            const SizedBox(height: 20),

            // Selected Cells Display
            if (selectedCells.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Selected Cells: ${selectedCells.length}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedCells.map((cellId) {
                        final cell = BodyCellDetector.getCellById(cellId);
                        return Chip(
                          label: Text(
                            cellId,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.red[100],
                          deleteIconColor: Colors.red[900],
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              selectedCells.remove(cellId);
                            });
                            debugPrint('🗑️ Cell $cellId removed');
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Cell Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.grid_on, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Grid Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow("Total Cells", "${bodyCells.length}"),
                  _buildInfoRow("Rows", "A, B, C, D, E (5 rows)"),
                  _buildInfoRow("Columns", "1-10 (10 columns)"),
                  _buildInfoRow("Coordinate System", "Normalized (0.0 - 1.0)"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Terminal Output Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.terminal, color: Colors.amber[800], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Check your terminal/console for detailed tap information including coordinates and cell detection logs.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber[900],
                        height: 1.4,
                      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[900],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
