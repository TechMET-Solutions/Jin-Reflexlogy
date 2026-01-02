import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/shop/shop_details_screen.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class ShopScreen extends StatefulWidget {
  final String deliveryType; // india / outside

  const ShopScreen({super.key, required this.deliveryType});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Product> products = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // ================= LOAD PRODUCTS =================
  Future<void> loadProducts() async {
    try {
      products = await fetchProducts();
      hasError = false;

      // DEBUG
      for (var p in products) {
        debugPrint("🖼️ PRODUCT IMAGE => ${p.image}");
      }
    } catch (e) {
      hasError = true;
      debugPrint("❌ LoadProducts Error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CommonAppBar(
        title:
            widget.deliveryType == "india"
                ? "Shop (India Delivery)"
                : "Shop (Outside India)",
      ),
      body:
          hasError
              ? const Center(child: Text("Something went wrong"))
              : products.isEmpty
              ? const Center(child: Text("No products available"))
              : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFf7c85a)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child:
                                product.image.isNotEmpty
                                    ? Image.network(
                                      product.image,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (_, __, ___) => const Icon(
                                            Icons.broken_image,
                                            size: 40,
                                          ),
                                    )
                                    : const Icon(Icons.image, size: 40),
                          ),
                          const Divider(color: Color(0xFFf7c85a)),
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₹ ${product.price.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  // ================= API (BY COUNTRY) =================
  Future<List<Product>> fetchProducts() async {
    final String country = widget.deliveryType == "india" ? "in" : "us";

    const String url =
        "https://admin.jinreflexology.in/api/products/by-country";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"country": country}),
      );

      debugPrint("🌐 RAW RESPONSE => ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("HTTP Error ${response.statusCode}");
      }

      final Map<String, dynamic> data = json.decode(response.body);
      final List list = data["data"] ?? [];

      debugPrint("📦 TOTAL PRODUCTS => ${list.length}");

      return list.map<Product>((e) {
        final List images = e["images"] ?? [];

        return Product(
          id: e["id"].toString(), // ✅ FIX HERE
          title: e["title"] ?? "",
          image: images.isNotEmpty ? images.first.toString() : "",
          price: double.tryParse(e["total_price"]?.toString() ?? "0") ?? 0,
          details: e["description"] ?? "",
          description: e["description"] ?? "",
          additionalInfo:
              "Shipping ₹ ${e["shipping_charges"]?.toString() ?? "0"}",
        );
      }).toList();
    } catch (e) {
      debugPrint("❌ Country API Error: $e");
      rethrow;
    }
  }
}
