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

  void openCourseDetail(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
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

    // ✅ Payment successful झाल्यानंतर enrollment API call करा
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

    // ✅ Payment failed असल्यास enrollment API call करा (failed status सह)
    await _callSubmitEnrollmentAPI(
      paymentId: null,
      orderId: null,
      status: "failed",
      paymentGateway: "razorpay",
    );
  }

  // ✅ MAIN ENROLLMENT API CALL FUNCTION
  Future<void> _callSubmitEnrollmentAPI({
    required String status, // success / failed
    String? paymentId,
    String? orderId,
    String? paymentGateway, // razorpay / paypal
  }) async {
    if (selectedCourse == null) return;

    // ✅ Check if course is borrowed - जर borrowed असेल तर API call करू नये
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

      final therapistId = AppPreference().getString(PreferencesKey.userId);

      final body = {
        "therapistId": therapistId,
        "courseId": selectedCourse!['id'].toString(),
        "paymentId": paymentId ?? "",
        "orderId": orderId ?? "",
        "amount": selectedCourse!['total'].toString(),
        "status": status,
        "email": AppPreference().getString(PreferencesKey.email),
        "name": AppPreference().getString(PreferencesKey.name),
        "contact": AppPreference().getString(PreferencesKey.contactNumber),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitEnrollment() async {
    if (selectedCourse == null) return;

    // ✅ Check if course is borrowed - जर borrowed असेल तर payment पण start करू नये
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

    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);

    // Guest user → details dialog
    if (token.isEmpty || userId.isEmpty) {
      await _showPaymentDialog();
      return;
    }

    // ✅ Logged-in user → direct payment
    if (widget.deliveryType == "india") {
      _startPayment(); // Razorpay
    } else {
      _startPayPalPayment(context); // PayPal
    }
  }

  void _startPayPalPayment(BuildContext context) {
    if (selectedCourse == null) return;

    // ✅ Check if course is borrowed
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
    final double amount = selectedCourse!['total']; // USD amount

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

                Navigator.pop(context); // close PayPal screen
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

  // ✅ Payment Dialog for non-logged in users
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
                      // Validate required fields
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

  // ✅ Start Payment Function
  void _startPayment() {
    if (selectedCourse == null) return;

    // ✅ Check if course is borrowed
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

    final amount = (selectedCourse!['total'] * 100).toInt(); // Convert to paise

    var options = {
      'key':
          'rzp_test_1DP5mmOlF5G5ag', // 🔴 Replace with your actual Razorpay key
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

  // ✅ Send Payment Callback to Backend
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

  @override
  Widget build(BuildContext context) {
    final token = AppPreference().getString(PreferencesKey.userId);
    final type = AppPreference().getString(PreferencesKey.type);

    return Scaffold(
      appBar: CommonAppBar(
        title:
            widget.deliveryType == "india"
                ? "Courses (India Delivery)"
                : "Courses (Outside India)",
      ),
      body:
          type == "patient" || token.isEmpty
              ? JinLoginScreen(
                text: "CourseScreen",
                type: "therapist",
                onTab: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemberListScreen()),
                  );
                },
              )
              : Column(
                children: [
                  Expanded(
                    child:
                        isLoading
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Loading Courses...",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : hasError
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Something went wrong",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Please try again later",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: fetchCourses,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Retry",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : courses.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "No Courses Available",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Check back soon for new courses",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                final isPopular = index % 3 == 0;
                                final isSelected = selectedIndex == index;
                                final isBorrowed = course['borrowed'] == true;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    // boxShadow: isSelected
                                    //     ? [
                                    //         BoxShadow(
                                    //           color: Colors.blue.withOpacity(0.3),
                                    //           blurRadius: 10,
                                    //           spreadRadius: 2,
                                    //           offset: Offset(0, 4),
                                    //         ),
                                    //       ]
                                    //     : [],
                                  ),
                                  child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color:
                                            isSelected
                                                ? Colors.blue
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap:
                                          isBorrowed
                                              ? null // ❌ Borrowed course ला tap नाही काम करणार
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
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Borrowed Badge - जर borrowed असेल तर
                                            if (isBorrowed)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange[50],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.orange,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.bookmark,
                                                      size: 14,
                                                      color: Colors.orange[700],
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Borrowed",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.orange[800],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            SizedBox(
                                              height: isBorrowed ? 8 : 0,
                                            ),

                                            if (isSelected && !isBorrowed)
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.blue,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "Selected",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            SizedBox(
                                              height:
                                                  (isSelected && !isBorrowed)
                                                      ? 8
                                                      : 0,
                                            ),

                                            if (isPopular && !isBorrowed)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber[50],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.amber,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color: Colors.amber[700],
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Popular",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.amber[800],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            SizedBox(
                                              height:
                                                  ((isSelected || isPopular) &&
                                                          !isBorrowed)
                                                      ? 12
                                                      : 0,
                                            ),

                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        color: Colors.grey[100],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child:
                                                            course['image'] !=
                                                                    ""
                                                                ? Image.network(
                                                                  course['image'],
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                  errorBuilder:
                                                                      (
                                                                        _,
                                                                        __,
                                                                        ___,
                                                                      ) => Center(
                                                                        child: Icon(
                                                                          Icons
                                                                              .school_outlined,
                                                                          size:
                                                                              40,
                                                                          color:
                                                                              Colors.grey[400],
                                                                        ),
                                                                      ),
                                                                )
                                                                : Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .school_outlined,
                                                                    size: 40,
                                                                    color:
                                                                        Colors
                                                                            .grey[400],
                                                                  ),
                                                                ),
                                                      ),
                                                    ),
                                                    // if (isBorrowed)
                                                    //   Container(
                                                    //     width: 100,
                                                    //     height: 100,
                                                    //     decoration: BoxDecoration(
                                                    //       borderRadius: BorderRadius.circular(12),
                                                    //       color: Colors.black.withOpacity(0.5),
                                                    //     ),
                                                    //     child: Center(
                                                    //       child: Icon(
                                                    //         Icons.lock,
                                                    //         color: Colors.white,
                                                    //         size: 30,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                  ],
                                                ),

                                                SizedBox(width: 16),

                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        course['title'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.grey[900],
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),

                                                      SizedBox(height: 6),

                                                      Text(
                                                        course['description'],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[600],
                                                          height: 1.4,
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),

                                                      SizedBox(height: 12),
                                                      Row(
                                                        children: [
                                                          if (isBorrowed)
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 4,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .green[100],
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                              child: const Text(
                                                                "Already Enrolled",
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .green,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      if (!isBorrowed)
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical: 6,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .green[50],
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                                // border: isBorrowed
                                                                //     ? Border.all(color: Colors.grey)
                                                                //     : null,
                                                              ),
                                                              child: Text(
                                                                "${widget.deliveryType == "india" ? "₹" : "\$"}${course['total']}",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      isBorrowed
                                                                          ? Colors
                                                                              .grey[600]
                                                                          : Colors
                                                                              .green[800],
                                                                ),
                                                              ),
                                                            ),

                                                            // ❌ Borrowed असल्यास button दिसणार नाही
                                                            if (!isBorrowed)
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (selectedIndex ==
                                                                        index) {
                                                                      selectedIndex =
                                                                          null;
                                                                      selectedCourse =
                                                                          null;
                                                                    } else {
                                                                      selectedIndex =
                                                                          index;
                                                                      selectedCourse =
                                                                          course;
                                                                    }
                                                                  });
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      isSelected
                                                                          ? Colors
                                                                              .grey[300]
                                                                          : Colors
                                                                              .blue,
                                                                  foregroundColor:
                                                                      isSelected
                                                                          ? Colors
                                                                              .grey[700]
                                                                          : Colors
                                                                              .white,
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            24,
                                                                        vertical:
                                                                            10,
                                                                      ),
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  elevation: 0,
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      isSelected
                                                                          ? Icons
                                                                              .check
                                                                          : Icons
                                                                              .add_circle_outline,
                                                                      size: 18,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    Text(
                                                                      isSelected
                                                                          ? "Selected"
                                                                          : "Select",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            else
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .grey[200],
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .lock,
                                                                      size: 18,
                                                                      color:
                                                                          Colors
                                                                              .grey[600],
                                                                    ),
                                                                    SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    Text(
                                                                      "Borrowed",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color:
                                                                            Colors.grey[600],
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
                                              ],
                                            ),

                                            if (index != courses.length - 1)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 16,
                                                ),
                                                child: Divider(
                                                  height: 1,
                                                  color: Colors.grey[200],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),

                  // Bottom enrollment section - borrowed course selected असल्यास दिसणार नाही
                  if (selectedCourse != null &&
                      !isLoading &&
                      !hasError &&
                      courses.isNotEmpty &&
                      selectedCourse!['borrowed'] != true)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCourse!['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${widget.deliveryType == "india" ? "₹" : "\$"} ${selectedCourse!['total']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ElevatedButton(
                            onPressed: submitEnrollment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: Text(
                              "Enroll Now",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
    );
  }
}
