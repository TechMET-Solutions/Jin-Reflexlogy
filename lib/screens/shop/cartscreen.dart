import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/main.dart';
import 'package:jin_reflex_new/screens/shop/buy_now_form.dart';
import 'package:jin_reflex_new/screens/shop/cart_items_model.dart';
import 'package:jin_reflex_new/screens/shop/payment_options_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class CartScreen extends StatefulWidget {
  final String deliveryType; // india / outside

  CartScreen({super.key, required this.deliveryType});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  List<CartItem> cartItems = [];
  bool isLoading = true;
  bool isUpdating = false; // For individual item updates

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
    userId = int.tryParse(prefs.getString(PreferencesKey.userId) ?? "0") ?? 0;
    fetchCartItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchCartItems();
  }

  // ================= FETCH CART ITEMS =================
  Future<void> fetchCartItems() async {
    final prefs = AppPreference();
    final token = prefs.getString(PreferencesKey.token);

    final String country = widget.deliveryType == "india" ? "in" : "us";
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
      _showError("Failed to load cart items");
      setState(() => isLoading = false);
    }
  }

  // ================= UPDATE QUANTITY API =================
  Future<void> updateQuantity(int cartId, int newQuantity) async {
    setState(() {
      isUpdating = true;
    });

    final String url =
        "https://admin.jinreflexology.in/api/cart/update-quantity";
    final String country = widget.deliveryType == "india" ? "in" : "us";

    final Map<String, dynamic> body = {
      "cart_id": cartId,
      "quantity": newQuantity,
      "country": country,
    };

    debugPrint("➡️ UPDATE QUANTITY REQUEST:");
    debugPrint("URL: $url");
    debugPrint("Body: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          // If new quantity is 0, remove item from cart
          if (newQuantity == 0) {
            // Remove from local list immediately
            setState(() {
              cartItems.removeWhere((item) => item.id == cartId);
            });
            _showSuccess("Item removed from cart");
          } else {
            _showSuccess("Quantity updated successfully");
          }

          // Refresh cart to get updated totals
          await fetchCartItems();
        } else {
          _showError(decoded["message"] ?? "Failed to update quantity");
          // Revert UI changes by refreshing
          fetchCartItems();
        }
      } else {
        _showError("Server error: ${response.statusCode}");
        fetchCartItems(); // Revert UI
      }
    } catch (e) {
      debugPrint("❌ UPDATE QUANTITY ERROR: $e");
      _showError("Network error");
      fetchCartItems(); // Revert UI
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  // ================= HANDLE DECREASE QUANTITY =================
  void _handleDecreaseQuantity(int cartId, int currentQuantity) {
    if (currentQuantity == 1) {
      // If quantity is 1, clicking "-" should remove the item
      // Show confirmation dialog before removing
      _showRemoveConfirmationDialog(cartId);
    } else {
      // If quantity > 1, just decrease by 1
      updateQuantity(cartId, currentQuantity - 1);
    }
  }

  // ================= REMOVE CONFIRMATION DIALOG =================
  void _showRemoveConfirmationDialog(int cartId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Remove Item"),
            content: const Text("Do you want to remove this item from cart?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Set quantity to 0 to remove item
                  updateQuantity(cartId, 0);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Remove"),
              ),
            ],
          ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CommonAppBar(title: "My Cart"),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : cartItems.isEmpty
              ? _emptyCartView()
              : Column(
                children: [
                  // CART LIST
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchCartItems,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return _cartItemCard(item);
                        },
                      ),
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
                        _priceRow(
                          "Subtotal",
                          "${widget.deliveryType == "india" ? "₹" : "\$"}${subtotal.toStringAsFixed(2)}",
                        ),
                        _priceRow(
                          "Discount",
                          "- ${widget.deliveryType == "india" ? "₹" : "\$"}${discount.toStringAsFixed(2)}",
                        ),
                        const Divider(),
                        _priceRow(
                          "Total",
                          "${widget.deliveryType == "india" ? "₹" : "\$"}${total.toStringAsFixed(2)}",
                          bold: true,
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  // ================= CART ITEM CARD =================
  Widget _cartItemCard(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // PRODUCT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.deliveryType == "india" ? "₹" : "\$"}${item.price.toStringAsFixed(2)}",

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 4, 66),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: ${widget.deliveryType == "india" ? "₹" : "\$"}${(item.price * item.quantity).toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // QUANTITY CONTROLS AND DELETE
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QUANTITY CONTROLS
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DECREASE BUTTON
                      IconButton(
                        onPressed:
                            isUpdating
                                ? null
                                : () => _handleDecreaseQuantity(
                                  item.id,
                                  item.quantity,
                                ),
                        icon: const Icon(Icons.remove, size: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        constraints: const BoxConstraints(),
                        color: const Color.fromARGB(255, 19, 4, 66),
                      ),

                      // QUANTITY DISPLAY
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          item.quantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      // INCREASE BUTTON
                      IconButton(
                        onPressed:
                            isUpdating
                                ? null
                                : () =>
                                    updateQuantity(item.id, item.quantity + 1),
                        icon: const Icon(Icons.add, size: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        constraints: const BoxConstraints(),
                        color: const Color.fromARGB(255, 19, 4, 66),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= EMPTY CART VIEW =================
  Widget _emptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add items to get started",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 19, 4, 66),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM NAVIGATION BAR =================
  Widget _bottomNavigationBar() {
    return cartItems.isEmpty
        ? const SizedBox.shrink()
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // PAYMENT OPTIONS BUTTON
              // Expanded(
              //   flex: 6,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) => const PaymentOptionsScreen(),
              //         ),
              //       );
              //     },
              //     child: Container(
              //       height: 48,
              //       padding: const EdgeInsets.symmetric(horizontal: 10),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: Colors.grey.shade400),
              //       ),
              //       child: const Row(
              //         children: [
              //           Icon(Icons.payment, size: 20, color: Colors.black54),
              //           SizedBox(width: 6),
              //           // Expanded(
              //           //   child: Text(
              //           //     "Cash on Delivery",
              //           //     style: TextStyle(
              //           //       fontWeight: FontWeight.w600,
              //           //       fontSize: 14,
              //           //     ),
              //           //   ),
              //           // ),
              //           Icon(Icons.keyboard_arrow_down_rounded),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(width: 10),

              // BUY NOW BUTTON
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BuyNowFormScreen(
                                        cartItems: cartItems,
                                        subtotal: subtotal,
                                        discount: discount,
                                        total: total,
                                      ),
                                ),
                              ).then((_) {
                                // 👇 BACK आल्यावर CART API REFRESH
                                fetchCartItems();
                              });
                            },

                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
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
        );
  }

  // ================= PRICE ROW WIDGET =================
  Widget _priceRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: bold ? const Color.fromARGB(255, 19, 4, 66) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SNACKBAR HELPERS =================
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
