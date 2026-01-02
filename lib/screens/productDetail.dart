// import 'package:flutter/material.dart';

// class Product {
//   final String id;
//   final String title;
//   final String image;
//   final double price;
//   final String details;
//   final String description;
//   final String additionalInfo;

//   Product({
//     required this.id,
//     required this.title,
//     required this.image,
//     required this.price,
//     required this.details,
//     required this.description,
//     required this.additionalInfo,
//   });
// }

// List<Product> products = [
//   Product(
//     id: "1",
//     title: "4G Super Magnet",
//     image: "assets/hand_left.png",
//     price: 4000,
//     details: "More details are available in the User manual Book.",
//     description: "4G Super Magnet useful for treatment of acidity, BP, etc.",
//     additionalInfo: "Manufactured by JIN Health Care.",
//   ),
//   Product(
//     id: "2",
//     title: "Magnet Stick",
//     image: "assets/hand_right.png",
//     price: 4000,
//     details: "Powerful stick for acupressure.",
//     description: "Useful for healing therapy.",
//     additionalInfo: "JIN Therapy Tool.",
//   ),
// ];

// class ShopScreen extends StatelessWidget {
//   const ShopScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Shop")),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(10),
//         itemCount: products.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 8,
//           crossAxisSpacing: 8,
//           childAspectRatio: 0.65,
//         ),
//         itemBuilder: (context, index) {
//           final p = products[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ProductDetailScreen(product: p),
//                 ),
//               );
//             },
//             child: Container(
//               padding: const EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFf7c85a)),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Image.asset(p.image, fit: BoxFit.contain),
//                   ),
//                   const Divider(color: Color(0xFFf7c85a)),
//                   Text(
//                     p.title,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     textAlign: TextAlign.center,
//                   ),
//                   Text("₹ ${p.price.toStringAsFixed(0)}"),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;
//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   // <-- fix: define activeImage
//   int activeImage = 0;

//   @override
//   void initState() {
//     _tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   // helper to normalize image source (handles List<String> or String)
//   String imageAt(dynamic imgSource, int index) {
//     if (imgSource is List<String>) {
//       if (imgSource.isEmpty)
//         return ''; // return empty so Image.asset throws a clear error
//       final idx = index.clamp(0, imgSource.length - 1);
//       return imgSource[idx];
//     } else if (imgSource is String) {
//       return imgSource;
//     } else {
//       return '';
//     }
//   }

//   // helper to check image count
//   int imageCount(dynamic imgSource) {
//     if (imgSource is List<String>) return imgSource.length;
//     if (imgSource is String) return 1;
//     return 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final p = widget.product;

//     final int imgCount = imageCount(p.image);

//     return Scaffold(
//       appBar: AppBar(title: Text(p.title)),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 30,
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 300,
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: const Color(0xFFF7C85A)),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: imgCount > 0
//                             ? Image.asset(
//                                 imageAt(p.image, activeImage),
//                                 fit: BoxFit.contain,
//                               )
//                             : const Center(child: Icon(Icons.image)),
//                       ),
//                       SizedBox(
//                         height: 70,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: imgCount,
//                           itemBuilder: (context, i) {
//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() => activeImage = i);
//                               },
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 70,
//                                     margin: const EdgeInsets.only(right: 10),
//                                     padding: const EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: activeImage == i
//                                             ? Colors.white
//                                             : Colors.white,
//                                         width: activeImage == i ? 2 : 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: imgCount > 0
//                                         ? Image.asset(
//                                             imageAt(p.image, i),
//                                             fit: BoxFit.contain,
//                                           )
//                                         : const SizedBox.shrink(),
//                                   ),
//                                   Container(
//                                     width: 70,
//                                     margin: const EdgeInsets.only(right: 10),
//                                     padding: const EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: activeImage == i
//                                             ? Colors.white
//                                             : Colors.white,
//                                         width: activeImage == i ? 2 : 1,
//                                       ),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: imgCount > 0
//                                         ? Image.asset(
//                                             imageAt(p.image, i),
//                                             fit: BoxFit.contain,
//                                           )
//                                         : const SizedBox.shrink(),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Title + Price + Add to Cart
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       Text(
//                         p.title,
//                         style: const TextStyle(
//                             fontSize: 12, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(children: [
//                         Text(
//                           "₹ ${p.price}",
//                           style: const TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(width: 10),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                           ),
//                           onPressed: () {},
//                           child: const Text("Add To Cart",
//                               style:
//                                   TextStyle(fontSize: 10, color: Colors.white)),
//                         ),
//                       ]),
//                       const Text(
//                         "4G Super Power useful",
//                         textAlign: TextAlign.justify, 
//                         style: TextStyle(
//                           fontSize: 12,
//                           height: 1.5, 
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
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
//             sectionTitle("How to use 4G Super Power - Practical Session"),
//             Container(
//               height: 200,
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.amber.shade200),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Center(
//                 child: Icon(Icons.image, size: 40),
//               ),
//             ),

//             // Browse other products
//             sectionTitle("Browse Other Products -"),
//             SizedBox(
//               height: 180,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: products.length,
//                 itemBuilder: (context, i) {
//                   final prod = products[i];
//                   // show first image if prod.image is a list
//                   final thumb = imageAt(prod.image, 0);
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ProductDetailScreen(product: prod),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: 150,
//                       margin: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: const Color(0xFFF7C85A)),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: thumb.isNotEmpty
//                                 ? Image.asset(thumb, fit: BoxFit.cover)
//                                 : const Icon(Icons.image),
//                           ),
//                           Text(prod.title),
//                           Text("₹ ${prod.price}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

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

//   Widget sectionTitle(String title) {
//     return Container(
//       alignment: Alignment.centerLeft,
//       margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
//       padding: const EdgeInsets.all(10),
//       decoration: const BoxDecoration(
//         color: Color(0xFFF0E6D6),

//         // ➤ Border only on LEFT & RIGHT
//         border: Border(
//           left: BorderSide(color: Color(0xFFF7C85A), width: 3),
//           right: BorderSide(color: Color(0xFFF7C85A), width: 3),
//         ),

//         // ➤ Rounded corners only LEFT + RIGHT
//         borderRadius: BorderRadius.horizontal(
//           left: Radius.circular(12),
//           right: Radius.circular(12),
//         ),
//       ),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//       ),
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
//         // TAB BUTTONS
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             color: Colors.amber.shade200,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: TabBar(
//             controller: controller,
//             labelColor: Colors.black,
//             tabs: const [
//               Tab(text: "Details"),
//               Tab(text: "Description"),
//               Tab(text: "Additional Information"),
//             ],
//           ),
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
