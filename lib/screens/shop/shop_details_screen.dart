import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/shop/buy_now_form.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int activeImage = 0;

  Product get p => widget.product;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ---------- IMAGE HELPERS ----------

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

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final imgCount = imageCount(p.image);

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- IMAGE SECTION ----------
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
                                : const Center(child: Icon(Icons.image)),
                      ),
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

                // ---------- PRODUCT INFO ----------
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
                          "₹ ${p.price.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BuyNowFormScreen(product: p),
                              ),
                            );
                          },
                          child: const Text(
                            "Buy now",
                            style: TextStyle(color: Colors.white),
                          ),
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------- TABS ----------

  Widget infoBox(String text) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.amber.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: controller,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: "Details"),
              Tab(text: "Description"),
              Tab(text: "Additional Info"),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: TabBarView(
            controller: controller,
            children: [
              infoBox(details),
              infoBox(description),
              infoBox(additionalInfo),
            ],
          ),
        ),
      ],
    );
  }
}
