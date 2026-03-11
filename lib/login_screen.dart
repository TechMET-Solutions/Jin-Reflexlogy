import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jin_reflex_new/auth/forget_passworld_screen.dart';
import 'package:jin_reflex_new/auth/login_notifier.dart';
import 'package:jin_reflex_new/auth/sign_up_screen.dart';
import 'package:http/http.dart' as http;

class JinLoginScreen extends ConsumerStatefulWidget {
  const JinLoginScreen({
    super.key,
    required this.onTab,
    required this.text,
    this.diliveryType,
    this.type,
    this.registershow = false,
    this.shop = false,
  });

  final VoidCallback onTab;
  final text;
  final type;
  final diliveryType;
  final registershow;
  final shop;

  @override
  ConsumerState<JinLoginScreen> createState() => _JinLoginScreenState();
}

class _JinLoginScreenState extends ConsumerState<JinLoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers for shop signup popup
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isApiLoading = false;
  bool _isRegisterLoading = false; // Separate loading for register

  @override
  void initState() {
    super.initState();
    print("JinLoginScreen initState - _isRegisterLoading: $_isRegisterLoading");
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  // Method to show Shop Registration Popup
  void _showShopRegistrationPopup() {
    print("Opening Shop Registration Popup");
    // Reset loading state before showing popup
    setState(() {
      _isRegisterLoading = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildShopRegistrationForm(),
        );
      },
    );
  }

  // Shop Registration Form Widget with Password Field
  Widget _buildShopRegistrationForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 19, 4, 66),
                  Color.fromARGB(255, 88, 72, 137),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.store, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Shop Registration",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed:
                      _isRegisterLoading
                          ? null
                          : () {
                            print("Closing popup via close button");
                            Navigator.of(context).pop();
                            // Clear fields when closing
                            _nameController.clear();
                            _emailController.clear();
                            _mobileController.clear();
                            _regPasswordController.clear();
                          },
                ),
              ],
            ),
          ),

          // Name Field
          TextField(
            controller: _nameController,
            enabled: !_isRegisterLoading,
            decoration: InputDecoration(
              hintText: "Enter Name",
              labelText: "Name",
              prefixIcon: const Icon(
                Icons.person,
                color: Color.fromARGB(255, 19, 4, 66),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          const SizedBox(height: 15),

          // Email Field
          TextField(
            controller: _emailController,
            enabled: !_isRegisterLoading,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter Email",
              labelText: "Email",
              prefixIcon: const Icon(
                Icons.email,
                color: Color.fromARGB(255, 19, 4, 66),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          const SizedBox(height: 15),

          // Mobile Field
          TextField(
            controller: _mobileController,
            enabled: !_isRegisterLoading,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: InputDecoration(
              hintText: "Enter Mobile",
              labelText: "Mobile",
              prefixIcon: const Icon(
                Icons.phone,
                color: Color.fromARGB(255, 19, 4, 66),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              counterText: "",
            ),
          ),
          const SizedBox(height: 15),

          // Password Field
          TextField(
            controller: _regPasswordController,
            enabled: !_isRegisterLoading,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter Password",
              labelText: "Password",
              prefixIcon: const Icon(
                Icons.lock,
                color: Color.fromARGB(255, 19, 4, 66),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 20),

          // Buttons Row
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _isRegisterLoading
                          ? null
                          : () {
                            print("Canceling registration");
                            Navigator.of(context).pop();
                            _nameController.clear();
                            _emailController.clear();
                            _mobileController.clear();
                            _regPasswordController.clear();
                          },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),

              // Register Button with Loader
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _isRegisterLoading
                          ? null
                          : () {
                            print(
                              "REGISTER BUTTON CLICKED - Starting registration",
                            );
                            _callSignUpApi();
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child:
                      _isRegisterLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.app_registration, size: 18),
                              SizedBox(width: 5),
                              Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to call API - FIXED WITHOUT StateSetter parameter
  Future<void> _callSignUpApi() async {
    print("✅ _callSignUpApi() called");
    print("Current _isRegisterLoading: $_isRegisterLoading");

    // Validate fields
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _regPasswordController.text.isEmpty) {
      print("❌ Validation failed: Empty fields");
      _showSnackBar("Please fill all fields", Colors.red);
      return;
    }

    // Validate email
    if (!_emailController.text.contains('@')) {
      print("❌ Validation failed: Invalid email");
      _showSnackBar("Please enter valid email", Colors.red);
      return;
    }

    // Validate mobile (10 digits)
    if (_mobileController.text.length != 10) {
      print(
        "❌ Validation failed: Mobile not 10 digits - ${_mobileController.text.length}",
      );
      _showSnackBar("Mobile number must be 10 digits", Colors.red);
      return;
    }

    // Validate password (minimum 6 characters)
    if (_regPasswordController.text.length < 6) {
      print("❌ Validation failed: Password too short");
      _showSnackBar("Password must be at least 6 characters", Colors.red);
      return;
    }

    print("✅ All validations passed");
    print("Name: ${_nameController.text}");
    print("Email: ${_emailController.text}");
    print("Mobile: ${_mobileController.text}");
    print("Password: ${_regPasswordController.text}");

    // Show loader - using main setState
    if (!mounted) return;

    setState(() {
      _isRegisterLoading = true;
      print("✅ Loader started - _isRegisterLoading: $_isRegisterLoading");
    });

    try {
      // API URL
      final url = Uri.parse(
        'https://jinreflexology.in/api1/new/signUpPatient.php',
      );

      print("📡 Making API call to: $url");

      // Prepare request - SIMPLE POST
      var request = http.Request('POST', url);

      // Set headers
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      // Add fields as body
      request.bodyFields = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'password': _regPasswordController.text.trim(),
      };

      // Print request data
      print('------------ SIGN UP API DEBUG ------------');
      print('URL: $url');
      print('Method: POST');
      print('Headers: ${request.headers}');
      print('Body Fields: ${request.bodyFields}');

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Response Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      // Hide loader - using main setState
      if (!mounted) return;

      setState(() {
        _isRegisterLoading = false;
        print("✅ Loader stopped - _isRegisterLoading: $_isRegisterLoading");
      });

      // Parse JSON response
      var jsonResponse = jsonDecode(responseBody);

      String message = jsonResponse['message'] ?? 'Unknown response';

      if (response.statusCode == 200) {
        // Check success flag
        if (jsonResponse['success'] == 1) {
          // Success case
          print("✅ API Success: $message");
          _showMessageDialog(message, isSuccess: true);
        } else {
          // Error case from API
          print("⚠️ API Error: $message");
          _showMessageDialog(message, isSuccess: false);
        }
      } else {
        // HTTP Error
        print("❌ HTTP Error: ${response.statusCode}");
        _showSnackBar("API Error: ${response.statusCode}", Colors.red);
      }
    } catch (e) {
      print("❌ Exception caught: $e");

      // Hide loader on error - using main setState
      if (!mounted) return;

      setState(() {
        _isRegisterLoading = false;
        print("✅ Loader stopped due to error");
      });

      _showSnackBar("Connection Error: $e", Colors.red);
    }
  }

  // Updated message dialog with success/error differentiation
  void _showMessageDialog(String message, {required bool isSuccess}) {
    print("Showing message dialog: $message, isSuccess: $isSuccess");

    // Close the registration popup first
    Navigator.of(context).pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon based on success/error
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:
                        isSuccess
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.info_outline,
                    color: isSuccess ? Colors.green : Colors.orange,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  isSuccess ? "Success!" : "Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),

                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 19, 4, 66),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Closing message dialog");
                      Navigator.of(context).pop();
                      // Clear fields on success
                      if (isSuccess) {
                        _nameController.clear();
                        _emailController.clear();
                        _mobileController.clear();
                        _regPasswordController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show API Response Dialog
  void _showApiResponseDialog(String responseBody) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 15),

                // Title
                const Text(
                  "API Call Successful!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 4, 66),
                  ),
                ),
                const SizedBox(height: 10),

                // Sent Parameters
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📤 Sent Parameters:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 19, 4, 66),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildParamRow("Name", _nameController.text),
                      _buildParamRow("Email", _emailController.text),
                      _buildParamRow("Mobile", _mobileController.text),
                      _buildParamRow("Password", "********"),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Response
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📥 Server Response:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(responseBody, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "CLOSE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method for parameter row
  Widget _buildParamRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Color.fromARGB(255, 19, 4, 66)),
            ),
          ),
        ],
      ),
    );
  }

  // Show SnackBar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Material(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: TopWaveClipper(),
                  child: Container(
                    height: size.height * 0.4,
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
                  ),
                ),
              ),

              /// Logo/Title
              Positioned(
                top: size.height * 0.12,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      "JIN REFLEXOLOGY",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),

              /// Login Form Card
              Positioned(
                top: size.height * 0.25,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 25,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Welcome Back Title
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "WELCOME BACK",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Log In to your Account",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// ID Field
                      TextField(
                        controller: _idController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "ID",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey[600],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600],
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Login Button
                      Material(
                        borderRadius: BorderRadius.circular(12),
                        elevation: 5,
                        shadowColor: const Color(0xFF6A11CB).withOpacity(0.3),
                        child: InkWell(
                          onTap:
                              loginState.isLoading
                                  ? null
                                  : () async {
                                    final username = _idController.text.trim();
                                    final password =
                                        _passwordController.text.trim();

                                    if (username.isEmpty || password.isEmpty) {
                                      _showSnackBar(
                                        'Please fill all fields',
                                        Colors.red,
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
                                          DeliveryType: widget.diliveryType,
                                        );
                                  },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 19, 4, 66),
                                  Color.fromARGB(255, 88, 72, 137),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Center(
                              child: loginState.maybeWhen(
                                loading:
                                    () => const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                orElse:
                                    () => const Text(
                                      "LOG IN",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontSize: 14,
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

                      const SizedBox(height: 20),

                      /// Regular Sign Up
                      if (widget.registershow == true)
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
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
                                    fontSize: 14,
                                    color: const Color.fromARGB(
                                      255,
                                      143,
                                      138,
                                      160,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (widget.registershow == true)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Forgot Password Screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordScreen(
                                                userType: "therapist",
                                              ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (widget.registershow != true && widget.shop == true)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ForgotPasswordScreen(
                                                userType: "patient",
                                              ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),

                      /// SHOP SIGN UP LINK - OPENS POPUP
                      if (widget.shop == true)
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          ShopRegisterPopup.show(
                                            context: context,
                                            onSuccess: () {
                                              print(
                                                "Shop Registered Successfully",
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.app_registration,
                                        ),
                                        label: const Text(
                                          "Register Shop",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            19,
                                            4,
                                            66,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Top Wave Clipper
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);

    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.9);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.7);
    final secondEndPoint = Offset(size.width, size.height * 0.85);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShopRegisterPopup {
  static void show({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ShopRegisterDialog();
      },
    );
  }
}

class ShopRegisterDialog extends StatefulWidget {
  const ShopRegisterDialog({super.key});

  @override
  State<ShopRegisterDialog> createState() => _ShopRegisterDialogState();
}

class _ShopRegisterDialogState extends State<ShopRegisterDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),

            // Form Fields
            _buildNameField(),
            const SizedBox(height: 15),

            _buildEmailField(),
            const SizedBox(height: 15),

            _buildMobileField(),
            const SizedBox(height: 15),

            _buildPasswordField(),
            const SizedBox(height: 20),

            // Buttons
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 19, 4, 66),
            Color.fromARGB(255, 88, 72, 137),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.store, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Shop Registration",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      enabled: !_isLoading,
      decoration: InputDecoration(
        hintText: "Enter Name",
        labelText: "Name",
        prefixIcon: const Icon(
          Icons.person,
          color: Color.fromARGB(255, 19, 4, 66),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      enabled: !_isLoading,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter Email",
        labelText: "Email",
        prefixIcon: const Icon(
          Icons.email,
          color: Color.fromARGB(255, 19, 4, 66),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _buildMobileField() {
    return TextField(
      controller: _mobileController,
      enabled: !_isLoading,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: InputDecoration(
        hintText: "Enter Mobile",
        labelText: "Mobile",
        prefixIcon: const Icon(
          Icons.phone,
          color: Color.fromARGB(255, 19, 4, 66),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        counterText: "",
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      enabled: !_isLoading,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: "Enter Password",
        labelText: "Password",
        prefixIcon: const Icon(
          Icons.lock,
          color: Color.fromARGB(255, 19, 4, 66),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: OutlinedButton(
            onPressed:
                _isLoading
                    ? null
                    : () {
                      _clearFields();
                      Navigator.of(context).pop();
                    },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 12),

        // Register Button
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _registerShop,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.app_registration, size: 18),
                        SizedBox(width: 5),
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }

  Future<void> _registerShop() async {
    // Validation
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar("Please fill all fields", Colors.red);
      return;
    }

    if (!_emailController.text.contains('@')) {
      _showSnackBar("Please enter valid email", Colors.red);
      return;
    }

    if (_mobileController.text.length != 10) {
      _showSnackBar("Mobile number must be 10 digits", Colors.red);
      return;
    }

    if (_passwordController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters", Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://jinreflexology.in/api1/new/signUpPatient.php',
      );

      final response = await http.post(
        url,
        body: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobile': _mobileController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        try {
          var jsonResponse = jsonDecode(response.body);
          String message = jsonResponse['message'] ?? 'Registration successful';

          // Show success message
          _showSuccessDialog(message);
        } catch (e) {
          // If response is not JSON (like HTML error), still show success
          _showSuccessDialog("Registration completed");
        }
      } else {
        _showSnackBar("Server Error: ${response.statusCode}", Colors.red);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      print('Error: $e');
      _showSnackBar("Connection Error", Colors.red);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 19, 4, 66),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close success dialog
                      Navigator.of(context).pop(); // Close registration popup
                      _clearFields();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _passwordController.clear();
  }
}
