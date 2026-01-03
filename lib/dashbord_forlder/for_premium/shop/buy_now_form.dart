import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/dashbord_forlder/for_premium/shop/ui_model.dart';

class BuyNowFormScreen extends StatefulWidget {
  final Product product;

  const BuyNowFormScreen({super.key, required this.product});

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

  final List<String> countryList = [
    "India",
    "United States",
    "United Kingdom",
    "Canada",
    "Australia",
    "Other",
  ];

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
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Order Placed 🎉"),
            content: const Text("Your order has been placed successfully."),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  // ================= ERROR POPUP =================
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= RESET FORM =================
  void _resetForm() {
    debugPrint("🔄 RESETTING FORM");
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    selectedCountry = null;
    quantity = 1;
    _formKey.currentState?.reset();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Now"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PRODUCT CARD
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₹ ${widget.product.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // QUANTITY
              const Text(
                "Quantity",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    onPressed: () {
                      setState(() => quantity++);
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _inputField(
                controller: nameController,
                label: "Customer Name",
                hint: "Full name",
              ),
              const SizedBox(height: 12),

              _inputField(
                controller: emailController,
                label: "Email",
                hint: "example@email.com",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              _inputField(
                controller: phoneController,
                label: "Phone Number",
                hint: "10 digit mobile number",
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              const SizedBox(height: 12),

              // COUNTRY
              const Text(
                "Country",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                items:
                    countryList
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged: (value) {
                  setState(() => selectedCountry = value);
                },
                validator: (val) => val == null ? "Country is required" : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              _inputField(
                controller: addressController,
                label: "Delivery Address",
                hint: "House no, Street, City, PIN",
                maxLines: 3,
              ),

              const SizedBox(height: 25),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              buyNow();
                            }
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Proceed to Buy",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // COMMON INPUT
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
