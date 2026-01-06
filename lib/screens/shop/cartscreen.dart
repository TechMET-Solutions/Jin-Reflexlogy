import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/shop/payment_options_screen.dart';

class CartScreen extends StatefulWidget {
  final String deliveryType; // india / outside

   CartScreen({super.key, required this.deliveryType});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
   final _formKey = GlobalKey<FormState>();
  List<CartItem> cartItems = [];
  bool isLoading = true;

  int userId = 0;

  double subtotal = 0;
  double discount = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    loadUserAndFetchCart();
  }

  Future<void> loadUserAndFetchCart() async {
    final prefs = AppPreference();
    userId =
        int.tryParse(prefs.getString(PreferencesKey.userId) ?? "0") ?? 0;

    fetchCartItems();
  }

  // ================= API CALL =================
  Future<void> fetchCartItems() async {
    final prefs = AppPreference();
    final token = prefs.getString(PreferencesKey.token);

    final String country =
        widget.deliveryType == "india" ? "in" : "us";

    final String url =
        "https://admin.jinreflexology.in/api/cart?user_id=$userId&country=$country";

    debugPrint("➡️ CART URL: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode != 200) {
        throw "HTTP ${response.statusCode}";
      }

      final decoded = jsonDecode(response.body);

      if (decoded["success"] == true) {
        final List list = decoded["data"] ?? [];
        final totals = decoded["totals"] ?? {};

        setState(() {
          cartItems = list.map<CartItem>((e) => CartItem.fromJson(e)).toList();
          subtotal = double.tryParse(totals["subtotal"] ?? "0") ?? 0;
          discount = double.tryParse(totals["discount"] ?? "0") ?? 0;
          total = double.tryParse(totals["total"] ?? "0") ?? 0;
          isLoading = false;
        });
      } else {
        throw decoded["message"];
      }
    } catch (e) {
      debugPrint("❌ CART ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty"))
              : Column(
                  children: [
                    // CART LIST
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // IMAGE
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.network(
                                      item.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.shopping_bag),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // INFO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "₹${item.price}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                              255,
                                              19,
                                              4,
                                              66,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text("Qty: ${item.quantity}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // PRICE SUMMARY
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _priceRow("Subtotal", "₹$subtotal"),
                          _priceRow("Discount", "- ₹$discount"),
                          const Divider(),
                          _priceRow("Total", "₹$total", bold: true),
                          const SizedBox(height: 12),
                          
                        ],
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // LEFT BUTTON
            Expanded(
              flex: 6,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentOptionsScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.payment, size: 20, color: Colors.black54),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Cash on Delivery",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // RIGHT BUTTON
            Expanded(
              flex: 7,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text("Confirm Order"),
                                      content: const Text(
                                        "Are you sure you want to place this order?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            
                                          },
                                          child: const Text("Confirm"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    
    );
  }

  Widget _priceRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          Text(value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : null,
                color: bold
                    ? const Color.fromARGB(255, 19, 4, 66)
                    : Colors.black,
              )),
        ],
      ),
    );
  }
}

// ================= MODEL =================
class CartItem {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json["product"];

    return CartItem(
      id: json["id"],
      name: product["title"] ?? "",
      price: int.tryParse(product["price"].toString()) ?? 0,
      quantity: json["quantity"] ?? 1,
      image:
          product["images"] != null && product["images"].isNotEmpty
              ? product["images"][0]
              : "",
    );
  }
}
