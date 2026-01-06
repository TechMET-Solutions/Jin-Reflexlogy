// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:jin_reflex_new/screens/shop/shop_details_screen.dart';
// import 'package:jin_reflex_new/screens/shop/ui_model.dart';
// import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
// import 'package:jin_reflex_new/shop/cartscreen.dart';

// class ShopScreen extends StatefulWidget {
//   final String deliveryType; // india / outside

//   const ShopScreen({super.key, required this.deliveryType});

//   @override
//   State<ShopScreen> createState() => _ShopScreenState();
// }

// class _ShopScreenState extends State<ShopScreen> {
//   List<Product> products = [];
//   bool isLoading = true;
//   bool hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     loadProducts();
//   }

//   // ================= LOAD PRODUCTS =================
//   Future<void> loadProducts() async {
//     try {
//       products = await fetchProducts();
//       hasError = false;
//     } catch (e) {
//       hasError = true;
//       debugPrint("❌ LoadProducts Error: $e");
//     }

//     if (mounted) {
//       setState(() => isLoading = false);
//     }
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: CommonAppBar(
//         title:
//             widget.deliveryType == "india"
//                 ? "Shop (India Delivery)"
//                 : "Shop (Outside India)",
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const CartScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body:
//           hasError
//               ? const Center(child: Text("Something went wrong"))
//               : products.isEmpty
//               ? const Center(child: Text("No products available"))
//               : GridView.builder(
//                 padding: const EdgeInsets.all(10),
//                 itemCount: products.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 8,
//                   crossAxisSpacing: 8,
//                   childAspectRatio: 0.65,
//                 ),
//                 itemBuilder: (context, index) {
//                   final product = products[index];

//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ProductDetailScreen(product: product),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: const Color(0xFFf7c85a)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child:
//                                 product.image.isNotEmpty
//                                     ? Image.network(
//                                       product.image,
//                                       fit: BoxFit.contain,
//                                       errorBuilder:
//                                           (_, __, ___) => const Icon(
//                                             Icons.broken_image,
//                                             size: 40,
//                                           ),
//                                     )
//                                     : const Icon(Icons.image, size: 40),
//                           ),
//                           const Divider(color: Color(0xFFf7c85a)),
//                           Text(
//                             product.title,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13,
//                             ),
//                             textAlign: TextAlign.center,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "₹ ${product.unitPrice.toStringAsFixed(0)}",
//                             style: const TextStyle(fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }

//   // ================= API (NEW STRUCTURE) =================
//   Future<List<Product>> fetchProducts() async {
//     final String country = widget.deliveryType == "india" ? "in" : "us";

//     const String url =
//         "https://admin.jinreflexology.in/api/products/by-country";

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"country": country}),
//       );

//       debugPrint("🌐 RAW RESPONSE => ${response.body}");

//       if (response.statusCode != 200) {
//         throw Exception("HTTP Error ${response.statusCode}");
//       }

//       final Map<String, dynamic> jsonData = json.decode(response.body);

//       final List list = jsonData["data"] ?? [];

//       return list.map<Product>((e) {
//         final List images = e["images"] ?? [];
//         final List pricing = e["pricing"] ?? [];

//         // 🔥 get pricing for selected country
//         final pricingForCountry =
//             pricing.isNotEmpty
//                 ? pricing.firstWhere(
//                   (p) => p["country"] == country,
//                   orElse: () => null,
//                 )
//                 : null;

//         final double unitPrice =
//             pricingForCountry != null
//                 ? double.tryParse(
//                       pricingForCountry["unit_price"]?.toString() ?? "0",
//                     ) ??
//                     0
//                 : 0;

//         final double shippingPrice =
//             pricingForCountry != null
//                 ? double.tryParse(
//                       pricingForCountry["shipping_price"]?.toString() ?? "0",
//                     ) ??
//                     0
//                 : 0;

//         final double totalPrice =
//             pricingForCountry != null
//                 ? double.tryParse(
//                       pricingForCountry["total_price"]?.toString() ?? "0",
//                     ) ??
//                     0
//                 : unitPrice + shippingPrice;

//         return Product(
//           id: e["id"].toString(),
//           title: e["title"] ?? "",
//           image: images.isNotEmpty ? images.first.toString() : "",
//           unitPrice: unitPrice,
//           shippingPrice: shippingPrice,
//           description: e["description"] ?? "",
//           details: e["description"] ?? "",
//           additionalInfo: "Shipping ₹ $shippingPrice",
//         );
//       }).toList();
//     } catch (e) {
//       debugPrint("❌ Country API Error: $e");
//       rethrow;
//     }
//   }
// }
