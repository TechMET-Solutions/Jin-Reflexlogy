import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/shop/ui_model.dart';

class BuyNowFormScreen extends StatefulWidget {
  final Product product;
  final int? initialQuantity; // Added: quantity from product detail

  const BuyNowFormScreen({
    super.key,
    required this.product,
    this.initialQuantity = 1,
  });

  @override
  State<BuyNowFormScreen> createState() => _BuyNowFormScreenState();
}

class _BuyNowFormScreenState extends State<BuyNowFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedCountry;
  int quantity = 1;
  bool isLoading = false;
  bool isAddingToCart = false; // For add to cart functionality

  final List<String> countryList = [
    "India",
    "United States",
    "United Kingdom",
    "Canada",
    "Australia",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    // Set initial quantity if provided
    quantity = widget.initialQuantity ?? 1;
    // Pre-fill with saved user data (optional)
    _loadUserData();
  }

  // Load saved user data from shared preferences
  Future<void> _loadUserData() async {
    // Implement your logic to load saved user data
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // nameController.text = prefs.getString('user_name') ?? '';
    // emailController.text = prefs.getString('user_email') ?? '';
    // phoneController.text = prefs.getString('user_phone') ?? '';
    // addressController.text = prefs.getString('user_address') ?? '';
    // selectedCountry = prefs.getString('user_country');
  }

  // Save user data to shared preferences
  Future<void> _saveUserData() async {
    // Implement your logic to save user data
    // Example:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('user_name', nameController.text.trim());
    // await prefs.setString('user_email', emailController.text.trim());
    // await prefs.setString('user_phone', phoneController.text.trim());
    // await prefs.setString('user_address', addressController.text.trim());
    // if (selectedCountry != null) {
    //   await prefs.setString('user_country', selectedCountry!);
    // }
  }

  // ================= ADD TO CART FUNCTION =================
  Future<void> addToCart() async {
    setState(() => isAddingToCart = true);

    // Example API call - replace with your actual add to cart API
    const String cartUrl = "https://admin.jinreflexology.in/api/cart/add";

    final Map<String, dynamic> body = {
      "product_id": int.parse(widget.product.id),
      "quantity": quantity,
    };

    debugPrint("🛒 ADD TO CART REQUEST => ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(cartUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true) {
          _showCartSuccessPopup();
        } else {
          _showError(decoded["message"] ?? "Failed to add to cart");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ ADD TO CART ERROR => $e");
      _showError("Network error");
    }

    setState(() => isAddingToCart = false);
  }

  // ================= BUY NOW API =================
  Future<void> buyNow() async {
    setState(() => isLoading = true);

    const String url = "https://admin.jinreflexology.in/api/buy-now";

    final Map<String, dynamic> body = {
      "product_id": int.parse(widget.product.id),
      "quantity": quantity,
      "delivery_address": addressController.text.trim(),
      "customer_name": nameController.text.trim(),
      "customer_email": emailController.text.trim(),
      "customer_phone": phoneController.text.trim(),
      "country": selectedCountry ?? "",
    };

    // 🔥 PRINT REQUEST
    debugPrint("========== BUY NOW API CALL ==========");
    debugPrint("URL => $url");
    debugPrint("REQUEST BODY => ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Origin": "https://admin.jinreflexology.in",
        },
        body: body.map((k, v) => MapEntry(k, v.toString())),
      );

      // 🔥 PRINT RAW RESPONSE
      debugPrint("STATUS CODE => ${response.statusCode}");
      debugPrint("RAW RESPONSE => ${response.body}");

      if (response.statusCode != 200) {
        _showError("Server error: ${response.statusCode}");
        return;
      }

      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html>')) {
        _showError(
          "Server returned an unexpected response. Please try again later.",
        );
        return;
      }

      final decoded = json.decode(response.body);

      // 🔥 PRINT DECODED RESPONSE
      debugPrint("DECODED RESPONSE => $decoded");

      if (decoded["success"] == true) {
        debugPrint("✅ ORDER SUCCESS");
        debugPrint("ORDER ID => ${decoded["data"]["order_id"]}");
        debugPrint("AMOUNT => ${decoded["data"]["amount"]}");
        debugPrint("STATUS => ${decoded["data"]["status"]}");

        // Save user data for future use
        await _saveUserData();
        
        _showSuccessPopup();
        _resetForm();
      } else {
        debugPrint("❌ ORDER FAILED");
        debugPrint("MESSAGE => ${decoded["message"]}");
        _showError(decoded["message"] ?? "Something went wrong");
      }
    } catch (e) {
      debugPrint("❌ BUY NOW API ERROR => $e");
      _showError("Network error");
    }

    setState(() => isLoading = false);
  }

  // ================= SUCCESS POPUP =================
  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text("Order Placed Successfully!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${quantity} x ${widget.product.title}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Total: ₹ ${(widget.product.price * quantity).toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text("We'll contact you soon for delivery details."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text("Continue Shopping"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Navigate to Orders Screen (optional)
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (_) => OrdersScreen()),
              // );
            },
            child: const Text("View Orders", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= CART SUCCESS POPUP =================
  void _showCartSuccessPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity x ${widget.product.title} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to Cart Screen
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => CartScreen()),
            // );
          },
        ),
      ),
    );
  }

  // ================= ERROR POPUP =================
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ================= RESET FORM =================
  void _resetForm() {
    debugPrint("🔄 RESETTING FORM");
    addressController.clear();
    _formKey.currentState?.reset();
  }

  // ================= CALCULATE TOTAL =================
  double get totalAmount => widget.product.price * quantity;

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Now"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          // Cart Icon in AppBar
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to Cart Screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => CartScreen()),
                  // );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'View Cart',
              ),
              Positioned(
                right: 8,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3', // Replace with actual cart count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT CARD
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.orange.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.product.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image, size: 40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "₹ ${widget.product.price.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                            
                            // Quantity and Total
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Quantity Controls
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (quantity > 1) {
                                            setState(() => quantity--);
                                          }
                                        },
                                        icon: const Icon(Icons.remove, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() => quantity++);
                                        },
                                        icon: const Icon(Icons.add, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Total
                                Text(
                                  "Total: ₹ ${totalAmount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              // CUSTOMER DETAILS TITLE
              const Text(
                "Customer Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),

              _inputField(
                controller: nameController,
                label: "Full Name",
                hint: "Enter your full name",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: emailController,
                label: "Email Address",
                hint: "example@email.com",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: phoneController,
                label: "Phone Number",
                hint: "10 digit mobile number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              const SizedBox(height: 16),

              // COUNTRY
              const Text(
                "Country",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items: countryList
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCountry = value);
                },
                validator: (val) => val == null ? "Country is required" : null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Select your country",
                ),
              ),

              const SizedBox(height: 16),

              _inputField(
                controller: addressController,
                label: "Delivery Address",
                hint: "House no, Street, City, PIN code",
                icon: Icons.home_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 30),

              // ACTION BUTTONS
              Row(
                children: [
                  // Add to Cart Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isAddingToCart ? null : addToCart,
                      icon: isAddingToCart
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_shopping_cart, size: 20),
                      label: Text(isAddingToCart ? "Adding..." : "Add to Cart"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.orange.shade400),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Buy Now Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                buyNow();
                              }
                            },
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.shopping_bag_outlined, size: 20),
                      label: Text(
                        isLoading ? "Processing..." : "Buy Now",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // COMMON INPUT FIELD WIDGET
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return "$label is required";
            }
            if (label.contains("Email") && !v.contains("@")) {
              return "Enter a valid email";
            }
            if (label.contains("Phone") && v.length != 10) {
              return "Enter 10 digit phone number";
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:  EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
        ),
      ],
    );
  }
}