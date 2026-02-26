import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.userType});
  final String userType;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // API Details
  final String _apiUrl = 'https://jinreflexology.in/api1/new/forgotPassword.php';
  final String _userType = 'patient'; // Can be changed as needed

  Future<void> _submitEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create multipart request
        var request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
        
        // Add fields to the request
        request.fields['email'] = _emailController.text.trim();
        request.fields['type'] = _userType;
        
        // Send the request
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        
        // Parse response
        var responseData = json.decode(response.body);
        
        setState(() {
          _isLoading = false;
        });

        // Check response status
        if (response.statusCode == 200) {
          // Check if API returned success
          if (responseData['success'] == true || 
              responseData['status'] == 'success' ||
              responseData['message']?.contains('sent') == true) {
            
            // Show success message
            _showSnackBar(
              message: responseData['message'] ?? 
                      'Reset link sent to ${_emailController.text}',
              isSuccess: true,
            );
            
            // Optionally clear the field
            _emailController.clear();
          } else {
            // API returned error
            _showSnackBar(
              message: responseData['message'] ?? 
                      'Failed to send reset link. Please try again.',
              isSuccess: false,
            );
          }
        } else {
          // Server error
          _showSnackBar(
            message: 'Server error. Please try again later.',
            isSuccess: false,
          );
        }
      } catch (e) {
        // Network or other error
        setState(() {
          _isLoading = false;
        });
        
        _showSnackBar(
          message: 'Network error. Please check your connection.',
          isSuccess: false,
        );
        
        print('Error: $e');
      }
    }
  }

  void _showSnackBar({required String message, required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
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
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
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
                  
                  const SizedBox(height: 30),
                  
                  // Header Section
                  Text(
                    'Forgot\nPassword?',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  Text(
                    'Don\'t worry! It happens. Please enter your email address to reset your password.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading, // Disable while loading
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.blue.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // More robust email validation
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Extra Info
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remember your password? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: _isLoading 
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
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}