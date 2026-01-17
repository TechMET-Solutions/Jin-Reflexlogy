import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/auth/login_notifier.dart';
import 'package:jin_reflex_new/auth/sign_up_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EbookJinLoginScreen extends ConsumerStatefulWidget {
  const EbookJinLoginScreen({
    super.key,
    required this.onTab,
    required this.text,
    this.deliveryType,
    this.type,
  });

  final VoidCallback onTab;
  final text;
  final type;
  final deliveryType;

  @override
  ConsumerState<EbookJinLoginScreen> createState() =>
      _EbookJinLoginScreenState();
}

class _EbookJinLoginScreenState extends ConsumerState<EbookJinLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isPaymentProcessing = false;
  late Razorpay _razorpay;

  final double _ebookPrice = 500.00; // Fixed price for ebook

  @override
  void initState() {
    super.initState();
    _loadCountry();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Pre-fill user details if available
    _prefillUserDetails();
  }

  bool _isIndias = true;

  Future<void> _loadCountry() async {
    final result = await _isIndianUser();
    if (mounted) {
      setState(() {
        _isIndias = result;
      });
    }
  }

  Future<void> _prefillUserDetails() async {
    final name = AppPreference().getString(PreferencesKey.name);
    final email = AppPreference().getString(PreferencesKey.email);
    final contact = AppPreference().getString(PreferencesKey.contactNumber);

    if (name.isNotEmpty) _nameController.text = name;
    if (email.isNotEmpty) _emailController.text = email;
    if (contact.isNotEmpty) _mobileController.text = contact;
  }

  @override
  void dispose() {
    _razorpay.clear();
    _idController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // 🔹 Payment Gateway Methods
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (mounted) {
      setState(() => _isPaymentProcessing = true);
    }

    // // ✅ Send payment details to backend
    // await _addProUserPayment(
    //   paymentId: response.paymentId,
    //   orderId: response.orderId,
    //   status: "success",
    //   paymentGateway: "razorpay",
    //   amount: _ebookPrice,
    // );

    if (mounted) {
      setState(() => _isPaymentProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    if (mounted) {
      setState(() => _isPaymentProcessing = true);
    }

    //   await _addProUserPayment(
    //   name: _nameController.text.trim(),
    //   email: _emailController.text.trim(),
    //   mobile: _mobileController.text.trim(),
    //   amount: _ebookPrice,
    //   currency: "INR",
    // );

    if (mounted) {
      setState(() => _isPaymentProcessing = false);
    }
  }

  // ✅ Check if user is from India
  Future<bool> _isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType =
        prefs.getString("delivery_type") ?? widget.deliveryType;
    return deliveryType == "india";
  }

  // ✅ Start Razorpay Payment (India)
  void _startRazorpayPayment() {
    final amount = (_ebookPrice * 100).toInt(); // Convert to paise

    var options = {
      'key': razorpayKey,
      'amount': amount.toString(),
      'name': 'JIN Reflexology',
      'description': 'JIN Reflexology Ebook Purchase',
      'prefill': {
        'contact':
            _mobileController.text.trim().isNotEmpty
                ? _mobileController.text.trim()
                : '9999999999',
        'email':
            _emailController.text.trim().isNotEmpty
                ? _emailController.text.trim()
                : 'user@example.com',
        'name':
            _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : 'Customer',
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment gateway error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startPayPalPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: isSandboxMode,
              clientId: paypalClientId,
              secretKey: paypalSecret,

              transactions: [
                {
                  "amount": {"total": "11", "currency": "USD"},
                  "description": "Wallet / Service Payment",
                },
              ],

              note: "Demo PayPal payment",

              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"];
                if (paypalPaymentId == null) return;

                // ✅ API call only
                await _addProUserPayment(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  mobile: _mobileController.text.trim(),
                  amount: 11,
                  currency: "USD",
                );

                if (!mounted) return;

                // ✅ Show success AFTER payment screen closes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PayPal Payment Successful"),
                    backgroundColor: Colors.green,
                  ),
                );

                // ❌ DO NOT Navigator.pop(context)
              },

              onError: (error) {
                debugPrint("❌ PayPal Error: $error");
              },

              onCancel: () {
                debugPrint("⚠️ PayPal Cancelled");
              },
            ),
      ),
    );
  }

  Future<void> _addProUserPayment({
    required String name,
    required String email,
    required String mobile,
    required double amount,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://admin.jinreflexology.in/api/add-prouser-payment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "mobile": mobile,
          "amount": amount.toInt(),
          "currency": currency,
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        debugPrint("✅ Pro user payment added: ${res['message']}");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'] ?? "Payment success"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        }
      } else {
        debugPrint("❌ add-pro-user-payment failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ add-pro-user-payment error: $e");
    }
  }

  // ✅ Show Payment Dialog (for guest users or to collect details)
  Future<void> _showPaymentDialog() async {
    final isIndia = await _isIndianUser();

    return showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Complete Purchase"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Please provide your details to purchase the ebook:",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name *",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email *",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          labelText: "Mobile Number *",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[800],
                              ),
                            ),
                            Text(
                              isIndia
                                  ? "₹$_ebookPrice"
                                  : "\$${(11).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate required fields
                      if (_nameController.text.trim().isEmpty ||
                          _emailController.text.trim().isEmpty ||
                          _mobileController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.pop(context);

                      if (isIndia) {
                        _startRazorpayPayment();
                      } else {
                        _startPayPalPayment(context);
                      }
                    },
                    child: Text(
                      isIndia
                          ? "Pay ₹$_ebookPrice"
                          : "Pay \$${(11).toStringAsFixed(2)}",
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  // ✅ Handle Ebook Purchase
  Future<void> _handleEbookPurchase() async {
    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);

    if (mounted) {
      setState(() => _isPaymentProcessing = true);
    }

    // If user is logged in, check if they already have the ebook
    if (token.isNotEmpty && userId.isNotEmpty) {
      // TODO: Check if user already purchased this ebook
      // For now, proceed to payment
      await _showPaymentDialog();
    } else {
      // Guest user - show payment dialog
      await _showPaymentDialog();
    }

    if (mounted) {
      setState(() => _isPaymentProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndia = _isIndianUser();
    final loginState = ref.watch(loginProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                /// 🔵 Ebook Content Section
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Main Ebook Description
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "This is not an ordinary book, but the world's first living Therapist that will guide you on the path to health forever -",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 19, 4, 66),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            Text(
                              "This book contains 118 QR Codes, which allow you to access an advanced course from the comfort of your home. Through these courses, you will understand the profound secrets of Jin Reflexology in a very simple language.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Text(
                              "This book is not only useful for experts (Doctors, Therapists) but also equally beneficial for the common person.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Included Sections
                      Text(
                        "It includes:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Column(
                        children: [
                          _buildFeatureItem(
                            "1 Nutrition",
                            Icons.restaurant_menu_rounded,
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureItem(
                            "2 Human Anatomy",
                            Icons.medical_services_rounded,
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureItem(
                            "3 Yoga & Mudras",
                            Icons.self_improvement_rounded,
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureItem(
                            "4 Magnet Therapy",
                            Icons.macro_off,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Price & Offer Section with PAY NOW button
                      GestureDetector(
                        onTap: _handleEbookPurchase,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green[200]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "JIN Reflexology Hindi & English Both e-Book With How to treat diseases Video Link",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[900],
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  _isIndias ? "Only ₹500/-" : "\$11.00",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔵 Login Form Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// 🔹 Login Title
                      Text(
                        "Login to Access Your Ebook",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 19, 4, 66),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Enter your credentials to continue",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 ID Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _idController,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: "Enter your ID",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 19, 4, 66),
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 19, 4, 66),
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// 🔹 Remember Me & Forgot Password
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: const Color.fromARGB(
                                  255,
                                  19,
                                  4,
                                  66,
                                ),
                              ),
                              Text(
                                "Remember me",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Add forgot password functionality
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 19, 4, 66),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              loginState.isLoading
                                  ? null
                                  : () async {
                                    final username = _idController.text.trim();
                                    final password =
                                        _passwordController.text.trim();

                                    if (username.isEmpty || password.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please fill all fields',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    await ref
                                        .read(loginProvider.notifier)
                                        .login(
                                          context,
                                          widget.onTab,
                                          widget.text,
                                          widget.type,
                                          _idController.text,
                                          _passwordController.text,
                                          DeliveryType: widget.deliveryType,
                                        );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              19,
                              4,
                              66,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            shadowColor: Colors.black.withOpacity(0.2),
                          ),
                          child: loginState.maybeWhen(
                            loading:
                                () => const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                            orElse:
                                () => const Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Divider with OR
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 19, 4, 66),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Footer Note
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "* Login to access your purchased ebooks or purchase new ones",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // 🔹 Loading Overlay
          if (_isPaymentProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 19, 4, 66).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 19, 4, 66),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
