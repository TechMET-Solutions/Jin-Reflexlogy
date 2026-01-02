import 'package:flutter/material.dart';

class BodyPainSelector extends StatefulWidget {
  const BodyPainSelector({super.key});

  @override
  State<BodyPainSelector> createState() => _BodyPainSelectorState();
}
class _BodyPainSelectorState extends State<BodyPainSelector> {
  final Set<String> selectedCells = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Area Selector')),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                return Stack(
                  children: [
                    Image.asset(
                      'assets/images/body_full.png',
                      width: w,
                      height: h,
                      fit: BoxFit.fill,
                    ),
                    _cell('A1', h * 0.17, w * 0.20),
                    _cell('A2', h * 0.17, w * 0.27),
                    _cell('A3', h * 0.17, w * 0.34),
                    _cell('A4', h * 0.17, w * 0.41),
                    _cell('A5', h * 0.17, w * 0.48),
                    _cell('A6', h * 0.17, w * 0.55),
                    _cell('A7', h * 0.17, w * 0.62),
                    _cell('A8', h * 0.17, w * 0.69),
                    _cell('A9', h * 0.17, w * 0.76),

                    /// 🔹 ROW B
                    _cell('B1', h * 0.27, w * 0.20),
                    _cell('B2', h * 0.27, w * 0.27),
                    _cell('B3', h * 0.27, w * 0.34),
                    _cell('B4', h * 0.27, w * 0.41),
                    _cell('B5', h * 0.27, w * 0.48),
                    _cell('B6', h * 0.27, w * 0.55),
                    _cell('B7', h * 0.27, w * 0.62),
                    _cell('B8', h * 0.27, w * 0.69),
                    _cell('B9', h * 0.27, w * 0.76),

                    /// 🔹 ROW C
                    _cell('C1', h * 0.38, w * 0.20),
                    _cell('C2', h * 0.38, w * 0.27),
                    _cell('C3', h * 0.38, w * 0.34),
                    _cell('C4', h * 0.38, w * 0.41),
                    _cell('C5', h * 0.38, w * 0.48),
                    _cell('C6', h * 0.38, w * 0.55),
                    _cell('C7', h * 0.38, w * 0.62),
                    _cell('C8', h * 0.38, w * 0.69),
                    _cell('C9', h * 0.38, w * 0.76),

                    /// 🔹 ROW D
                    _cell('D1', h * 0.49, w * 0.20),
                    _cell('D2', h * 0.49, w * 0.27),
                    _cell('D3', h * 0.49, w * 0.34),
                    _cell('D4', h * 0.49, w * 0.41),
                    _cell('D5', h * 0.49, w * 0.48),
                    _cell('D6', h * 0.49, w * 0.55),
                    _cell('D7', h * 0.49, w * 0.62),
                    _cell('D8', h * 0.49, w * 0.69),
                    _cell('D9', h * 0.49, w * 0.76),

                    /// 🔹 ROW E
                    _cell('E1', h * 0.60, w * 0.20),
                    _cell('E2', h * 0.60, w * 0.27),
                    _cell('E3', h * 0.60, w * 0.34),
                    _cell('E4', h * 0.60, w * 0.41),
                    _cell('E5', h * 0.60, w * 0.48),
                    _cell('E6', h * 0.60, w * 0.55),
                    _cell('E7', h * 0.60, w * 0.62),
                    _cell('E8', h * 0.60, w * 0.69),
                    _cell('E9', h * 0.60, w * 0.76),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(String id, double top, double left) {
    final isSelected = selectedCells.contains(id);

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected ? selectedCells.remove(id) : selectedCells.add(id);
          });
        },
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.green.withOpacity(0.5) : Colors.transparent,
            border: Border.all(color: Colors.green),
          ),
        ),
      ),
    );
  }
}
