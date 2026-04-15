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
import 'dart:developer';
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
  final TextEditingController _purchasePasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPurchasePasswordVisible = false;
  bool _rememberMe = false;
  bool _isPaymentProcessing = false;
  late Razorpay _razorpay;
  String? _ebookUserId;

  static const double _ebookPriceProdInr = 500.00;
  static const double _ebookPriceDemoInr = 1.00;
  double get _ebookPrice =>
      isSandboxMode ? _ebookPriceDemoInr : _ebookPriceProdInr;

  static const double _ebookPriceProdUsd = 11.00;
  static const double _ebookPriceDemoUsd = 1.00;
  double get _ebookPriceUsd =>
      isSandboxMode ? _ebookPriceDemoUsd : _ebookPriceProdUsd;

  static const String _ebookRegisterEndpoint =
      "https://admin.jinreflexology.in/api/ebook-register";
  static const String _ebookPrecheckEndpoint =
      "https://admin.jinreflexology.in/api/ebook-precheck";

  static String _ebookCountryParam({required bool isIndia}) =>
      isIndia ? "in" : "us";

  Future<({String? userId, bool alreadyPaid, String? message})?>
  _precheckEbookPurchase({required bool isIndia}) async {
    try {
      final requestBody = {
        "email": _emailController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "country": _ebookCountryParam(isIndia: isIndia),
        "source": "ebook",
      };

      _logApiBody("EBOOK_PRECHECK", requestBody);

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(_ebookPrecheckEndpoint),
      );
      request.fields.addAll(
        requestBody.map((key, value) => MapEntry(key, value.toString())),
      );

      final streamed = await request.send();
      final responseBody = await streamed.stream.bytesToString();

      _logApiResponse("EBOOK_PRECHECK", streamed.statusCode, responseBody);

      if (streamed.statusCode != 200 && streamed.statusCode != 201) {
        return null;
      }

      final decoded = jsonDecode(responseBody);
      if (decoded is! Map) return null;

      String? userId;
      final direct = decoded["user_id"] ?? decoded["userId"] ?? decoded["id"];
      if (direct != null) userId = direct.toString();

      final data = decoded["data"];
      if ((userId == null || userId.trim().isEmpty) && data is Map) {
        final nested =
            data["user_id"] ?? data["userId"] ?? data["id"] ?? data["uid"];
        if (nested != null) userId = nested.toString();
      }

      bool alreadyPaid = false;
      final paidValue =
          decoded["paid"] ??
          decoded["already_paid"] ??
          decoded["isPaid"] ??
          (data is Map ? (data["paid"] ?? data["already_paid"]) : null);
      if (paidValue is bool) {
        alreadyPaid = paidValue;
      } else if (paidValue != null) {
        final v = paidValue.toString().trim().toLowerCase();
        alreadyPaid = v == "1" || v == "true" || v == "yes" || v == "paid";
      }

      final message = decoded["message"]?.toString();

      return (
        userId: userId?.trim().isEmpty == true ? null : userId?.trim(),
        alreadyPaid: alreadyPaid,
        message: message,
      );
    } catch (e) {
      debugPrint("❌ ebook-precheck error: $e");
      return null;
    }
  }

  Future<({String? userId, bool ok, bool alreadyExists, String? message})?>
  _registerEbookUser({required bool isIndia}) async {
    try {
      final requestBody = {
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "password": _purchasePasswordController.text.trim(),
        "userType": "prouser",
        "country": _ebookCountryParam(isIndia: isIndia),
        "source": "ebook",
      };

      _logApiBody("EBOOK_REGISTER", requestBody);

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(_ebookRegisterEndpoint),
      );
      request.fields.addAll(
        requestBody.map((key, value) => MapEntry(key, value.toString())),
      );

      final streamed = await request.send();
      final responseBody = await streamed.stream.bytesToString();

      _logApiResponse("EBOOK_REGISTER", streamed.statusCode, responseBody);

      final statusOk = streamed.statusCode == 200 || streamed.statusCode == 201;
      if (responseBody.trim().isEmpty) {
        return null;
      }

      dynamic decoded;
      try {
        decoded = jsonDecode(responseBody);
      } catch (_) {
        decoded = null;
      }

      if (decoded is! Map) {
        // Even for non-2xx responses, show the raw body in UI.
        return (
          userId: null,
          ok: statusOk,
          alreadyExists: false,
          message: responseBody.trim(),
        );
      }

      String? message = decoded["message"]?.toString();

      bool ok = statusOk;
      final successValue = decoded["success"] ?? decoded["status"];
      if (successValue is bool) {
        ok = successValue;
      } else if (successValue != null) {
        final v = successValue.toString().trim().toLowerCase();
        ok = v == "1" || v == "true" || v == "yes" || v == "success";
      }
      ok = statusOk && ok;

      String? userId;
      final direct = decoded["user_id"] ?? decoded["userId"] ?? decoded["id"];
      if (direct != null) userId = direct.toString();

      final data = decoded["data"];
      if (data is Map && data["p_number"] != null) {
        final pNumber = data["p_number"].toString();
        if (pNumber.trim().isNotEmpty) {
          final base = (message ?? "").trim();
          message = base.isEmpty ? pNumber : "$base ($pNumber)";
        }
      }
      if ((userId == null || userId.trim().isEmpty) && data is Map) {
        final nested =
            data["user_id"] ?? data["userId"] ?? data["id"] ?? data["uid"];
        if (nested != null) userId = nested.toString();
      }

      final normalizedMessage = (message ?? "").trim().toLowerCase();
      final alreadyExists =
          normalizedMessage.contains("already exists") ||
          normalizedMessage.contains("already registered") ||
          normalizedMessage.contains("exists");

      return (
        userId: userId?.trim().isEmpty == true ? null : userId?.trim(),
        ok: ok,
        alreadyExists: alreadyExists,
        message: message,
      );
    } catch (e) {
      debugPrint("❌ ebook-register error: $e");
      return null;
    }
  }

  String _formatApiValue(String key, Object? value) {
    if (value == null) return "null";
    final normalizedKey = key.trim().toLowerCase();
    if (normalizedKey == "password") {
      final password = value.toString();
      return "<masked len=${password.length}>";
    }
    final str = value.toString();
    if (str.length > 180) {
      return "${str.substring(0, 80)}...<len=${str.length}>";
    }
    return str;
  }

  void _logApiBody(String tag, Map<String, dynamic> body) {
    final buffer = StringBuffer();
    buffer.writeln("API BODY [$tag]");
    body.forEach((key, value) {
      buffer.writeln("  - $key: ${_formatApiValue(key, value)}");
    });
    log(buffer.toString(), name: "API");
  }

  void _logApiResponse(String tag, int statusCode, String body) {
    final trimmed = body.trim();
    final isHtml =
        trimmed.startsWith("<!DOCTYPE html") ||
        trimmed.startsWith("<html") ||
        trimmed.contains("<title>Not Found</title>");
    final safeBody =
        isHtml && trimmed.length > 600
            ? "${trimmed.substring(0, 600)}...<len=${trimmed.length}>"
            : body;

    log("Status: $statusCode\nBody: $safeBody", name: "API RESPONSE [$tag]");
    try {
      final decoded = jsonDecode(body);
      log(
        const JsonEncoder.withIndent("  ").convert(decoded),
        name: "API RESPONSE JSON [$tag]",
      );
    } catch (_) {
      // ignore non-json responses
    }
  }

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
    _purchasePasswordController.dispose();
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

    await _addProUserPayment(
      userId: _ebookUserId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      password: _purchasePasswordController.text.trim(),
      paymentId: response.paymentId,
      orderId: response.orderId,
      signature: response.signature,
      paymentGateway: "razorpay",
      status: "success",
      amount: _ebookPrice,
      currency: "INR",
    );

    if (mounted) {
      setState(() => _isPaymentProcessing = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    if (mounted) {
      setState(() => _isPaymentProcessing = true);
    }

    await _addProUserPayment(
      userId: _ebookUserId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      password: _purchasePasswordController.text.trim(),
      paymentGateway: "razorpay",
      status: "failed",
      reason: response.message,
      amount: _ebookPrice,
      currency: "INR",
    );

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
                  "amount": {
                    "total": _ebookPriceUsd.toStringAsFixed(2),
                    "currency": "USD",
                  },
                  "description": "Wallet / Service Payment",
                },
              ],

              note: "Demo PayPal payment",

              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"];
                if (paypalPaymentId == null) return;

                // ✅ API call only
                if (mounted) {
                  setState(() => _isPaymentProcessing = true);
                }
                String? gatewayResponse;
                try {
                  gatewayResponse = jsonEncode(params);
                } catch (_) {
                  gatewayResponse = params.toString();
                }
                await _addProUserPayment(
                  userId: _ebookUserId,
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  mobile: _mobileController.text.trim(),
                  password: _purchasePasswordController.text.trim(),
                  paymentId: paypalPaymentId.toString(),
                  paymentGateway: "paypal",
                  status: "success",
                  gatewayResponse: gatewayResponse,
                  amount: _ebookPriceUsd,
                  currency: "USD",
                );
                if (mounted) {
                  setState(() => _isPaymentProcessing = false);
                }

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

              onError: (error) async {
                debugPrint("❌ PayPal Error: $error");
                if (mounted) {
                  setState(() => _isPaymentProcessing = true);
                }
                await _addProUserPayment(
                  userId: _ebookUserId,
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  mobile: _mobileController.text.trim(),
                  password: _purchasePasswordController.text.trim(),
                  paymentGateway: "paypal",
                  status: "failed",
                  reason: error.toString(),
                  amount: _ebookPriceUsd,
                  currency: "USD",
                );
                if (mounted) {
                  setState(() => _isPaymentProcessing = false);
                }
              },

              onCancel: () async {
                debugPrint("⚠️ PayPal Cancelled");
                if (mounted) {
                  setState(() => _isPaymentProcessing = true);
                }
                await _addProUserPayment(
                  userId: _ebookUserId,
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  mobile: _mobileController.text.trim(),
                  password: _purchasePasswordController.text.trim(),
                  paymentGateway: "paypal",
                  status: "failed",
                  reason: "Payment cancelled",
                  amount: _ebookPriceUsd,
                  currency: "USD",
                );
                if (mounted) {
                  setState(() => _isPaymentProcessing = false);
                }
              },
            ),
      ),
    );
  }

  Future<void> _addProUserPayment({
    String? userId,
    required String name,
    required String email,
    required String mobile,
    required String password,
    String? paymentId,
    String? orderId,
    String? signature,
    String? paymentGateway,
    String? status,
    String? reason,
    String? gatewayResponse,
    required double amount,
    required String currency,
  }) async {
    try {
      final requestBody = {
        if (userId != null && userId.trim().isNotEmpty)
          "user_id": userId.trim(),
        "name": name,
        "email": email,
        "mobile": mobile,
        if (paymentId != null && paymentId.trim().isNotEmpty)
          "paymentId": paymentId.trim(),
        if (status != null && status.trim().isNotEmpty) "status": status.trim(),
        "amount": amount.toInt(),
        "password": password.trim(),
        "currency": currency,
        "type": "prouser",
      };
      _logApiBody("ADD_PROUSER_PAYMENT", requestBody);

      final safeRequestBody = Map<String, dynamic>.from(requestBody);
      final pwd = safeRequestBody["password"]?.toString() ?? "";
      if (pwd.isNotEmpty) {
        safeRequestBody["password"] = "<masked len=${pwd.length}>";
      }
      debugPrint(
        "[API] ADD_PROUSER_PAYMENT BODY: ${jsonEncode(safeRequestBody)}",
      );

      final response = await http.post(
        Uri.parse("https://admin.jinreflexology.in/api/add-prouser-payment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      _logApiResponse(
        "ADD_PROUSER_PAYMENT",
        response.statusCode,
        response.body,
      );
      log(
        "Headers: ${response.headers}",
        name: "API RESPONSE HEADERS [ADD_PROUSER_PAYMENT]",
      );
      final redirectTo = response.headers["location"];
      if (redirectTo != null && redirectTo.trim().isNotEmpty) {
        log(
          "Redirect location: $redirectTo",
          name: "API RESPONSE REDIRECT [ADD_PROUSER_PAYMENT]",
        );
      }

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

          // No Navigator.pop here; popup is closed before payment starts.
        }
      } else {
        String message = "add-pro-user-payment failed: ${response.statusCode}";
        final redirectTo = response.headers["location"];
        if (redirectTo != null && redirectTo.trim().isNotEmpty) {
          message = "$message (redirect: $redirectTo)";
        }

        final rawBody = response.body.trim();
        if (rawBody.isNotEmpty) {
          final isHtml =
              rawBody.startsWith("<!DOCTYPE html") ||
              rawBody.startsWith("<html") ||
              rawBody.contains("<title>Not Found</title>");
          final preview =
              isHtml && rawBody.length > 800
                  ? "${rawBody.substring(0, 800)}...<len=${rawBody.length}>"
                  : (rawBody.length > 1200
                      ? "${rawBody.substring(0, 1200)}...<len=${rawBody.length}>"
                      : rawBody);
          debugPrint(
            "❌ ADD_PROUSER_PAYMENT failed body (${response.statusCode}): $preview",
          );
        }
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded["message"] != null) {
            message = decoded["message"].toString();
          } else if (decoded is Map && decoded["error"] != null) {
            message = decoded["error"].toString();
          }

          if (decoded is Map) {
            final data = decoded["data"];
            if (data is Map && data["p_number"] != null) {
              final pNumber = data["p_number"].toString();
              if (pNumber.trim().isNotEmpty) {
                message = "$message ($pNumber)";
              }
            }
          }
        } catch (_) {}

        debugPrint("❌ $message");
        if (mounted) {
          final lower = message.toLowerCase();
          final bgColor =
              lower.contains("already exists") ? Colors.orange : Colors.red;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: bgColor),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ add-pro-user-payment error: $e");
    }
  }

  Future<void> _showPaymentDialog() async {
    final isIndia = await _isIndianUser();
    String? dialogMessage;
    Color dialogMessageColor = Colors.red;
    bool dialogIsProcessing = false;

    return showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              void showDialogMessage(String? message, {Color? color}) {
                setState(() {
                  dialogMessage = message;
                  if (color != null) dialogMessageColor = color;
                });
              }

              void setDialogProcessing(bool value) {
                setState(() => dialogIsProcessing = value);
              }

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
                      const SizedBox(height: 10),
                      TextField(
                        controller: _purchasePasswordController,
                        decoration: InputDecoration(
                          labelText: "Password *",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPurchasePasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPurchasePasswordVisible =
                                    !_isPurchasePasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPurchasePasswordVisible,
                      ),
                      if (dialogMessage != null) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dialogMessage!,
                            style: TextStyle(
                              color: dialogMessageColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                                  : "\$${_ebookPriceUsd.toStringAsFixed(2)}",
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
                    onPressed:
                        dialogIsProcessing
                            ? null
                            : () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed:
                        dialogIsProcessing
                            ? null
                            : () {
                              // Validate required fields
                              if (_nameController.text.trim().isEmpty ||
                                  _emailController.text.trim().isEmpty ||
                                  _mobileController.text.trim().isEmpty ||
                                  _purchasePasswordController.text
                                      .trim()
                                      .isEmpty) {
                                showDialogMessage(
                                  "Please fill all required fields",
                                  color: Colors.red,
                                );
                                return;
                              }

                              if (_purchasePasswordController.text
                                      .trim()
                                      .length <
                                  6) {
                                showDialogMessage(
                                  "Password must be at least 6 characters",
                                  color: Colors.red,
                                );
                                return;
                              }

                              showDialogMessage(null);

                              () async {
                                setDialogProcessing(true);

                                final precheck = await _precheckEbookPurchase(
                                  isIndia: isIndia,
                                );
                                if (precheck != null) {
                                  if (precheck.userId != null) {
                                    _ebookUserId = precheck.userId;
                                  }

                                  if (precheck.alreadyPaid) {
                                    showDialogMessage(
                                      precheck.message ??
                                          "Already purchased. Please login.",
                                      color: Colors.green,
                                    );
                                    setDialogProcessing(false);
                                    return;
                                  }
                                }

                                if (_ebookUserId == null) {
                                  final registerResult =
                                      await _registerEbookUser(
                                        isIndia: isIndia,
                                      );
                                  if (registerResult == null) {
                                    showDialogMessage(
                                      "Registration failed. Please try again.",
                                      color: Colors.red,
                                    );
                                    setDialogProcessing(false);
                                    return;
                                  }

                                  if (!registerResult.ok &&
                                      registerResult.alreadyExists == false) {
                                    showDialogMessage(
                                      registerResult.message ??
                                          "Registration failed. Please try again.",
                                      color: Colors.red,
                                    );
                                    setDialogProcessing(false);
                                    return;
                                  }

                                  if (registerResult.userId != null) {
                                    _ebookUserId = registerResult.userId;
                                  }

                                  final afterRegisterPrecheck =
                                      await _precheckEbookPurchase(
                                        isIndia: isIndia,
                                      );
                                  if (afterRegisterPrecheck?.userId != null) {
                                    _ebookUserId =
                                        afterRegisterPrecheck!.userId;
                                  }

                                  if (registerResult.alreadyExists) {
                                    final apiMessage =
                                        (registerResult.message ?? "").trim();
                                    if (apiMessage.isNotEmpty) {
                                      showDialogMessage(
                                        apiMessage,
                                        color: Colors.orange,
                                      );
                                    }

                                    // success=false असल्यावर payment gateway open करायचा नाही.
                                    setDialogProcessing(false);
                                    return;
                                  }
                                }

                                setDialogProcessing(false);

                                if (!context.mounted) return;
                                Navigator.pop(context);

                                if (isIndia) {
                                  _startRazorpayPayment();
                                } else {
                                  _startPayPalPayment(context);
                                }
                              }();
                            },
                    child:
                        dialogIsProcessing
                            ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              isIndia
                                  ? "Pay ₹$_ebookPrice"
                                  : "Pay \$${_ebookPriceUsd.toStringAsFixed(2)}",
                            ),
                  ),
                ],
              );
            },
          ),
    );
  }

  Future<void> _handleEbookPurchase() async {
    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);
    if (userId.isNotEmpty) {
      _ebookUserId = userId;
    }
    if (mounted) {
      setState(() => _isPaymentProcessing = true);
    }
    if (token.isNotEmpty && userId.isNotEmpty) {
      await _showPaymentDialog();
    } else {
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
                                  _isIndias
                                      ? "Only ₹${_ebookPrice.toStringAsFixed(0)}/-"
                                      : "\$11.00",
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
                      const SizedBox(height: 12),
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
                                    print("dsdsdsds");
                                    await ref
                                        .read(loginProvider.notifier)
                                        .login(
                                          context,
                                          widget.onTab,
                                          widget.text,
                                          "prouser",
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
                      InkWell(
                        onTap: () {
                          _handleEbookPurchase();
                        },
                        child: Text(
                          "Register-->",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
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
