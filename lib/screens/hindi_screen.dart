import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class HindiBookScreen extends StatefulWidget {
  const HindiBookScreen({super.key});

  @override
  State<HindiBookScreen> createState() => _HindiBookScreenState();
}

class _HindiBookScreenState extends State<HindiBookScreen> {
  int pageIndex = 1;
  int lastPage = 208;

  bool loading = false;
  ImageProvider? pageImage;

  final TextEditingController searchController = TextEditingController();


  final String apiUrl = "https://jainacupressure.com/api/hindi_book.php";

  @override
  void initState() {
    super.initState();
    fetchPage(pageIndex);
  }

  Future<void> fetchPage(int pageNo) async {
    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "a": "1",
          "name": pageNo.toString(),
        },
      );

      final json = jsonDecode(response.body);

      if (json["success"] == 1) {
        final String base64img = json["data"][0]["image"];
        final bytes = base64Decode(base64img);

        setState(() {
          pageImage = MemoryImage(bytes);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    setState(() => loading = false);
  }

  void nextPage() {
    if (pageIndex >= lastPage) {
      pageIndex = 1;
    } else {
      pageIndex++;
    }
    fetchPage(pageIndex);
  }

  void prevPage() {
    if (pageIndex <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are at first page")),
      );
      return;
    }
    pageIndex--;
    fetchPage(pageIndex);
  }

  void gotoPage() {
    int page = int.tryParse(searchController.text) ?? 0;

    if (page < 1 || page > lastPage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This book has $lastPage pages.")),
      );
      return;
    }

    pageIndex = page;
    fetchPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Hindi eBook"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                _button("Prev", Colors.red, prevPage),
                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Page No",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                _button("Go", Colors.green, gotoPage),
                const SizedBox(width: 8),
                _button("Next", Colors.red, nextPage),
              ],
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                : pageImage == null
                    ? const Center(child: Text("No Image"))
                    : PhotoView(
                        backgroundDecoration:
                            const BoxDecoration(color: Colors.white),
                        imageProvider: pageImage!,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 4,
                      ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
