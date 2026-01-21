import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/shop/cart_items_model.dart';
import 'package:jin_reflex_new/screens/shop/payment_options_screen.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===============================================================
/// BUY NOW FORM SCREEN - WITH COUPON FUNCTIONALITY
/// ===============================================================
class BuyNowFormScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;
  final double discount;
  final double total;
  final delveryType;

  const BuyNowFormScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.delveryType,
  });

  @override
  State<BuyNowFormScreen> createState() => _BuyNowFormScreenState();
}

class _BuyNowFormScreenState extends State<BuyNowFormScreen> {
  final _formKey = GlobalKey<FormState>();

  /// ================= CONTROLLERS =================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  /// ================= STATE =================
  csc.Country? selectedCountry;
  csc.State? selectedState;
  csc.City? selectedCity;
  bool isLoading = false;
  bool isApplyingCoupon = false;
  Map<int, int>? productIdMap;

  // Coupon related state
  String? appliedCouponCode;
  double currentSubtotal = 0;
  double currentDiscount = 0;
  double currentTotal = 0;
  late Razorpay _razorpay;
  // TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize totals from cart
    currentSubtotal = widget.subtotal;
    currentDiscount = widget.discount;
    currentTotal = widget.total;
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchProductIdMapping();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Success\nPayment ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );

    await sendPaymentToBackend(
      status: "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
      amount: currentSubtotal.toInt(),
    );
    placeOrder();
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );

    await sendPaymentToBackend(
      status: "failed",
      reason: response.message,
      amount: currentSubtotal.toInt(),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  }

  Future<bool> isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type");
    return deliveryType == "india";
  }

  /// ===============================================================
  /// Fetch product ID mapping from cart API
  /// ===============================================================
  Future<void> _fetchProductIdMapping() async {
    try {
      const userId = 2; // Replace with actual user ID from auth

      final response = await http.get(
        Uri.parse(
          "https://admin.jinreflexology.in/api/cart?user_id=$userId&country=in",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          final cartData = decoded["data"] as List;
          final mapping = <int, int>{};

          for (var item in cartData) {
            final cartItemId = item["id"] as int;
            final productId = item["product_id"] as int;
            mapping[cartItemId] = productId;
          }

          setState(() {
            productIdMap = mapping;
          });
        }
      }
    } catch (e) {
      print("❌ Error fetching product mapping: $e");
    }
  }

  Future<void> startPayment(BuildContext context) async {
    final isIndia = await isIndianUser();

    final int rupees = currentTotal.toInt();
    // amountController.text = rupees.toString();

    if (isIndia) {
      /// 🇮🇳 RAZORPAY
      var options = {
        'key': razorpayKey,
        'amount': currentSubtotal * 100, // paisa
        'name': AppPreference().getString(PreferencesKey.name),
        'description': 'Order Payment',
        'prefill': {
          'contact': AppPreference().getString(PreferencesKey.contactNumber),
          'email': AppPreference().getString(PreferencesKey.email),
        },
      };

      _razorpay.open(options);
    } else {
      /// 🌍 PAYPAL
      final usdAmount = (rupees / 83).toStringAsFixed(2);
      // amountController.text = usdAmount;

      _startPayPalPayment(context);
    }
  }

  void _startPayPalPayment(BuildContext context) {
    // String amount = amountController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: isSandboxMode,

              clientId: paypalClientId,
              secretKey: paypalSecret,

              /// ✅ ONLY AMOUNT – NO PRODUCT
              transactions: [
                {
                  "amount": {"total": currentSubtotal, "currency": "USD"},
                  "description": "Wallet / Service Payment",
                },
              ],

              note: "Demo PayPal payment",

              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"];

                debugPrint("PayPal Payment ID: $paypalPaymentId");

                // 🔒 Safety check
                if (paypalPaymentId == null) {
                  debugPrint("❌ PayPal paymentId null");
                  return;
                }

                await sendPaymentToBackend(
                  status: "success",
                  paymentId: paypalPaymentId,
                  orderId: null,
                  amount: currentSubtotal.toInt(),
                );
                placeOrder();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PayPal Payment Successful"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // close popup

                Navigator.pop(context); // close PayPal screen
              },

              onError: (error) async {
                await sendPaymentToBackend(
                  status: "failed",
                  reason: error.toString(),
                  amount: currentSubtotal.toInt(),
                );
                debugPrint("❌ PayPal Error: $error");

                Navigator.pop(context);
              },

              onCancel: () async {
                //      await sendPaymentToBackend(
                //   status: "failed",
                //   reason: "Payment cancelled",
                //   amount: int.parse(amountController.text),
                // );
                debugPrint("⚠️ PayPal Cancelled");
                Navigator.pop(context);
              },
            ),
      ),
    );
  }

  Future<void> sendPaymentToBackend({
    required String status,
    String? paymentId,
    String? orderId,
    String? reason,
    required int amount,
  }) async {
    try {
      final dio = Dio();
      var postData = {
        "user_id": AppPreference().getString(PreferencesKey.userId),
        "payment_id": paymentId,
        "orderid": orderId,
        "amount": currentSubtotal,
        "status": status,
        "email": AppPreference().getString(PreferencesKey.email),
        "name": AppPreference().getString(PreferencesKey.name),
        "contact": AppPreference().getString(PreferencesKey.contactNumber),
      };
      log("${postData}");
      final response = await dio.post(
        "https://admin.jinreflexology.in/api/payment_callback",
        data: {
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "payment_id": paymentId,
          "orderid": orderId,
          "amount": currentSubtotal,
          "status": status,
          "email": AppPreference().getString(PreferencesKey.email),
          "name": AppPreference().getString(PreferencesKey.name),
          "contact": AppPreference().getString(PreferencesKey.contactNumber),
        },
      );

      debugPrint("✅ Payment sent to backend: ${response.data}");
    } catch (e) {
      debugPrint("❌ Backend API error: $e");
    }
  }

  /// ===============================================================
  /// APPLY COUPON API
  /// ===============================================================
  Future<void> applyCoupon() async {
    if (couponController.text.trim().isEmpty) {
      _showError("Please enter coupon code");
      return;
    }

    if (appliedCouponCode != null) {
      _showError("A coupon is already applied. Remove it first.");
      return;
    }

    setState(() => isApplyingCoupon = true);

    const String url = "https://admin.jinreflexology.in/api/cart/apply-coupon";
    const userId = 2; // Get from auth state
    final country = selectedCountry?.name == "India" ? "in" : "us";

    final Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "country": country,
      "coupon_code": couponController.text.trim(),
    };

    print("=== APPLY COUPON REQUEST ===");
    print("URL: $url");
    print("Body: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          final totals = decoded["totals"] ?? {};

          setState(() {
            appliedCouponCode = couponController.text.trim();
            currentSubtotal = double.tryParse(totals["subtotal"] ?? "0") ?? 0;
            currentDiscount = double.tryParse(totals["discount"] ?? "0") ?? 0;
            currentTotal = double.tryParse(totals["total"] ?? "0") ?? 0;
          });

          _showSuccess("Coupon applied successfully!");
        } else {
          _showError(decoded["message"] ?? "Failed to apply coupon");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
      _showError("Network error: Please check your internet connection");
    } finally {
      setState(() => isApplyingCoupon = false);
    }
  }

  bool _canGoBack = true;

  /// ===============================================================
  /// REMOVE COUPON API
  /// ===============================================================
  Future<void> removeCoupon() async {
    if (appliedCouponCode == null) {
      return;
    }

    setState(() => isApplyingCoupon = true);

    const String url = "https://admin.jinreflexology.in/api/cart/remove-coupon";
    const userId = 2; // Get from auth state
    final country = selectedCountry?.name == "India" ? "in" : "us";
    setState(() {
      isLoading = true;
      _canGoBack = false; // 🚫 BACK DISABLE
    });
    final Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "country": country,
    };

    print("=== REMOVE COUPON REQUEST ===");
    print("URL: $url");
    print("Body: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          final totals = decoded["totals"] ?? {};

          setState(() {
            appliedCouponCode = null;
            couponController.clear();
            currentSubtotal = double.tryParse(totals["subtotal"] ?? "0") ?? 0;
            currentDiscount = double.tryParse(totals["discount"] ?? "0") ?? 0;
            currentTotal = double.tryParse(totals["total"] ?? "0") ?? 0;
          });
          setState(() {
            _canGoBack = true; // ✅ BACK ENABLE AFTER SUCCESS
          });

          _showSuccess("Coupon removed successfully!");
        } else {
          _canGoBack = true;
          _showError(decoded["message"] ?? "Failed to remove coupon");
        }
      } else {
        _canGoBack = true;
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
      _showError("Network error: Please check your internet connection");
      _canGoBack = true;
    } finally {
      setState(() => isApplyingCoupon = false);
    }
  }

  /// ===============================================================
  /// PLACE ORDER API
  /// ===============================================================
  Future<void> placeOrder() async {
    if (productIdMap == null) {
      _showError("Loading product information. Please try again.");
      return;
    }

    setState(() => isLoading = true);

    const String url = "http://admin.jinreflexology.in/api/place-order";

    // Prepare items array from cart items
    List<Map<String, dynamic>> items = [];
    for (var cartItem in widget.cartItems) {
      final actualProductId = productIdMap![cartItem.id];
      if (actualProductId != null) {
        items.add({
          "product_id": actualProductId,
          "quantity": cartItem.quantity,
        });
      }
    }

    // If no valid items found
    if (items.isEmpty) {
      _showError("No valid items in cart. Please refresh cart.");

      setState(() => isLoading = false);
      return;
    }

    // Prepare request body according to API
    final Map<String, dynamic> body = {
      "user_id": 2, // Get from auth state
      "address": addressController.text.trim(),
      "city": selectedCity?.name ?? "",
      "state": selectedState?.name ?? "",
      "country": selectedCountry?.name ?? "India",
      "pincode": pincodeController.text.trim(),
      "customer_name": nameController.text.trim(),
      "customer_email": emailController.text.trim(),
      "customer_phone": phoneController.text.trim(),
      "items": items,
      "subtotal": currentSubtotal,
      "discount": currentDiscount,
      "total": currentTotal,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded["success"] == true) {
            _showSuccessPopup(decoded);
            removeCoupon();
          } else {
            _showError(decoded["message"] ?? "Something went wrong");
          }
        } catch (e) {
          _showError("Invalid response from server");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Network error: Please check your internet connection");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ===============================================================
  /// UI
  /// ===============================================================

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_canGoBack) {
          _showError("Please wait, placing your order...");
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: CommonAppBar(title: "Place Order"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cartItemsSection(),
                const SizedBox(height: 16),
                _priceSummarySection(),
                const SizedBox(height: 20),
                _customerDetailsSection(),
                const SizedBox(height: 20),
                _couponSection(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _bottomBar(),
      ),
    );
  }

  /// ===============================================================
  /// CART ITEMS LIST
  /// ===============================================================
  Widget _cartItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Items",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...widget.cartItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color.fromARGB(255, 19, 4, 66)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.delveryType == "india" ? "₹" : "\$"} ${item.price} × ${item.quantity} = ${widget.delveryType == "india" ? "₹" : "\$"} ${item.price * item.quantity}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  /// ===============================================================
  /// PRICE SUMMARY
  /// ===============================================================
  Widget _priceSummarySection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _priceRow("Subtotal", "${widget.delveryType == "india" ? "₹" : "\$"} ${currentSubtotal.toStringAsFixed(2)}"),
          _priceRow("Discount", "- ${widget.delveryType == "india" ? "₹" : "\$"} ${currentDiscount.toStringAsFixed(2)}"),
          const Divider(),
          _priceRow(
            "Total Amount",
            "${widget.delveryType == "india" ? "₹" : "\$"} ${currentTotal.toStringAsFixed(2)}",
            bold: true,
            color: const Color.fromARGB(255, 19, 4, 66),
          ),
        ],
      ),
    );
  }

  /// ===============================================================
  /// CUSTOMER DETAILS FORM
  /// ===============================================================
  Widget _customerDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Delivery Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _input(
          nameController,
          "Customer Name",
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Customer name is required';
            }
            return null;
          },
        ),

        _input(
          emailController,
          "Email",
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email is required';
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),

        _input(
          phoneController,
          "Phone",
          keyboardType: TextInputType.phone,
          maxLength: 10,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            if (value.length != 10) {
              return 'Phone number must be 10 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// ===============================================================
  /// COUPON SECTION (Phone ke niche)
  /// ===============================================================
  Widget _couponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Apply Coupon",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Applied coupon display (if any)
        if (appliedCouponCode != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.discount, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coupon Applied: $appliedCouponCode",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "You saved ${widget.delveryType == "india" ? "₹" : "\$"}${currentDiscount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: isApplyingCoupon ? null : removeCoupon,
                  icon: const Icon(Icons.close, color: Colors.red),
                  tooltip: "Remove coupon",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Coupon input field
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: couponController,
                decoration: InputDecoration(
                  hintText: "Enter coupon code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 19, 4, 66),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                enabled: appliedCouponCode == null && !isApplyingCoupon,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      appliedCouponCode == null
                          ? const Color.fromARGB(255, 19, 4, 66)
                          : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    (appliedCouponCode == null && !isApplyingCoupon)
                        ? applyCoupon
                        : null,
                child:
                    isApplyingCoupon
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          appliedCouponCode == null ? "Apply" : "Applied",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Country, State, City, Pincode, Address fields
        DropdownSearch<csc.Country>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search country...",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          asyncItems: (String filter) => csc.getAllCountries(),
          itemAsString: (csc.Country c) => c.name,
          onChanged: (csc.Country? c) {
            setState(() {
              selectedCountry = c;
              selectedState = null;
              selectedCity = null;
            });
          },
          selectedItem: selectedCountry,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Country",
              hintText: "Select Country",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          validator:
              (csc.Country? c) => c == null ? "Country is required" : null,
        ),
        const SizedBox(height: 12),

        DropdownSearch<csc.State>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search state...",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          asyncItems:
              (String filter) =>
                  selectedCountry != null
                      ? csc.getStatesOfCountry(selectedCountry!.isoCode)
                      : Future.value([]),
          itemAsString: (csc.State s) => s.name,
          onChanged: (csc.State? s) {
            setState(() {
              selectedState = s;
              selectedCity = null;
            });
          },
          selectedItem: selectedState,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "State",
              hintText: "Select State",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          validator: (csc.State? s) => s == null ? "State is required" : null,
        ),
        const SizedBox(height: 12),

        DropdownSearch<csc.City>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search city...",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          asyncItems:
              (String filter) =>
                  selectedState != null
                      ? csc.getStateCities(
                        selectedCountry!.isoCode,
                        selectedState!.isoCode,
                      )
                      : Future.value([]),
          itemAsString: (csc.City c) => c.name,
          onChanged: (csc.City? c) {
            setState(() {
              selectedCity = c;
            });
          },
          selectedItem: selectedCity,
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "City",
              hintText: "Select City",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          validator: (csc.City? c) => c == null ? "City is required" : null,
        ),
        const SizedBox(height: 12),

        _input(
          pincodeController,
          "Pincode",
          keyboardType: TextInputType.number,
          maxLength: 6,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Pincode is required';
            }
            if (value.length != 6) {
              return 'Pincode must be 6 digits';
            }
            return null;
          },
        ),

        _input(
          addressController,
          "Address",
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Address is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// ===============================================================
  /// BOTTOM BAR
  /// ===============================================================
  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "Payment Options",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 7,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      productIdMap != null
                          ? const Color.fromARGB(255, 19, 4, 66)
                          : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    (productIdMap != null && !isLoading)
                        ? () {
                          if (_formKey.currentState!.validate()) {
                            startPayment(context);
                            // placeOrder();
                          }
                        }
                        : null,
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
                        : productIdMap != null
                        ? const Text(
                          "Place Order",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  /// ===============================================================
  /// HELPERS
  /// ===============================================================
  Widget _priceRow(
    String title,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
          validator:
              validator ??
              (v) => v == null || v.trim().isEmpty ? "Required" : null,
          decoration: _border(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  InputDecoration _border() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 19, 4, 66),
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  void _showSuccessPopup(Map<String, dynamic> response) {
    final orderId = response["data"]["order_id"] ?? "N/A";
    final orderNumber =
        response["data"]["order_details"]["order_number"] ?? "N/A";
    final totalAmount = response["data"]["order_details"]["total_amount"] ?? 0;
    final status = response["data"]["order_details"]["status"] ?? "N/A";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Order Placed Successfully!"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Your order has been placed successfully."),
                  const SizedBox(height: 16),

                  const Text(
                    "Order Summary:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  _orderDetailRow("Order ID:", orderId),
                  _orderDetailRow("Order Number:", orderNumber),
                  _orderDetailRow(
                    "Total Amount:",
                    "₹ ${totalAmount.toStringAsFixed(2)}",
                  ),
                  _orderDetailRow("Status:", _capitalize(status)),

                  if (appliedCouponCode != null) ...[
                    const SizedBox(height: 8),
                    _orderDetailRow("Coupon Applied:", appliedCouponCode!),
                    _orderDetailRow(
                      "Discount:",
                      "₹ ${currentDiscount.toStringAsFixed(2)}",
                    ),
                  ],

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Thank you for shopping with us!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to cart/previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 19, 4, 66),
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

  Widget _orderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
