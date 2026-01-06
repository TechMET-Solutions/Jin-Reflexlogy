// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:jin_reflex_new/screens/shop/cartscreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:jin_reflex_new/screens/shop/buy_now_form.dart';
// import 'package:jin_reflex_new/screens/shop/ui_model.dart';

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;
//   final String countryCode; // 🔥 in / us

//   const ProductDetailScreen({
//     super.key,
//     required this.product,
//     required this.countryCode,
//   });

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   int activeImage = 0;
//   bool isAddingToCart = false;

//   int? userId;
//   final int quantity = 1;

//   Product get p => widget.product;

//   // ================= INIT =================
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadUserId();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   // ================= USER ID =================
//   Future<void> _loadUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getInt("user_id");
//     });

//     debugPrint("👤 userId => $userId");
//     debugPrint("🌍 countryCode => ${widget.countryCode}");
//   }

//   // ================= ADD TO CART API =================
//   Future<void> addToCart() async {
//     if (userId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please login first")));
//       return;
//     }

//     const String url = "https://admin.jinreflexology.in/api/cart/add";

//     setState(() => isAddingToCart = true);

//     debugPrint("🛒 ADD TO CART START");
//     debugPrint(
//       "➡️ BODY => { user_id:$userId, product_id:${p.id}, quantity:$quantity, country:${widget.countryCode} }",
//     );

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//         body: {
//           "user_id": userId.toString(),
//           "product_id": p.id.toString(),
//           "quantity": quantity.toString(),
//           "country": widget.countryCode,
//         },
//       );

//       debugPrint("📥 STATUS : ${response.statusCode}");
//       debugPrint("📥 RESPONSE : ${response.body}");

//       if (response.statusCode != 200) {
//         throw Exception("HTTP ${response.statusCode}");
//       }

//       final decoded = jsonDecode(response.body);

//       if (decoded["success"] == true) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(decoded["message"])));

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const CartScreen()),
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(decoded["message"] ?? "Failed")));
//       }
//     } catch (e) {
//       debugPrint("❌ ADD TO CART ERROR => $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
//     }

//     setState(() => isAddingToCart = false);
//   }

//   // ================= IMAGE HELPERS =================
//   String imageAt(dynamic imgSource, int index) {
//     if (imgSource is List<String>) {
//       return imgSource[index.clamp(0, imgSource.length - 1)];
//     }
//     return imgSource?.toString() ?? '';
//   }

//   int imageCount(dynamic imgSource) {
//     if (imgSource is List<String>) return imgSource.length;
//     if (imgSource is String) return 1;
//     return 0;
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     final imgCount = imageCount(p.image);

//     return Scaffold(
//       appBar: AppBar(title: Text(p.title)),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // IMAGE SECTION
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 300,
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0xFFF7C85A)),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child:
//                             imgCount > 0
//                                 ? Image.network(
//                                   imageAt(p.image, activeImage),
//                                   fit: BoxFit.contain,
//                                 )
//                                 : const Icon(Icons.image),
//                       ),
//                       SizedBox(
//                         height: 80,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: imgCount,
//                           itemBuilder: (context, i) {
//                             return GestureDetector(
//                               onTap: () => setState(() => activeImage = i),
//                               child: Container(
//                                 width: 70,
//                                 margin: const EdgeInsets.only(right: 8),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color:
//                                         activeImage == i
//                                             ? Colors.orange
//                                             : Colors.grey,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Image.network(
//                                   imageAt(p.image, i),
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // PRODUCT INFO
//                 Expanded(
//                   flex: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           p.title,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "₹ ${p.unitPrice.toStringAsFixed(0)}",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => BuyNowFormScreen(product: p),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             "Buy Now",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         OutlinedButton(
//                           onPressed: isAddingToCart ? null : () => addToCart(),
//                           child:
//                               isAddingToCart
//                                   ? const CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                   )
//                                   : const Text("Add to Cart"),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             productTabs(
//               controller: _tabController,
//               details: p.details,
//               description: p.description,
//               additionalInfo: p.additionalInfo,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= TABS =================
//   Widget infoBox(String text) {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.amber.shade300),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(text),
//     );
//   }

//   Widget productTabs({
//     required TabController controller,
//     required String details,
//     required String description,
//     required String additionalInfo,
//   }) {
//     return Column(
//       children: [
//         TabBar(
//           controller: controller,
//           labelColor: Colors.black,
//           tabs: const [
//             Tab(text: "Details"),
//             Tab(text: "Description"),
//             Tab(text: "Additional Info"),
//           ],
//         ),
//         SizedBox(
//           height: 140,
//           child: TabBarView(
//             controller: controller,
//             children: [
//               infoBox(details),
//               infoBox(description),
//               infoBox(additionalInfo),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }