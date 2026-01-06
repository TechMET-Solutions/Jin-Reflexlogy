import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/screens/shop/payment_options_screen.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';


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

  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  String? selectedCountry;
  int quantity = 1;
  bool isLoading = false;

  String selectedPaymentMethod = "CRED UPI";
  bool isDropdownOpen = false;

  final List<String> countryList = [
    "India",
    "United States",
    "United Kingdom",
    "Canada",
    "Australia",
    "Other",
  ];

  // ================= TOTAL PRICE =================
  double get totalPrice =>
      (widget.product.unitPrice * quantity) + widget.product.shippingPrice;

  // ================= BUY NOW API =================
  Future<void> buyNow() async {
    setState(() => isLoading = true);

    const String url = "https://admin.jinreflexology.in/api/buy-now";

    final Map<String, dynamic> body = {
      "product_id": int.parse(widget.product.id),
      "quantity": quantity,
      "customer_name": nameController.text.trim(),
      "customer_email": emailController.text.trim(),
      "customer_phone": phoneController.text.trim(),

      // 🔥 UPDATED ADDRESS FIELDS
      "country": selectedCountry,
      "state": stateController.text.trim(),
      "city": cityController.text.trim(),
      "pincode": pincodeController.text.trim(),
      "address": addressLineController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body.map((k, v) => MapEntry(k, v.toString())),
      );

      if (response.statusCode != 200) {
        _showError("Server error");
        return;
      }

      final decoded = json.decode(response.body);

      if (decoded["success"] == true) {
        _showSuccessPopup();
        _resetForm();
      } else {
        _showError(decoded["message"] ?? "Something went wrong");
      }
    } catch (e) {
      _showError("Network error");
    }

    setState(() => isLoading = false);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Now"),
        backgroundColor: Color.fromARGB(255, 19, 4, 66),
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
              _productCard(),

              const SizedBox(height: 16),

              // QUANTITY
              _quantitySelector(),

              const SizedBox(height: 12),

              // TOTAL PRICE
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // UNIT PRICE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Unit Price",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "₹ ${widget.product.unitPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // SHIPPING CHARGES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Shipping Charges",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "₹ ${widget.product.shippingPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Divider(),

                    const SizedBox(height: 6),

                    // TOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "₹ ${totalPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _inputField(nameController, "Customer Name", "Full name"),
              _inputField(
                emailController,
                "Email",
                "example@email.com",
                keyboardType: TextInputType.emailAddress,
              ),
              _inputField(
                phoneController,
                "Phone",
                "10 digit mobile number",
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),

              const SizedBox(height: 12),

              // COUNTRY
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: _border(),
                hint: const Text("Select Country"),
                items:
                    countryList
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                validator: (v) => v == null ? "Country required" : null,
              ),

              const SizedBox(height: 12),

              _inputField(stateController, "State", "State"),
              _inputField(cityController, "City", "City"),
              _inputField(
                pincodeController,
                "Pincode",
                "Postal code",
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              _inputField(
                addressLineController,
                "Address",
                "House no, Street, Area",
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 40),
            ],
          ),
        ),
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
                                            buyNow();
                                          },
                                          child: const Text("Confirm"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                  child: const Text(
                    "Place Order",
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

  Widget _dropdownOptionCompact(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
          isDropdownOpen = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ================= WIDGETS =================
  Widget _productCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 19, 4, 66)),
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
                Text("₹ ${widget.product.unitPrice.toStringAsFixed(0)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantitySelector() {
    return Row(
      children: [
        const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          onPressed: () {
            if (quantity > 1) setState(() => quantity--);
          },
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(quantity.toString()),
        IconButton(
          onPressed: () => setState(() => quantity++),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  InputDecoration _border() => InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );

  Widget _inputField(
    TextEditingController controller,
    String label,
    String hint, {
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
          decoration: _border().copyWith(hintText: hint),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 19, 4, 66),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _resetForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressLineController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    selectedCountry = null;
    quantity = 1;
  }

  Widget _dropdownOption(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = option;
          isDropdownOpen = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          option,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}