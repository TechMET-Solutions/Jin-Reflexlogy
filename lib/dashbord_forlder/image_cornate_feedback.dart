import 'package:flutter/material.dart';

/// MODEL
class BodyCell {
  final String id;

  double x; // now editable
  double y; // now editable
  double w;
  double h;

  BodyCell({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });
}

/// MAIN SCREEN
class BodyGridScreen extends StatefulWidget {
  @override
  State<BodyGridScreen> createState() => _BodyGridScreenState();
}

class _BodyGridScreenState extends State<BodyGridScreen> {

  /// MULTI SELECT STORAGE
  Set<String> selectedIds = {};

  /// BODY CELLS
 final List<BodyCell> bodyCells =  [

    // Row A
    BodyCell(id: 'A1', x: 0.060, y:  0.083, w: 0.17, h: 0.090),
    BodyCell(id: 'A2', x:  0.309, y:  0.174, w: 0.0710, h: 0.070),
    BodyCell(id: 'A3', x: 0.307, y:  0.074, w: 0.06, h: 0.10),
    BodyCell(id: 'A4', x:  0.367, y: 0.076, w: 0.07, h: 0.10),
    BodyCell(id: 'A5', x:  0.368, y:0.174, w: 0.075, h: 0.070),
    BodyCell(id: 'A6', x: 0.522, y: 0.110, w: 0.0733, h: 0.13),
    BodyCell(id: 'A7', x: 0.59, y: 0.110, w: 0.07, h: 0.13),
    BodyCell(id: 'A8', x: 0.66, y: 0.110, w: 0.06, h: 0.13),
    BodyCell(id: 'A9', x: 0.72, y: 0.110, w: 0.07, h: 0.13),
    BodyCell(id: 'A10', x: 0.81, y: 0.110, w: 0.166, h: 0.13),

    // Row B
    BodyCell(id: 'B1', x: 0.058, y: 0.177, w: 0.17, h: 0.07),
    BodyCell(id: 'B2', x:  0.240, y: 0.178, w: 0.07, h: 0.070),
    BodyCell(id: 'B3', x: 0.437, y:0.176, w: 0.07, h: 0.070),
    BodyCell(id: 'B4', x: 0.370, y: 0.250, w: 0.07, h: 0.090),
    BodyCell(id: 'B5', x: 0.44, y: 0.246, w: 0.077, h: 0.04),
    BodyCell(id: 'B6', x: 0.522, y: 0.246, w: 0.0733, h: 0.04),
    BodyCell(id: 'B7', x: 0.59, y: 0.246, w: 0.07, h: 0.04),
    BodyCell(id: 'B8', x: 0.66, y: 0.246, w: 0.06, h: 0.04),
    BodyCell(id: 'B9', x: 0.72, y: 0.246, w: 0.07, h: 0.04),
    BodyCell(id: 'B10', x: 0.81, y: 0.246, w: 0.166, h: 0.04),

    // Row C
    BodyCell(id: 'C1', x: 0.060, y:   0.251, w: 0.17, h: 0.090),
    BodyCell(id: 'C2', x:  0.236, y: 0.251, w: 0.07, h: 0.090),
    BodyCell(id: 'C3', x: 0.307, y: 0.251, w: 0.06, h: 0.090),
    BodyCell(id: 'C4', x: 0.37, y: 0.440, w: 0.07, h: 0.05),
    BodyCell(id: 'C5', x: 0.44, y: 0.440, w: 0.077, h: 0.05),
    BodyCell(id: 'C6', x: 0.522, y: 0.440, w: 0.0733, h: 0.05),
    BodyCell(id: 'C7', x: 0.59, y: 0.440, w: 0.07, h: 0.05),
    BodyCell(id: 'C8', x: 0.66, y: 0.440, w: 0.06, h: 0.05),
    BodyCell(id: 'C9', x: 0.72, y: 0.440, w: 0.07, h: 0.05),
    BodyCell(id: 'C10', x: 0.81, y: 0.440, w: 0.166, h: 0.05),

    // Row D
    BodyCell(id: 'D1', x: 0.057, y: 0.345, w: 0.17, h: 0.050),
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
    BodyCell(id: 'E1', x:  0.062, y:  0.395, w: 0.17, h: 0.27),
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

  @override
  Widget build(BuildContext context) {
 
    double screenWidth = MediaQuery.of(context).size.width;

    double imageWidth = screenWidth;
    double imageHeight = screenWidth * 1.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Body Tap Grid"),
      ),

      body: SizedBox(
        height: 450,
        child: Stack(
          children: [
        
            /// IMAGE
            Image.asset(
              "assets/images/fedback.jpeg",
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.fill,
            ),
        
            /// CLICKABLE AREA
            SizedBox(
              width: imageWidth,
              height: imageHeight,
        
              child: Stack(
                children: bodyCells.map((cell) {
        
                  double left = cell.x * imageWidth;
                  double top = cell.y * imageHeight;
                  double width = cell.w * imageWidth;
                  double height = cell.h * imageHeight;
        
                  return Positioned(
                    left: left,
                    top: top,
                    width: width,
                    height: height,
        
                    child: GestureDetector(
          onTap: () {
            setState(() {
              if (selectedIds.contains(cell.id)) {
        selectedIds.remove(cell.id);
              } else {
        selectedIds.add(cell.id);
              }
            });
        
            debugPrint("Selected: ${cell.id}");
          },
        
          /// DRAG TO MOVE
          onPanUpdate: (details) {
        
            setState(() {
        
              // Convert pixel movement to %
              double dx = details.delta.dx / imageWidth;
              double dy = details.delta.dy / imageHeight;
        
              cell.x += dx;
              cell.y += dy;
        
              // Limit inside image
              cell.x = cell.x.clamp(0.0, 1.0 - cell.w);
              cell.y = cell.y.clamp(0.0, 1.0 - cell.h);
            });
        
            /// TERMINAL LOG
            debugPrint("Moved ${cell.id}");
            debugPrint("New X: ${cell.x.toStringAsFixed(3)}");
            debugPrint("New Y: ${cell.y.toStringAsFixed(3)}");
          },
        
          child: Container(
            decoration: BoxDecoration(
              color: selectedIds.contains(cell.id)
          ? Colors.red.withOpacity(0.4)
          : Colors.transparent,
        
              border: Border.all(color: Colors.black26),
            ),
          ),
        ),
        
                  );
        
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
