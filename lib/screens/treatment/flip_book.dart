import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

class BookSpreadFlip extends StatefulWidget {
  final List<String> imagePaths;

  const BookSpreadFlip({super.key, required this.imagePaths});

  @override
  State<BookSpreadFlip> createState() => _BookSpreadFlipState();
}

class _BookSpreadFlipState extends State<BookSpreadFlip> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: PageFlipWidget(
            key: _controller,
            backgroundColor: Colors.transparent,
            children:
                widget.imagePaths.map((imagePath) {
                  return _singlePage(imagePath);
                }).toList(),
          ),
        ),
      ],
    );
  }
  Widget _singlePage(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
    );
  }
}
