import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart';

class EnglishBookScreen extends StatefulWidget {
  const EnglishBookScreen({super.key, this.url, this.name});
  final url;
  final name;

  @override
  State<EnglishBookScreen> createState() => _EnglishBookScreenState();
}

class _EnglishBookScreenState extends State<EnglishBookScreen> {
  int pageIndex = 1;
  int lastPage = 201;

  bool loading = false;
  ImageProvider? pageImage;

  final TextEditingController searchController = TextEditingController();

  // API URL
  // final String apiUrl = "${w}";

  @override
  void initState() {
    super.initState();
    fetchPage(pageIndex);
  }

  // ===================== API USING DIO HERE =====================
  Future<void> fetchPage(int pageNo) async {
    setState(() => loading = true);

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "a": "1",
        "name": pageNo.toString(),   // page number
      });

      Response response = await dio.post(
        widget.url,
        data: formData, 
        options: Options(contentType: "multipart/form-data"),
      );

      dynamic jsonBody;

      // Response may be String or JSON Map
      if (response.data is String) {
        jsonBody = jsonDecode(response.data);
      } else {
        jsonBody = response.data;
      }

      if (jsonBody["success"] == 1) {
        final String base64img = jsonBody["data"][0]["image"];
        final bytes = base64Decode(base64img);

        setState(() {
          pageImage = MemoryImage(bytes);
        });
      } else {
        debugPrint("Failed: ${jsonBody["data"]}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    setState(() => loading = false);
  }
  // ===============================================================

  // Next Page
  void nextPage() {
    if (pageIndex >= lastPage) {
      pageIndex = 1;
    } else {
      pageIndex++;
    }
    fetchPage(pageIndex);
  }

  // Previous Page
  void prevPage() {
    if (pageIndex <= 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("You are at first page")));
    } else {
      pageIndex--;
      fetchPage(pageIndex);
    }
  }

  // Go to page
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

      appBar: CommonAppBar(title: "${widget.name}"),
      body: Column(
        children: [
          // TOP CONTROLS
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                _button("Prev", Colors.red, prevPage),
                const SizedBox(width: 8),

                // Search input
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

          // IMAGE VIEWER (Zoomable)
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange),
                  )
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

  // Reusable Buttons
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
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
