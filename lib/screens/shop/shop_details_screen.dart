import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/screens/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/screens/shop/buy_now_form.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';
import 'package:jin_reflex_new/screens/shop/cartscreen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String deliveryType; // 🔥 REQUIRED

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.deliveryType,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int activeImage = 0;
  bool isAddingToCart = false;

  int userId = 0;
  final int quantity = 1;

  Product get p => widget.product;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = AppPreference();
    final id = prefs.getString(PreferencesKey.userId);
    setState(() => userId = int.tryParse(id ?? "0") ?? 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ================= ADD TO CART API =================
  Future<void> addToCart() async {
    const String url = "https://admin.jinreflexology.in/api/cart/add";

    final prefs = AppPreference();
    final token = prefs.getString(PreferencesKey.token);

    final String country = widget.deliveryType == "india" ? "in" : "us";

    if (token.isEmpty || userId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    setState(() => isAddingToCart = true);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "user_id": userId.toString(),
          "product_id": p.id.toString(),
          "quantity": quantity.toString(),
          "country": country,
        },
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded["message"] ?? "Added to cart")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CartScreen(deliveryType: widget.deliveryType),
          ),
        );
      } else {
        throw decoded["message"] ?? "Add to cart failed";
      }
    } catch (e) {
      debugPrint("❌ ADD TO CART ERROR: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isAddingToCart = false);
  }

  // ================= IMAGE HELPERS =================
  String imageAt(dynamic imgSource, int index) {
    if (imgSource is List<String>) {
      if (imgSource.isEmpty) return '';
      return imgSource[index.clamp(0, imgSource.length - 1)];
    } else if (imgSource is String) {
      return imgSource;
    }
    return '';
  }

  int imageCount(dynamic imgSource) {
    if (imgSource is List<String>) return imgSource.length;
    if (imgSource is String) return 1;
    return 0;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final token = AppPreference().getString(PreferencesKey.token);
    final type = AppPreference().getString(PreferencesKey.type);
print("ddddddddddddddddddddddddddddddddddddddddddddd${type}");
print("ddddddddddddddddddddddddddddddddddddddddddddd${token}");
    final imgCount = imageCount(p.image);

    return Scaffold(
      appBar: CommonAppBar(title: p.title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE SECTION
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFF7C85A)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              imgCount > 0
                                  ? Image.network(
                                    imageAt(p.image, activeImage),
                                    fit: BoxFit.contain,
                                  )
                                  : const Icon(Icons.image),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imgCount,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () => setState(() => activeImage = i),
                                child: Container(
                                  width: 70,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          activeImage == i
                                              ? Colors.orange
                                              : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    imageAt(p.image, i),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // PRODUCT INFO
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${widget.deliveryType == "india" ? "₹" : "\$"}${p.unitPrice.toStringAsFixed(0)}",

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.black,
                          //   ),
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (_) =>
                          //             BuyNowFormScreen(product: p),
                          //       ),
                          //     );
                          //   },
                          //   child: const Text(
                          //     "Buy Now",
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                          const SizedBox(height: 8),

                          OutlinedButton(
                            onPressed:
                                isAddingToCart
                                    ? null
                                    : () {
                                      if (token.isEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => JinLoginScreen(
                                                  text: "ShopScreen",
                                                  type: "",
                                                  diliveryType:
                                                      widget.deliveryType,
                                                  onTab: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                LifestyleScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                          ),
                                        );
                                      } else {
                                        addToCart();
                                      }
                                    },
                            child:
                                isAddingToCart
                                    ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text("Add to Cart"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              productTabs(
                controller: _tabController,
                details: p.details,
                description: p.description,
                additionalInfo: p.additionalInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productTabs({
    required TabController controller,
    required String details,
    required String description,
    required String additionalInfo,
  }) {
    return Column(
      children: [
        TabBar(
          controller: controller,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: "Details"),
            Tab(text: "Description"),
            Tab(text: "Additional Info"),
          ],
        ),
        SizedBox(
          height: 140,
          child: TabBarView(
            controller: controller,
            children: [Text(details), Text(description), Text(additionalInfo)],
          ),
        ),
      ],
    );
  }
}
