import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/screens/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/screens/shop/shop_details_screen.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:jin_reflex_new/screens/shop/cartscreen.dart';

class ShopScreen extends StatefulWidget {
  final String deliveryType; // india / outside

  const ShopScreen({super.key, required this.deliveryType});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool isLoading = true;
  bool hasError = false;

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  List<String> categories = ["All"];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // ================= LOAD PRODUCTS =================
  Future<void> loadProducts() async {
    try {
      allProducts = await fetchProducts();
      filteredProducts = allProducts;

      final Set<String> categorySet = {};

      for (var product in allProducts) {
        for (var cat in product.categories) {
          categorySet.add(cat);
        }
      }

      categories = ["All", ...categorySet];
      hasError = false;
    } catch (e) {
      hasError = true;
      debugPrint("❌ LoadProducts Error: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  // ================= FILTER =================
  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        filteredProducts = allProducts;
      } else {
        filteredProducts =
            allProducts.where((p) => p.categories.contains(category)).toList();
      }
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final token = AppPreference().getString(PreferencesKey.token);
    final type = AppPreference().getString(PreferencesKey.type);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CommonAppBar(
        title:
            widget.deliveryType == "india"
                ? "Shop (India Delivery)"
                : "Shop (Outside India)",
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(deliveryType: widget.deliveryType),
                ),
              );
            },
          ),
        ],
      ),
      body:
           Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        isDense: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          labelText: "Select Category",
                          border: OutlineInputBorder(),
                        ),
                        items:
                            categories
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(
                                      cat,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            filterByCategory(value);
                          }
                        },
                      ),
                    ),
                  ),

                  // 🔲 PRODUCTS GRID
                  Expanded(
                    child:
                        filteredProducts.isEmpty
                            ? const Center(child: Text("No products found"))
                            : GridView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: filteredProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 0.65,
                                  ),
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];

                                return  GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ProductDetailScreen(
                                              product: product,
                                              deliveryType: widget.deliveryType,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFf7c85a),
                                      ),
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
                                                  )
                                                  : const Icon(
                                                    Icons.image,
                                                    size: 40,
                                                  ),
                                        ),
                                        const Divider(color: Color(0xFFf7c85a)),
                                        Text(
                                          product.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${widget.deliveryType == "india" ? "₹" : "\$"}${product.unitPrice.toStringAsFixed(0)}",
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  // ================= API =================
Future<List<Product>> fetchProducts() async {
  final String country = widget.deliveryType == "india" ? "in" : "us";

  const String url =
      "https://admin.jinreflexology.in/api/products/by-country";

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"country": country}),
  );

  final Map<String, dynamic> jsonData = json.decode(response.body);
  final List list = jsonData["data"] ?? [];

  // फक्त non-course प्रोडक्ट (course = 0) घ्या
  final List nonCourseProducts = list.where((e) {
    final isCourse = e["course"] == 1;
    return !isCourse; // फक्त course = 0 प्रोडक्ट घ्या
  }).toList();

  return nonCourseProducts.map<Product>((e) {
    final List images = e["images"] ?? [];
    final List pricing = e["pricing"] ?? [];
    final List categoryList = e["categories"] ?? [];

    final pricingForCountry = pricing.firstWhere(
      (p) => p["country"] == country,
      orElse: () => null,
    );

    final double unitPrice =
        pricingForCountry != null
            ? double.parse(pricingForCountry["unit_price"].toString())
            : 0;

    return Product(
      id: e["id"].toString(),
      title: e["title"] ?? "",
      image: images.isNotEmpty ? images.first : "",
      unitPrice: unitPrice,
      shippingPrice: 0,
      description: e["description"] ?? "",
      details: e["description"] ?? "",
      additionalInfo: "",
      categories:
          categoryList
              .map<String>((c) => c['name']?.toString() ?? "")
              .where((e) => e.isNotEmpty)
              .toList(),
    );
  }).toList();
}
}