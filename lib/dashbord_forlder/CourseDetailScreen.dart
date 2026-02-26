import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  final String deliveryType;

  const CourseDetailScreen({
    super.key,
    required this.course,
    required this.deliveryType,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Razorpay _razorpay;
  bool _isProcessing = false;
  bool _isLoginInProgress = false;

  // Text controllers for user details (for non-logged in users)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String get currencySymbol => widget.deliveryType == "india" ? "₹" : "\$";
  bool get isBorrowed => widget.course['borrowed'] == true;
  double get coursePrice => (widget.course['total'] ?? 0).toDouble();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  // Helper method to refresh user data from SharedPreferences
  Future<Map<String, String>> _refreshUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'token': prefs.getString(PreferencesKey.token) ?? '',
      'userId': prefs.getString(PreferencesKey.userId) ?? '',
      'type': prefs.getString(PreferencesKey.type) ?? '',
      'name': prefs.getString(PreferencesKey.name) ?? '',
      'email': prefs.getString(PreferencesKey.email) ?? '',
      'contact': prefs.getString(PreferencesKey.contactNumber) ?? '',
    };
    
    print("📱 Refreshed User Data:");
    print("Token: ${data['token']}");
    print("UserId: ${data['userId']}");
    print("Type: ${data['type']}");
    
    return data;
  }

  // Helper Methods
  List<String> descriptionLines(String text) {
    return text
        .replaceAll("\\n", "\n")
        .split("\n")
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  Widget buildDescription(String desc) {
    final lines = descriptionLines(desc);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final isPrice = line.contains("₹") || line.contains("\$");
        final isBulletPoint = line.trim().startsWith("-") ||
            line.trim().startsWith("•") ||
            line.trim().startsWith("*");

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBulletPoint) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 8),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 19, 4, 66),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    line.trim().replaceFirst(RegExp(r'^[-•*]\s*'), ''),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isPrice ? FontWeight.w600 : FontWeight.normal,
                      color: isPrice ? Colors.green : Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    line.trim(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isPrice ? FontWeight.w600 : FontWeight.normal,
                      color: isPrice ? Colors.green : Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  // Payment Gateway Methods
  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful"),
        backgroundColor: Colors.green,
      ),
    );

    // Call enrollment API on success
    await _callSubmitEnrollmentAPI(
      paymentId: response.paymentId,
      orderId: response.orderId,
      status: "success",
      paymentGateway: "razorpay",
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );

    // Call enrollment API on failure
    await _callSubmitEnrollmentAPI(
      paymentId: null,
      orderId: null,
      status: "failed",
      paymentGateway: "razorpay",
    );
  }

  // Check login status with fresh data
  Future<bool> _isUserLoggedIn() async {
    // Force refresh SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    final token = prefs.getString(PreferencesKey.token) ?? '';
    final userId = prefs.getString(PreferencesKey.userId) ?? '';
    final type = prefs.getString(PreferencesKey.type) ?? '';
    
    // Allow both patient AND therapist to enroll
    final isLoggedIn = token.isNotEmpty && 
                       userId.isNotEmpty && 
                       (type == "patient" || type == "therapist");
    
    print("📱 Login Status Check (Fresh):");
    print("Token: $token");
    print("UserId: $userId");
    print("Type: $type");
    print("Is Logged In: $isLoggedIn");
    
    return isLoggedIn;
  }

  // Main Enrollment API Call
  Future<void> _callSubmitEnrollmentAPI({
    required String status,
    String? paymentId,
    String? orderId,
    String? paymentGateway,
  }) async {
    // Check if course is borrowed
    if (isBorrowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "❌ This course is already borrowed and cannot be enrolled",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // IMPORTANT: Get FRESH user data for each API call
      final userData = await _refreshUserData();
      
      final therapistId = userData['userId'];

      final body = {
        "therapistId": therapistId,
        "courseId": widget.course['id'].toString(),
        "paymentId": paymentId ?? "",
        "orderId": orderId ?? "",
        "amount": coursePrice.toString(),
        "status": status,
        "email": userData['email'],
        "name": userData['name'],
        "contact": userData['contact'],
        "paymentGateway":
            paymentGateway ??
            (widget.deliveryType == "india" ? "razorpay" : "paypal"),
      };

      print("📤 Enrollment Request Body: $body");
      print("User Type: ${userData['type']}");

      final response = await http.post(
        Uri.parse("https://jinreflexology.in/api1/new/CourseEnrollment.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      );

      print("📥 Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        print("📥 Enrollment Response: $res");

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == "success"
                    ? "✅ Course enrolled successfully"
                    : "❌ Enrollment failed",
              ),
              backgroundColor: status == "success" ? Colors.green : Colors.red,
            ),
          );
        }

        if (status == "success" && mounted) {
          // Navigate back to refresh the course list
          Navigator.pop(context, true);
        }
      } else {
        throw Exception("API Error ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Enrollment API Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // Main Enrollment Handler
  Future<void> _handleEnrollNow() async {
    if (isBorrowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "❌ This course is already borrowed and cannot be enrolled",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Prevent multiple login attempts
    if (_isLoginInProgress) {
      return;
    }

    // Check if user is logged in with fresh data
    final isLoggedIn = await _isUserLoggedIn();

    if (!isLoggedIn) {
      setState(() => _isLoginInProgress = true);
      
      print("🚀 Redirecting to login screen...");
      
      // Navigate to login screen and wait for result
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => JinLoginScreen(
            text: "CourseDetailScreen",
            type: "therapist",
            diliveryType: widget.deliveryType,
            registershow: true,
            onTab: () {
              // This will navigate to MemberListScreen
              // But we'll handle return separately
            },
          ),
        ),
      );

      setState(() => _isLoginInProgress = false);

      // IMPORTANT: Give some time for SharedPreferences to update
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Check login status again after returning with FRESH data
      final isNowLoggedIn = await _isUserLoggedIn();
      
      if (isNowLoggedIn) {
        print("✅ Login successful! Token updated. Retrying enrollment...");
        
        // Small delay to ensure all data is loaded
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Retry enrollment
        if (mounted) {
          _handleEnrollNow();
        }
      } else {
        print("❌ Login failed or cancelled");
        // User cancelled login or login failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please login to enroll in this course"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
      return;
    }

    // User is logged in, proceed with enrollment
    print("✅ User is logged in. Proceeding with enrollment...");

    // Free course
    if (coursePrice == 0) {
      await _callSubmitEnrollmentAPI(
        status: "success",
        paymentGateway: "free",
      );
      return;
    }

    // Paid course - start payment
    if (widget.deliveryType == "india") {
      _startRazorpayPayment();
    } else {
      _startPayPalPayment();
    }
  }

  // Razorpay Payment
  void _startRazorpayPayment() {
    final amount = (coursePrice * 100).toInt(); // Convert to paise

    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', 
      'amount': amount.toString(),
      'name': 'Jin Reflexology',
      'description': widget.course['title'],
      'prefill': {
        'contact':
            _mobileController.text.trim().isNotEmpty
                ? _mobileController.text.trim()
                : AppPreference().getString(PreferencesKey.contactNumber) ??
                    '9999999999',
        'email':
            _emailController.text.trim().isNotEmpty
                ? _emailController.text.trim()
                : AppPreference().getString(PreferencesKey.email) ??
                    'user@example.com',
        'name':
            _firstNameController.text.trim().isNotEmpty
                ? "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}"
                    .trim()
                : AppPreference().getString(PreferencesKey.name) ?? 'Customer',
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('❌ Razorpay Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment gateway error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // PayPal Payment
  void _startPayPalPayment() async {
    final userData = await _refreshUserData();
    final userId = userData['userId']!;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: isSandboxMode,
              clientId: paypalClientId,
              secretKey: paypalSecret,
              transactions: [
                {
                  "amount": {"total": coursePrice, "currency": "USD"},
                  "description": "Course Enrollment Payment",
                },
              ],
              note: "Course Enrollment Payment",
              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"];

                if (paypalPaymentId == null) {
                  debugPrint("❌ PayPal paymentId null");
                  return;
                }

                await _callSubmitEnrollmentAPI(
                  paymentId: paypalPaymentId,
                  orderId: null,
                  status: "success",
                  paymentGateway: "PayPal",
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ PayPal Payment Successful"),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context); // close PayPal screen
              },
              onError: (error) async {
                await sendPaymentToBackend(
                  userId: userId,
                  status: "failed",
                  reason: error.toString(),
                  amount: coursePrice.toInt(),
                );

                debugPrint("❌ PayPal Error: $error");

                if (mounted) Navigator.pop(context);
              },
              onCancel: () async {
                await sendPaymentToBackend(
                  userId: userId,
                  status: "failed",
                  reason: "Payment cancelled",
                  amount: coursePrice.toInt(),
                );

                debugPrint("⚠️ PayPal Cancelled");

                if (mounted) Navigator.pop(context);
              },
            ),
      ),
    );
  }

  // Send Payment Callback to Backend (for PayPal errors)
  Future<void> sendPaymentToBackend({
    required String userId,
    required String status,
    String? paymentId,
    String? orderId,
    String? reason,
    required int amount,
  }) async {
    try {
      final dio = Dio();

      await dio.post(
        "https://admin.jinreflexology.in/api/payment_callback",
        data: {
          "user_id": userId,
          "payment_id": paymentId,
          "orderid": orderId,
          "amount": amount.toString(),
          "status": status,
          "reason": reason,
          "email": _emailController.text.trim(),
          "name":
              "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
          "contact": _mobileController.text.trim(),
          "course_id": widget.course['id'],
          "delivery_type": widget.deliveryType,
        },
      );
    } catch (e) {
      debugPrint("❌ Payment callback error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.course['image'] ?? '';
    final title = widget.course['title'] ?? '';
    final longDesc = widget.course['longDesc'] ?? '';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color.fromARGB(255, 19, 4, 66),
                            child: const Center(
                              child: Icon(
                                Icons.book_outlined,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 19, 4, 66),
                                const Color.fromARGB(255, 88, 72, 137),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.book_outlined,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  title: Text(
                    "Course Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Title Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color.fromARGB(255, 19, 4, 66),
                                        const Color.fromARGB(255, 88, 72, 137),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "JIN REFLEXOLOGY",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    widget.deliveryType == "india"
                                        ? "INR"
                                        : "USD",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(
                              color: Colors.grey[300],
                              height: 1,
                            ),
                            const SizedBox(height: 16),

                            // Borrowed Status Badge
                            if (isBorrowed)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green[200]!,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: Colors.green[700],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Already Enrolled",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  color: const Color.fromARGB(255, 19, 4, 66),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Course Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 40,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 19, 4, 66),
                                    const Color.fromARGB(255, 88, 72, 137),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (longDesc.isNotEmpty)
                              buildDescription(longDesc),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Price Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 19, 4, 66)
                                  .withOpacity(0.95),
                              const Color.fromARGB(255, 88, 72, 137)
                                  .withOpacity(0.95),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 19, 4, 66)
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total Price",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$currencySymbol ${coursePrice.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.lock_open_rounded,
                                        color: Colors.green[700],
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Secure Payment",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (isBorrowed || _isLoginInProgress) 
                                    ? null 
                                    : _handleEnrollNow,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 19, 4, 66),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                  disabledBackgroundColor: Colors.grey[300],
                                  disabledForegroundColor: Colors.grey[600],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isLoginInProgress)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(255, 19, 4, 66),
                                          ),
                                        ),
                                      )
                                    else
                                      Icon(
                                        isBorrowed
                                            ? Icons.check_circle
                                            : Icons.shopping_cart_checkout_rounded,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _isLoginInProgress
                                          ? "Please wait..."
                                          : isBorrowed
                                              ? "Already Enrolled"
                                              : coursePrice == 0
                                                  ? "Enroll for Free"
                                                  : "Enroll Now",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Lifetime Access • Downloadable Content • Certificate Included",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Loading Indicator
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}