import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
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
  
  // For page caching
  final Map<int, ImageProvider> _pageCache = {};
  
  bool loading = false;
  ImageProvider? _currentPageImage;
  
  final TextEditingController searchController = TextEditingController();
  final Dio _dio = Dio(); // Reuse Dio instance

  @override
  void initState() {
    super.initState();
    _fetchPage(pageIndex);
    // Preload next page
    _preloadNextPage();
  }

  // Preloading
  void _preloadNextPage() {
    if (pageIndex < lastPage && !_pageCache.containsKey(pageIndex + 1)) {
      _fetchPageForCache(pageIndex + 1);
    }
  }

  // Load page for cache (without refreshing UI)
  Future<void> _fetchPageForCache(int pageNo) async {
    try {
      FormData formData = FormData.fromMap({
        "a": "1",
        "name": pageNo.toString(),
      });

      Response response = await _dio.post(
        widget.url,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      dynamic jsonBody;
      if (response.data is String) {
        jsonBody = jsonDecode(response.data);
      } else {
        jsonBody = response.data;
      }

      if (jsonBody["success"] == 1) {
        final String base64img = jsonBody["data"][0]["image"];
        final bytes = base64Decode(base64img);
        
        // Save to cache
        _pageCache[pageNo] = MemoryImage(bytes);
      }
    } catch (e) {
      debugPrint("Preload Error for page $pageNo: $e");
    }
  }

  // Load current page
  Future<void> _fetchPage(int pageNo) async {
    // If already in cache, use it
    if (_pageCache.containsKey(pageNo)) {
      setState(() {
        _currentPageImage = _pageCache[pageNo];
        loading = false;
      });
      return;
    }

    setState(() => loading = true);

    try {
      FormData formData = FormData.fromMap({
        "a": "1",
        "name": pageNo.toString(),
      });

      Response response = await _dio.post(
        widget.url,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      dynamic jsonBody;
      if (response.data is String) {
        jsonBody = jsonDecode(response.data);
      } else {
        jsonBody = response.data;
      }

      if (jsonBody["success"] == 1) {
        final String base64img = jsonBody["data"][0]["image"];
        final bytes = base64Decode(base64img);
        final image = MemoryImage(bytes);
        
        // Save to cache
        _pageCache[pageNo] = image;
        
        setState(() {
          _currentPageImage = image;
        });
      } else {
        debugPrint("Failed: ${jsonBody["data"]}");
        _showErrorSnackbar("Failed to load page");
      }
    } catch (e) {
      debugPrint("Error: $e");
      _showErrorSnackbar("Connection error");
    }

    setState(() => loading = false);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Next Page
  void nextPage() {
    if (pageIndex >= lastPage) {
      pageIndex = 1;
    } else {
      pageIndex++;
    }
    
    // Update URL parameter
    setState(() {});
    
    _fetchPage(pageIndex);
    _preloadNextPage();
    
    // Also preload previous page
    if (pageIndex > 1 && !_pageCache.containsKey(pageIndex - 1)) {
      _fetchPageForCache(pageIndex - 1);
    }
  }

  // Previous Page
  void prevPage() {
    if (pageIndex <= 1) {
      _showErrorSnackbar("You are on the first page");
      return;
    }
    
    pageIndex--;
    
    // Update URL parameter
    setState(() {});
    
    _fetchPage(pageIndex);
  }

  // Go to specific page
  void gotoPage() {
    final text = searchController.text.trim();
    if (text.isEmpty) return;
    
    int? page = int.tryParse(text);
    
    if (page == null || page < 1 || page > lastPage) {
      _showErrorSnackbar("This book has only $lastPage pages");
      searchController.clear();
      return;
    }

    pageIndex = page;
    
    // Update URL parameter
    setState(() {});
    
    _fetchPage(pageIndex);
    searchController.clear();
    
    // Remove focus
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: CommonAppBar(title: "${widget.name} - Page $pageIndex/$lastPage"),
      
      body: Column(
        children: [
          // Controls Bar
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                _button("Prev", Colors.blue, prevPage),
                const SizedBox(width: 8),

                // Page number search
                Expanded(
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => gotoPage(),
                    decoration: InputDecoration(
                      hintText: "Enter page number",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                _button("Go", Colors.green, gotoPage),
                const SizedBox(width: 8),
                _button("Next", Colors.blue, nextPage),
              ],
            ),
          ),

          // Page Viewer
          Expanded(
            child: Stack(
              children: [
                // Image viewer
                if (_currentPageImage != null)
                  PhotoView(
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.white),
                    imageProvider: _currentPageImage!,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 4,
                    loadingBuilder: (context, event) =>
                        const Center(child: CircularProgressIndicator()),
                  ),

                // Loading indicator
                if (loading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Button widget
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}