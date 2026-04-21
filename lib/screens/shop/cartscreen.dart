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
  final Set<int> _updatingCartIds = <int>{};
  int _fetchSeq = 0;

  int userId = 0;
  double subtotal = 0;
  double shippingCharges = 0;
  double discount = 0;
  double total = 0;

  bool _isItemUpdating(int cartId) => _updatingCartIds.contains(cartId);

  @override
  void initState() {
    super.initState();
    loadUserAndFetchCart();
  }

  Future<void> loadUserAndFetchCart() async {
    final prefs = AppPreference();
    userId = int.tryParse(prefs.getString(PreferencesKey.userId)) ?? 0;
    await fetchCartItems(showLoader: true);
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
  Future<void> fetchCartItems({bool showLoader = false}) async {
    final int seq = ++_fetchSeq;
    if (showLoader && mounted) {
      setState(() => isLoading = true);
    }
    final prefs = AppPreference();
    final token = prefs.getString(PreferencesKey.token);
    final type = prefs.getString(PreferencesKey.type);

    final String country = widget.deliveryType == "india" ? "in" : "us";
    final String url =
        "https://admin.jinreflexology.in/api/cart?user_id=$userId&country=$country&type=$type";

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

      dynamic decoded;
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = null;
      }

      if (!mounted || seq != _fetchSeq) return;

      if (response.statusCode == 200 &&
          decoded is Map &&
          decoded["success"] == true) {
        final List list =
            (decoded["data"] is List) ? (decoded["data"] as List) : <dynamic>[];
        final totals =
            (decoded["totals"] is Map)
                ? (decoded["totals"] as Map)
                : <dynamic, dynamic>{};

        setState(() {
          cartItems = list.map<CartItem>((e) => CartItem.fromJson(e)).toList();
          subtotal =
              double.tryParse(totals["subtotal"]?.toString() ?? "0") ?? 0;
          shippingCharges =
              double.tryParse(totals["shipping_charges"]?.toString() ?? "0") ??
              0;
          discount =
              double.tryParse(totals["discount"]?.toString() ?? "0") ?? 0;
          total = double.tryParse(totals["total"]?.toString() ?? "0") ?? 0;
          isLoading = false;
        });
      } else {
        String errorMessage = "Something went wrong";
        if (decoded is Map && decoded["message"] != null) {
          errorMessage = decoded["message"].toString();
        } else if (response.body.trim().isNotEmpty) {
          errorMessage = response.body.trim();
        }

        _showError(errorMessage);
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ CART ERROR: $e");

      // network / parsing error dynamic
      _showError(e.toString());

      if (mounted) setState(() => isLoading = false);
    }
  }

  void _recomputeTotalsFromItems() {
    final newSubtotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    setState(() {
      subtotal = newSubtotal;
      total = (subtotal + shippingCharges) - discount;
      if (total < 0) total = 0;
    });
  }

  Future<void> updateQuantity(int cartId, int newQuantity) async {
    // Optimistic update so +/- UI responds immediately.
    final int itemIndex = cartItems.indexWhere((item) => item.id == cartId);
    int? oldQuantity;
    CartItem? removedItem;
    final int originalIndex = itemIndex;
    if (itemIndex != -1) {
      oldQuantity = cartItems[itemIndex].quantity;
      setState(() {
        if (newQuantity == 0) {
          removedItem = cartItems[itemIndex];
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex] = cartItems[itemIndex].copyWith(
            quantity: newQuantity,
          );
        }
      });
      _recomputeTotalsFromItems();
    }

    setState(() {
      _updatingCartIds.add(cartId);
    });

    final prefs = AppPreference();
    final type = prefs.getString(PreferencesKey.type);
    final token = prefs.getString(PreferencesKey.token);

    final String url =
        "https://admin.jinreflexology.in/api/cart/update-quantity";

    final String country = widget.deliveryType == "india" ? "in" : "us";
    print(country);
    final Map<String, dynamic> body = {
      "cart_id": cartId,
      "quantity": newQuantity,
      "country": country,
      "type": type,
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
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          // API response message
          String message = decoded["message"] ?? "Success";

          // quantity 0 असेल तर cart मधून remove
          if (newQuantity == 0) {
            setState(() {
              cartItems.removeWhere((item) => item.id == cartId);
            });
          }

          _showSuccess(message);

          // cart refresh
          await fetchCartItems();
        } else {
          _showError(decoded["message"] ?? "Failed to update quantity");
          if (oldQuantity != null && mounted) {
            setState(() {
              if (removedItem != null) {
                final insertAt =
                    originalIndex < 0
                        ? 0
                        : (originalIndex > cartItems.length
                            ? cartItems.length
                            : originalIndex);
                cartItems.insert(insertAt, removedItem!);
              }
              final idx = cartItems.indexWhere((item) => item.id == cartId);
              if (idx != -1) {
                cartItems[idx] = cartItems[idx].copyWith(
                  quantity: oldQuantity!,
                );
              }
            });
            _recomputeTotalsFromItems();
          }
          await fetchCartItems();
        }
      } else {
        _showError("Server error: ${response.statusCode}");
        if (oldQuantity != null && mounted) {
          setState(() {
            if (removedItem != null) {
              final insertAt =
                  originalIndex < 0
                      ? 0
                      : (originalIndex > cartItems.length
                          ? cartItems.length
                          : originalIndex);
              cartItems.insert(insertAt, removedItem!);
            }
            final idx = cartItems.indexWhere((item) => item.id == cartId);
            if (idx != -1) {
              cartItems[idx] = cartItems[idx].copyWith(quantity: oldQuantity!);
            }
          });
          _recomputeTotalsFromItems();
        }
        await fetchCartItems();
      }
    } catch (e) {
      debugPrint("❌ UPDATE QUANTITY ERROR: $e");
      _showError("Network error");
      if (oldQuantity != null && mounted) {
        setState(() {
          if (removedItem != null) {
            final insertAt =
                originalIndex < 0
                    ? 0
                    : (originalIndex > cartItems.length
                        ? cartItems.length
                        : originalIndex);
            cartItems.insert(insertAt, removedItem!);
          }
          final idx = cartItems.indexWhere((item) => item.id == cartId);
          if (idx != -1) {
            cartItems[idx] = cartItems[idx].copyWith(quantity: oldQuantity!);
          }
        });
        _recomputeTotalsFromItems();
      }
      await fetchCartItems();
    } finally {
      setState(() {
        _updatingCartIds.remove(cartId);
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
                      onRefresh: () => fetchCartItems(showLoader: false),
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
                          "Shipping Charges",
                          "${widget.deliveryType == "india" ? "₹ " : "\$"}${shippingCharges.toStringAsFixed(2)}",
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
                            _isItemUpdating(item.id)
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
                            _isItemUpdating(item.id)
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
                                        shippingCharges: shippingCharges,
                                        discount: discount,
                                        total: total,
                                        deliveryType: widget.deliveryType,
                                      ),
                                ),
                              ).then((_) {
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
    final bool isDiscountRow = title.toLowerCase() == "discount";
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
              color:
                  isDiscountRow
                      ? Colors.green
                      : (bold
                          ? const Color.fromARGB(255, 19, 4, 66)
                          : Colors.black),
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
