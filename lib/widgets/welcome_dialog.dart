import 'package:flutter/material.dart';
import 'package:jin_reflex_new/services/first_time_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

/// Welcome dialog shown to first-time users
class WelcomeDialog extends StatefulWidget {
  final VoidCallback? onGetStarted;

  const WelcomeDialog({
    Key? key,
    this.onGetStarted,
  }) : super(key: key);

  @override
  State<WelcomeDialog> createState() => _WelcomeDialogState();

  /// Show the welcome dialog
  static Future<void> show(BuildContext context, {VoidCallback? onGetStarted}) async {
    debugPrint("🎯 WelcomeDialog: show() called");
    return showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside or using close button
      builder: (context) {
        debugPrint("✅ WelcomeDialog: Building dialog widget");
        return WelcomeDialog(onGetStarted: onGetStarted);
      },
    );
  }
}

class _WelcomeDialogState extends State<WelcomeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  // Form controllers
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dealerIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dealerIdController.dispose();
    super.dispose();
  }

void _handleSubmit() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  debugPrint("🎯 WelcomeDialog: User tapped Submit");

  // Loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
      ),
    ),
  );

  try {
    final dio = Dio();

    final response = await dio.post(
      'https://admin.jinreflexology.in/api/user-dealer-mappings',
      data: {
        "name": _nameController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "email": _emailController.text.trim(),
        "dealerId": _dealerIdController.text.trim(),
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status! < 500,
      ),
    );

    debugPrint("📥 API Response: ${response.statusCode}");
    debugPrint("📥 API Data: ${response.data}");

    // Close loading dialog FIRST if context is still valid
    if (mounted) {
      Navigator.pop(context); // close loading
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();

      // ✅ Save user data FIRST
      await prefs.setString('welcome_name', _nameController.text.trim());
      await prefs.setString('welcome_mobile', _mobileController.text.trim());
      await prefs.setString('welcome_email', _emailController.text.trim());
      await prefs.setString('welcome_dealer_id', _dealerIdController.text.trim());

      // ✅ MAIN LOGIC - Dealer ID check
      if (_dealerIdController.text.trim().isNotEmpty) {
        await prefs.setBool('dealer_completed', true);
        debugPrint("✅ Dealer ID present → Popup permanently closed");
      } else {
        await prefs.setBool('dealer_completed', false);
        debugPrint("⚠️ Dealer ID missing → Popup will show again");
      }

      // ✅ Force immediate save
      await prefs.reload();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );

      // Close the welcome dialog
      Navigator.of(context).pop();
      
      // Call callback to refresh home screen
      widget.onGetStarted?.call();
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    debugPrint("❌ Error: $e");

    // Close loading dialog if open
    if (mounted) {
      Navigator.pop(context); // close loading
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Something went wrong. Please try again."),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.75,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 19, 4, 66),
                  Color.fromARGB(255, 88, 72, 137),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button at top right
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          debugPrint("❌ WelcomeDialog: User closed dialog");
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Close',
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/image 4.png",
                        width: 80,
                        height: 80,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Welcome Text
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // App Name
                    const Text(
                      "JIN REFLEXOLOGY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
TextFormField(
  controller: _nameController,
  style: const TextStyle(color: Colors.white),
  keyboardType: TextInputType.name,
  textCapitalization: TextCapitalization.words,

  decoration: InputDecoration(
    labelText: 'Full Name *',
    labelStyle: const TextStyle(color: Colors.white70),

    prefixIcon: const Icon(
      Icons.person,
      color: Colors.yellow,
    ),

    filled: true,
    fillColor: Colors.white.withOpacity(0.1),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          BorderSide(color: Colors.white.withOpacity(0.3)),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          BorderSide(color: Colors.white.withOpacity(0.3)),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          const BorderSide(color: Colors.yellow, width: 2),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
  ),

  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 3) {
      return 'Enter valid name';
    }

    return null;
  },
),

                     const SizedBox(height: 10),
                    // Mobile Number Field
                    TextFormField(
                      controller: _mobileController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.phone, color: Colors.yellow),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.yellow, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mobile number is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Enter a valid mobile number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email *',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.email, color: Colors.yellow),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.yellow, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Dealer ID Field (Optional)
                    TextFormField(
                      controller: _dealerIdController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: InputDecoration(
                        labelText: 'VD ID (Optional - 4 digits)',
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.badge, color: Colors.yellow),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.yellow, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        counterText: '', // Hide character counter
                      ),
                      validator: (value) {
                        // Only validate if user entered something
                        if (value != null && value.trim().isNotEmpty) {
                          if (value.trim().length != 4) {
                            return 'Dealer ID must be exactly 4 digits';
                          }
                          // Check if all characters are digits
                          if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                            return 'Dealer ID must contain only numbers';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEB3B),
                          foregroundColor: const Color.fromARGB(255, 19, 4, 66),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          shadowColor: Colors.yellow.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "SUBMIT",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.check_circle, size: 24),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tagline
                    const Text(
                      "Your Healthy Life Is Our Priority",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
