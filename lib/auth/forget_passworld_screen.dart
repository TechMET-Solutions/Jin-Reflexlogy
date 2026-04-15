import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.userType,
    required this.userId,
  });

  final String userType;
  final String userId;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isLoading = false;
  bool _otpSent = false;

  static const String _sendOtpUrl =
      'https://jinreflexology.in/api1/new/sendResetPasswordOtp.php';
  static const String _verifyOtpUrl =
      'https://jinreflexology.in/api1/new/verify_otp.php';

  @override
  void initState() {
    super.initState();
    _idController.text = widget.userId;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _idController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final requestBody = {
        'email': _emailController.text.trim(),
        'type': widget.userType,
        'id': _idController.text.trim(),
      };
      debugPrint('sendResetPasswordOtp request: $requestBody');

      final response = await http.post(
        Uri.parse(_sendOtpUrl),
        headers: const {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );

      debugPrint('sendResetPasswordOtp status: ${response.statusCode}');
      debugPrint('sendResetPasswordOtp response: ${response.body}');

      final data = _decodeResponse(response.body);
      final success = _isSuccessResponse(data);
      final message =
          _messageFromResponse(data) ?? 'OTP send karne me problem aayi.';

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (success) {
          _otpSent = true;
        }
      });

      _showSnackBar(message, success ? Colors.green : Colors.red);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Network error: $e', Colors.red);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      _showSnackBar('Please enter OTP', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final requestBody = {
        'email': _emailController.text.trim(),
        'otp': _otpController.text.trim(),
        'type': widget.userType,
      };
      debugPrint('verify_otp request: $requestBody');

      final response = await http.post(
        Uri.parse(_verifyOtpUrl),
        headers: const {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );

      debugPrint('verify_otp status: ${response.statusCode}');
      debugPrint('verify_otp response: ${response.body}');

      final data = _decodeResponse(response.body);
      final success = _isSuccessResponse(data);
      final message =
          _messageFromResponse(data) ?? 'OTP verify karne me problem aayi.';

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      _showSnackBar(message, success ? Colors.green : Colors.red);

      if (success) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ChangePasswordScreen(
                  userType: widget.userType,
                  userId: _idController.text.trim(),
                  email: _emailController.text.trim(),
                ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Network error: $e', Colors.red);
    }
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return {'message': responseBody};
  }

  bool _isSuccessResponse(Map<String, dynamic> data) {
    final success = data['success'];
    final status = data['status'];
    final message = (data['message'] ?? '').toString().toLowerCase();

    return success == 1 ||
        success == '1' ||
        success == true ||
        status == 1 ||
        status == '1' ||
        status == true ||
        status == 'success' ||
        message.contains('otp sent') ||
        message.contains('otp has been sent') ||
        message.contains('verified');
  }

  String? _messageFromResponse(Map<String, dynamic> data) {
    return data['message']?.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Forgot\nPassword?',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _otpSent
                        ? 'OTP email par send ho gaya hai. OTP verify karke next screen par new password set karo.'
                        : 'Apna registered email aur ID enter karo. Hum OTP send karenge.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInputCard(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isLoading && !_otpSent,
                          decoration: _inputDecoration(
                            'Registered Email',
                            Icons.email_outlined,
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return 'Please enter email';
                            }
                            final emailRegex = RegExp(
                              r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(email)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _idController,
                          enabled: !_isLoading && !_otpSent,
                          keyboardType: TextInputType.text,
                          decoration: _inputDecoration(
                            widget.userType == 'therapist'
                                ? 'Therapist ID'
                                : 'User ID',
                            Icons.badge_outlined,
                          ),
                          validator: (value) {
                            if ((value ?? '').trim().isEmpty) {
                              return 'Please enter ID';
                            }
                            return null;
                          },
                        ),
                        if (_otpSent) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _otpController,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              'Enter OTP',
                              Icons.password_outlined,
                            ),
                            maxLength: 6,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : (_otpSent ? _verifyOtp : _sendOtp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : Text(
                                _otpSent ? 'Verify OTP' : 'Send OTP',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                  if (_otpSent) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _sendOtp,
                        child: const Text('Resend OTP'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remember your password? ',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : () => Navigator.pop(context),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color:
                                  _isLoading
                                      ? Colors.grey.shade400
                                      : Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.blue.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      counterText: '',
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
    required this.userType,
    required this.userId,
    required this.email,
  });

  final String userType;
  final String userId;
  final String email;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  static const String _updatePasswordUrl =
      'https://jinreflexology.in/api1/new/updatePassword.php';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final requestBody = {
        'id': widget.userId,
        'type': widget.userType,
        'password': _passwordController.text.trim(),
      };
      debugPrint('updatePassword request: $requestBody');

      final response = await http.post(
        Uri.parse(_updatePasswordUrl),
        headers: const {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );

      debugPrint('updatePassword status: ${response.statusCode}');
      debugPrint('updatePassword response: ${response.body}');

      final data = _decodeResponse(response.body);
      final success = _isSuccessResponse(data);
      final message =
          _messageFromResponse(data) ?? 'Password update karne me problem aayi.';

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return {'message': responseBody};
  }

  bool _isSuccessResponse(Map<String, dynamic> data) {
    final success = data['success'];
    final status = data['status'];
    final message = (data['message'] ?? '').toString().toLowerCase();

    return success == 1 ||
        success == '1' ||
        success == true ||
        status == 1 ||
        status == '1' ||
        status == true ||
        status == 'success' ||
        message.contains('password updated') ||
        message.contains('password changed');
  }

  String? _messageFromResponse(Map<String, dynamic> data) {
    return data['message']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set New Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Account: ${widget.email}\nID: ${widget.userId}',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 28),
              _passwordField(
                controller: _passwordController,
                label: 'New Password',
                isVisible: _showPassword,
                onToggle:
                    () => setState(() {
                      _showPassword = !_showPassword;
                    }),
              ),
              const SizedBox(height: 16),
              _passwordField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                isVisible: _showConfirmPassword,
                onToggle:
                    () => setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    }),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Please confirm password';
                  }
                  if (value!.trim() != _passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : const Text(
                            'Update Password',
                            style: TextStyle(
                              fontSize: 18,
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

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator:
          validator ??
          (value) {
            final password = value?.trim() ?? '';
            if (password.isEmpty) {
              return 'Please enter password';
            }
            if (password.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
    );
  }
}
