import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbord_forlder/CourseDetailScreen.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.deliveryType});
  final String deliveryType;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;
  bool hasError = false;
  int? selectedIndex;
  Map<String, dynamic>? selectedCourse;
  late Razorpay _razorpay;
  bool _isLoginInProgress = false;

  // Text controllers for user details
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourses();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  String countryCode = "in";

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

  // Check login status with fresh data
  Future<bool> _isUserLoggedIn() async {
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

  Future<String> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type");
    return deliveryType == "india" ? "in" : "us";
  }

  Future<void> fetchCourses() async {
    final therapistId = AppPreference().getString(PreferencesKey.userId);
    try {
      // Get country code correctly
      countryCode = await getCountryCode();

      final response = await http.post(
        Uri.parse("https://admin.jinreflexology.in/api/courses/by-country"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"country": countryCode, "therapistId": therapistId}),
      );

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final data = jsonDecode(response.body);
      final List list = data['data'] ?? [];

      courses =
          list.map<Map<String, dynamic>>((e) {
            final List pricing = e['pricing'] ?? [];

            // Find pricing for the current country
            Map<String, dynamic>? pricingForCountry;
            for (var price in pricing) {
              if (price['country'] == countryCode) {
                pricingForCountry = price;
                break;
              }
            }

            final total = (pricingForCountry?['total_price'] ?? 0).toDouble();
            final borrowed = e['Borrowed'] ?? false;

            return {
              "id": e['id'],
              "title": e['title'] ?? "",
              "description": e['description'] ?? "",
              "longDesc": e['longDesc'] ?? "",
              "image":
                  (e['images'] != null && e['images'].isNotEmpty)
                      ? e['images'][0]
                      : "",
              "total": total,
              "isSelected": false,
              "borrowed": borrowed,
            };
          }).toList();

      hasError = false;
    } catch (e) {
      debugPrint("❌ Course API Error: $e");
      hasError = true;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
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
    _callSubmitEnrollmentAPI(
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

    final userData = await _refreshUserData();
    await sendPaymentToBackend(
      userId: userData['userId'] ?? '',
      status: "failed",
      reason: response.message,
      amount: (selectedCourse?['total'] ?? 0).toInt(),
    );
  }

  // MAIN ENROLLMENT API CALL FUNCTION
  Future<void> _callSubmitEnrollmentAPI({
    required String status,
    String? paymentId,
    String? orderId,
    String? paymentGateway,
  }) async {
    if (selectedCourse == null) return;

    // Check if course is borrowed
    if (selectedCourse!['borrowed'] == true) {
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

    try {
      // Loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Get FRESH user data
      final userData = await _refreshUserData();
      final therapistId = userData['userId'];

      final body = {
        "therapistId": therapistId,
        "courseId": selectedCourse!['id'].toString(),
        "paymentId": paymentId ?? "",
        "orderId": orderId ?? "",
        "amount": selectedCourse!['total'].toString(),
        "status": status,
        "email": userData['email'],
        "name": userData['name'],
        "contact": userData['contact'],
        "paymentGateway":
            paymentGateway ??
            (widget.deliveryType == "india" ? "razorpay" : "paypal"),
      };

      print("Enrollment Request Body: $body");

      final response = await http.post(
        Uri.parse("https://jinreflexology.in/api1/new/CourseEnrollment.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      );

      if (mounted) Navigator.pop(context); // close loader

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        print("Enrollment Response: $res");
        fetchCourses();
        final bool apiSuccess =
            res["success"] == true ||
            res["success"] == 1 ||
            res["status"] == "success";
        final String message =
            res["message"] ??
            (apiSuccess
                ? "Course enrolled successfully"
                : "Course enrollment failed");
        
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

        setState(() {
          selectedCourse = null;
          selectedIndex = null;
        });
      } else {
        throw Exception("API Error ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("❌ Enrollment API Error: $e");
    }
  }

  Future<void> submitEnrollment() async {
    if (selectedCourse == null) return;

    // Prevent multiple login attempts
    if (_isLoginInProgress) {
      return;
    }

    // Check if course is borrowed
    if (selectedCourse!['borrowed'] == true) {
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

    // Check login status with fresh data
    final isLoggedIn = await _isUserLoggedIn();

    if (!isLoggedIn) {
      setState(() => _isLoginInProgress = true);
      
      print("🚀 Redirecting to login screen...");
      
      // Navigate to login screen and wait for result
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => JinLoginScreen(
            text: "CourseScreen",
            type: "therapist",
            diliveryType: widget.deliveryType,
            registershow: true,
            onTab: () {
              // This will navigate to MemberListScreen
            },
          ),
        ),
      );

      setState(() => _isLoginInProgress = false);

      // Give time for SharedPreferences to update
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Check login status again
      final isNowLoggedIn = await _isUserLoggedIn();
      
      if (isNowLoggedIn) {
        print("✅ Login successful! Retrying enrollment...");
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          submitEnrollment(); // Retry enrollment
        }
      } else {
        print("❌ Login failed or cancelled");
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

    // FREE COURSE
    if ((selectedCourse!['total'] ?? 0) == 0) {
      await _callSubmitEnrollmentAPI(status: "success", paymentGateway: "free");
      return;
    }

    // PAID COURSE
    if (widget.deliveryType == "india") {
      _startPayment();
    } else {
      _startPayPalPayment(context);
    }
  }

  void _startPayPalPayment(BuildContext context) {
    if (selectedCourse == null) return;

    // Check if course is borrowed
    if (selectedCourse!['borrowed'] == true) {
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

    final userId = AppPreference().getString(PreferencesKey.userId);
    final double amount = selectedCourse!['total'];

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
                  "amount": {"total": amount, "currency": "USD"},
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

                Navigator.pop(context);
              },
              onError: (error) async {
                await sendPaymentToBackend(
                  userId:
                      userId.isNotEmpty
                          ? userId
                          : "guest_${DateTime.now().millisecondsSinceEpoch}",
                  status: "failed",
                  reason: error.toString(),
                  amount: amount.toInt(),
                );

                debugPrint("❌ PayPal Error: $error");

                if (mounted) Navigator.pop(context);
              },
              onCancel: () async {
                await sendPaymentToBackend(
                  userId:
                      userId.isNotEmpty
                          ? userId
                          : "guest_${DateTime.now().millisecondsSinceEpoch}",
                  status: "failed",
                  reason: "Payment cancelled",
                  amount: amount.toInt(),
                );

                debugPrint("⚠️ PayPal Cancelled");

                if (mounted) Navigator.pop(context);
              },
            ),
      ),
    );
  }

  // Payment Dialog for non-logged in users
  Future<void> _showPaymentDialog() async {
    return showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Complete Enrollment"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Please provide your details to proceed with payment:",
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: "First Name *",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email *",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: "Mobile Number *",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_firstNameController.text.trim().isEmpty ||
                          _emailController.text.trim().isEmpty ||
                          _mobileController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill all required fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.pop(context);
                      _startPayment();
                    },
                    child: Text(
                      "Proceed to Pay ${widget.deliveryType == "india" ? "₹" : "\$"}${selectedCourse?['total']}",
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  // Start Payment Function
  void _startPayment() {
    if (selectedCourse == null) return;

    if (selectedCourse!['borrowed'] == true) {
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

    final amount = (selectedCourse!['total'] * 100).toInt();

    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount.toString(),
      'name': 'Jin Reflexology',
      'description': selectedCourse!['title'],
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
            _firstNameController.text.trim().isNotEmpty
                ? "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}"
                    .trim()
                : 'Customer',
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

  // Send Payment Callback to Backend
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
          "course_id": selectedCourse?['id'],
          "delivery_type": widget.deliveryType,
        },
      );
    } catch (e) {
      debugPrint("❌ Payment callback error: $e");
    }
  }

  // Navigate to Course Detail Screen
  void _navigateToCourseDetail(Map<String, dynamic> course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailScreen(
          course: course,
          deliveryType: widget.deliveryType,
        ),
      ),
    );
    
    // Refresh courses if enrollment was successful
    if (result == true) {
      fetchCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title:
            widget.deliveryType == "india"
                ? "Courses (India Delivery)"
                : "Courses (Outside India)",
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 19, 4, 66).withOpacity(0.9),
                  const Color.fromARGB(255, 88, 72, 137).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.school_rounded, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "JIN Reflexology Courses",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Professional courses for therapists and enthusiasts",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.deliveryType == "india" ? "₹ INR" : "\$ USD",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Selected Course Bar
          if (selectedCourse != null && selectedCourse!['borrowed'] != true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border(
                  top: BorderSide(color: Colors.blue[100]!, width: 1),
                  bottom: BorderSide(color: Colors.blue[100]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Course: ${selectedCourse!['title']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Price: ${widget.deliveryType == "india" ? "₹" : "\$"}${selectedCourse!['total']}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoginInProgress ? null : submitEnrollment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
                    ),
                    child: _isLoginInProgress
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Enroll Now",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),

          Expanded(
            child:
                isLoading
                    ? _buildLoadingState()
                    : hasError
                    ? _buildErrorState()
                    : courses.isEmpty
                    ? _buildEmptyState()
                    : _buildCourseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 19, 4, 66).withOpacity(0.1),
                  const Color.fromARGB(255, 88, 72, 137).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color.fromARGB(255, 19, 4, 66),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading Courses...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please wait while we fetch the best courses for you",
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 50,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Something went wrong",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "We couldn't load the courses. Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fetchCourses,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                elevation: 2,
              ),
              child: const Text(
                "Try Again",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Courses Available",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "There are no courses available at the moment. Please check back soon for new courses.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final isSelected = selectedIndex == index;
        final isBorrowed = course['borrowed'] == true;
        final isPopular = index % 3 == 0;

        return GestureDetector(
          onTap: () {
            _navigateToCourseDetail(course);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected
                            ? const Color.fromARGB(255, 19, 4, 66)
                            : Colors.grey[200]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Badges
                          Row(
                            children: [
                              // Popular Badge
                              if (isPopular && !isBorrowed)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber[600]!,
                                        Colors.orange[400]!,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Popular",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Borrowed Badge
                              if (isBorrowed)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green[200]!,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 12,
                                        color: Colors.green[700],
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Already Enrolled",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              Spacer(),

                              // Price Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green[50]!,
                                      Colors.green[100]!,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Text(
                                  "${widget.deliveryType == "india" ? "₹" : "\$"}${course['total']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          // Course Title
                          Text(
                            course['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 8),

                          // Course Description
                          Text(
                            course['description'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 16),

                          // Image and Details Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Course Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[100],
                                  image:
                                      course['image'] != ""
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              course['image'],
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                                child:
                                    course['image'] == ""
                                        ? Center(
                                          child: Icon(
                                            Icons.school_outlined,
                                            size: 32,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                        : null,
                              ),

                              SizedBox(width: 16),

                              // Course Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // View Details Button
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        _navigateToCourseDetail(course);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                          255,
                                          19,
                                          4,
                                          66,
                                        ),
                                        side: BorderSide(
                                          color: const Color.fromARGB(
                                            255,
                                            19,
                                            4,
                                            66,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 14,
                                      ),
                                      label: Text(
                                        "View Details",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),

                                    SizedBox(height: 12),

                                    // Select Button
                                    if (!isBorrowed)
                                      ElevatedButton(
                                        onPressed: _isLoginInProgress
                                            ? null
                                            : () {
                                                setState(() {
                                                  if (selectedIndex == index) {
                                                    selectedIndex = null;
                                                    selectedCourse = null;
                                                  } else {
                                                    selectedIndex = index;
                                                    selectedCourse = course;
                                                  }
                                                });
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              isSelected
                                                  ? Colors.grey[200]
                                                  : const Color.fromARGB(
                                                    255,
                                                    19,
                                                    4,
                                                    66,
                                                  ),
                                          foregroundColor:
                                              isSelected
                                                  ? Colors.grey[700]
                                                  : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? Icons.check
                                                  : Icons.add_circle_outline,
                                              size: 16,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              isSelected
                                                  ? "Selected"
                                                  : "Select",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Selected Checkmark
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 19, 4, 66),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
