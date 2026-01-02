import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/urls.dart';

// Provider for managing upload state
final uploadProvider = StateNotifierProvider<UploadNotifier, List<File?>>((
  ref,
) {
  return UploadNotifier();
});

class UploadNotifier extends StateNotifier<List<File?>> {
  UploadNotifier() : super([null, null, null, null]);

  void setUpload(int index, File? file) {
    final newState = List<File?>.from(state);
    newState[index] = file;
    state = newState;
  }

  void clearUpload(int index) {
    final newState = List<File?>.from(state);
    newState[index] = null;
    state = newState;
  }

  List<File?> getFiles() {
    return state;
  }
}

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  // Form controllers - REMOVED keyword and playing controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();

  // Form state
  String? _selectedGender;
  String? _selectedMaritalStatus;
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Upload types - Now 4 images
  final List<String> _uploadTitles = [
    "Passport Size Photo",
    "Photo ID",
    "Residential Proof",
    "Education Qualification",
  ];

  // Validation functions
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    final mobileRegex = RegExp(r'^[0-9]{10}$');
    if (!mobileRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    final postalRegex = RegExp(r'^[0-9]{6}$');
    if (!postalRegex.hasMatch(value)) {
      return 'Enter a valid 6-digit postal code';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Convert File to base64
  String? _fileToBase64(File? file) {
    if (file == null) return null;
    try {
      final bytes = file.readAsBytesSync();
      return base64Encode(bytes);
    } catch (e) {
      print("Error converting file to base64: $e");
      return null;
    }
  }

  // API Call function
  Future<void> _callSignUpAPI() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      final uploadFiles = ref.read(uploadProvider.notifier).getFiles();

      // Prepare data - REMOVED keyword and hobby fields
      Map<String, dynamic> formData = {
        // -------- TEXT FIELDS --------
        "name":
            "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
        "email": _emailController.text.trim(),
        "gender": _selectedGender ?? "",
        "date": _dobController.text.trim(),
        "address": _addressController.text.trim(),
        "city": _cityController.text.trim(),
        "state": _stateController.text.trim(),
        "country": _countryController.text.trim(),
        "pincode": _postalCodeController.text.trim(),
        "maritalStatus": _selectedMaritalStatus ?? "",
        "m_no": _mobileController.text.trim(),
        "pid": "1",
        "education": _educationController.text.trim(),

        // -------- BASE64 IMAGES --------
        "image1": _fileToBase64(uploadFiles[0]),
        "image2": _fileToBase64(uploadFiles[1]),
        "image3": _fileToBase64(uploadFiles[2]),
        "image4": _fileToBase64(uploadFiles[3]),
      };

      // Remove null values
      formData.removeWhere((key, value) => value == null);

      print("Sending data to API...");
      print("Form Data Keys: ${formData.keys}");

      Dio dio = Dio();
      Response response = await dio.post(
       therapist,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("FULL RESPONSE: ${response.data}");

      // Handle response
      dynamic jsonBody;

      if (response.data is String) {
        try {
          jsonBody = jsonDecode(response.data);
        } catch (e) {
          jsonBody = response.data;
        }
      } else {
        jsonBody = response.data;
      }

      // Check for HTML response
      if (response.data.toString().contains('<!DOCTYPE html>') ||
          response.data.toString().contains('<html>')) {
        _showSuccessDialog(
          "Registration Submitted",
          "Your application has been received successfully.",
        );
        return;
      }

      String message = "";
      bool isSuccess = false;

      if (jsonBody is Map) {
        if (jsonBody['data'] != null) {
          final rawData = jsonBody['data'];
          if (rawData is Map) {
            message =
                rawData['message']?.toString() ??
                rawData['status']?.toString() ??
                "Success";
          } else if (rawData is String) {
            message = rawData;
          }
        }

        if (message.isEmpty && jsonBody['message'] != null) {
          message = jsonBody['message'].toString();
        }

        if (jsonBody['status'] != null) {
          final status = jsonBody['status'].toString().toLowerCase();
          isSuccess =
              status.contains('success') ||
              status.contains('true') ||
              status == '1';
        }

        if (jsonBody['error'] != null) {
          message = "Error: ${jsonBody['error']}";
          isSuccess = false;
        }
      }

      if (message.isEmpty) {
        message = response.data.toString();
      }

      if (isSuccess ||
          message.toLowerCase().contains('success') ||
          message.toLowerCase().contains('created') ||
          response.statusCode == 200) {
        _showSuccessDialog("Registration Successful!", message);
      } else {
        _showErrorDialog("Registration Failed", message);
      }
    } on DioException catch (e) {
      print("DIO ERROR: $e");
      _showErrorDialog(
        "Network Error",
        e.response?.data?.toString() ?? e.message ?? "Please try again",
      );
    } catch (e) {
      print("GENERAL ERROR: $e");
      _showErrorDialog("Error", e.toString());
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            // content: SingleChildScrollView(
            //   child: Text(message),
            // ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(child: Text(message)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final uploadFiles = ref.watch(uploadProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Purple Wave Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: SignUpWaveClipper(),
              child: Container(
                height: size.height * 0.2,
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

          // JIN Reflexology Title
          Positioned(
            top: size.height * 0.06,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "JIN REFLEXOLOGY",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

          // Progress Indicator
          Positioned(
            top: size.height * 0.15,
            left: 0,
            right: 0,
            child: _buildProgressIndicator(),
          ),

          // Main Form Container
          Positioned(
            top: size.height * 0.20,
            left: 16,
            right: 16,
            bottom: 16,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.2),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step Title
                        Center(
                          child: Column(
                            children: [
                              Text(
                                _currentStep == 0
                                    ? "PERSONAL INFORMATION"
                                    : _currentStep == 1
                                    ? "CONTACT DETAILS"
                                    : "UPLOAD DOCUMENTS",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 19, 4, 66),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _currentStep == 0
                                    ? "Fill in your personal details"
                                    : _currentStep == 1
                                    ? "Enter your contact information"
                                    : "Upload required documents",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Step Content
                        if (_currentStep == 0) _buildPersonalInfoStep(),
                        if (_currentStep == 1) _buildContactInfoStep(),
                        if (_currentStep == 2) _buildUploadStep(uploadFiles),

                        const SizedBox(height: 30),

                        // Navigation Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            if (_currentStep > 0)
                              ElevatedButton(
                                onPressed:
                                    _isSubmitting
                                        ? null
                                        : () {
                                          setState(() {
                                            _currentStep--;
                                          });
                                        },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  "BACK",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                              const SizedBox(width: 100),

                            // Next/Submit Button
                            ElevatedButton(
                              onPressed:
                                  _isSubmitting ? null : _handleNextButton,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  19,
                                  4,
                                  66,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                              ),
                              child:
                                  _isSubmitting
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text(
                                        _currentStep < 2 ? "NEXT" : "SUBMIT",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressStep(0, "Personal"),
          _buildProgressLine(),
          _buildProgressStep(1, "Contact"),
          _buildProgressLine(),
          _buildProgressStep(2, "Upload"),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int stepNumber, String label) {
    bool isActive = _currentStep == stepNumber;
    bool isCompleted = _currentStep > stepNumber;

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color:
                isActive || isCompleted
                    ? const Color.fromARGB(255, 191, 13, 22)
                    : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child:
                isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                      (stepNumber + 1).toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color:
                isActive
                    ? const Color.fromARGB(255, 19, 4, 66)
                    : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 15),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gender Selection
        Text(
          "Gender *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderRadio("Male"),
            const SizedBox(width: 15),
            _buildGenderRadio("Female"),
            const SizedBox(width: 15),
            _buildGenderRadio("Other"),
          ],
        ),
        // Show validation error only when user tries to submit
        const SizedBox(height: 5),
        const SizedBox(height: 20),

        // Name Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: "First Name *",
                prefixIcon: Icons.person_outline,
                validator: (value) => _validateName(value),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                label: "Last Name *",
                prefixIcon: Icons.person_outline,
                validator: (value) => _validateName(value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Marital Status (Radio buttons)
        Text(
          "Marital Status *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildMaritalRadio("Married"),
            const SizedBox(width: 15),
            _buildMaritalRadio("Unmarried"),
          ],
        ),
        // Show validation error only when user tries to submit
        const SizedBox(height: 5),
        const SizedBox(height: 20),

        // Date of Birth
        _buildTextField(
          controller: _dobController,
          label: "Date of Birth (DD/MM/YYYY) *",
          prefixIcon: Icons.calendar_today,
          onTap: () => _selectDate(context),
          readOnly: true,
          validator: (value) => _validateRequired(value, "Date of birth"),
        ),
        const SizedBox(height: 15),

        // Education Qualification
        _buildTextField(
          controller: _educationController,
          label: "Education Qualification",
          prefixIcon: Icons.school_outlined,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildContactInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        _buildTextField(
          controller: _emailController,
          label: "Email *",
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),
        const SizedBox(height: 15),

        // Mobile Number
        _buildTextField(
          controller: _mobileController,
          label: "Mobile Number *",
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: _validateMobile,
        ),
        const SizedBox(height: 15),

        // Address
        _buildTextField(
          controller: _addressController,
          label: "Address *",
          prefixIcon: Icons.home_outlined,
          maxLines: 2,
          validator: (value) => _validateRequired(value, "Address"),
        ),
        const SizedBox(height: 15),

        // City & State Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _cityController,
                label: "City *",
                prefixIcon: Icons.location_city_outlined,
                validator: (value) => _validateRequired(value, "City"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTextField(
                controller: _stateController,
                label: "State *",
                prefixIcon: Icons.map_outlined,
                validator: (value) => _validateRequired(value, "State"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        // Country & Postal Code Row
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _countryController,
                label: "Country *",
                prefixIcon: Icons.public_outlined,
                validator: (value) => _validateRequired(value, "Country"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTextField(
                controller: _postalCodeController,
                label: "Postal Code *",
                prefixIcon: Icons.numbers_outlined,
                keyboardType: TextInputType.number,
                validator: _validatePostalCode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadStep(List<File?> uploadFiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Please upload the following documents:",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),

        for (int i = 0; i < _uploadTitles.length; i++)
          _buildUploadCard(i, uploadFiles[i]),
      ],
    );
  }

  Widget _buildUploadCard(int index, File? file) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: const Color.fromARGB(255, 19, 4, 66),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _uploadTitles[index],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (file != null)
              _buildFilePreview(file, index)
            else
              _buildUploadButton(index),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(File file, int index) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[100]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file.path.split('/').last,
                  style: TextStyle(fontSize: 12, color: Colors.green[800]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                onPressed: () {
                  ref.read(uploadProvider.notifier).clearUpload(index);
                },
                iconSize: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _uploadDocument(index),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 19, 4, 66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(double.infinity, 40),
          ),
          child: const Text(
            "REPLACE FILE",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton(int index) {
    return ElevatedButton(
      onPressed: () => _uploadDocument(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 19, 4, 66),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: const Color.fromARGB(255, 19, 4, 66)),
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_upload_outlined, size: 20),
          const SizedBox(width: 10),
          Text(
            "UPLOAD ${_uploadTitles[index].toUpperCase()}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderRadio(String gender) {
    bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? const Color.fromARGB(255, 19, 4, 66)
                    : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected
                  ? const Color.fromARGB(255, 19, 4, 66).withOpacity(0.05)
                  : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: gender,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                activeColor: const Color.fromARGB(255, 19, 4, 66),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(
                gender,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected
                          ? const Color.fromARGB(255, 19, 4, 66)
                          : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaritalRadio(String status) {
    return Row(
      children: [
        Radio<String>(
          value: status,
          groupValue: _selectedMaritalStatus,
          onChanged: (value) {
            setState(() {
              _selectedMaritalStatus = value;
            });
          },
          activeColor: const Color.fromARGB(255, 19, 4, 66),
        ),
        Text(status, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 19, 4, 66)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 19, 4, 66),
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 19, 4, 66),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _uploadDocument(int index) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    ref
                        .read(uploadProvider.notifier)
                        .setUpload(index, File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    ref
                        .read(uploadProvider.notifier)
                        .setUpload(index, File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNextButton() {
    if (_currentStep < 2) {
      // Validate current step
      if (_currentStep == 0) {
        // Step 1 validation - Only show errors when user tries to submit
        bool hasErrors = false;
        String errorMessage = "";

        if (_firstNameController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "First Name, ";
        }
        if (_lastNameController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "Last Name, ";
        }
        if (_dobController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "Date of Birth, ";
        }
        if (_selectedGender == null) {
          hasErrors = true;
          errorMessage += "Gender, ";
        }
        if (_selectedMaritalStatus == null) {
          hasErrors = true;
          errorMessage += "Marital Status, ";
        }

        if (hasErrors) {
          errorMessage = errorMessage.substring(0, errorMessage.length - 2);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      } else if (_currentStep == 1) {
        // Step 2 validation - Only show errors when user tries to submit
        bool hasErrors = false;
        String errorMessage = "";

        if (_emailController.text.isEmpty ||
            !_emailController.text.contains('@')) {
          hasErrors = true;
          errorMessage += "Valid Email, ";
        }
        if (_mobileController.text.isEmpty ||
            _mobileController.text.length != 10) {
          hasErrors = true;
          errorMessage += "10-digit Mobile, ";
        }
        if (_addressController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "Address, ";
        }
        if (_cityController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "City, ";
        }
        if (_stateController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "State, ";
        }
        if (_countryController.text.isEmpty) {
          hasErrors = true;
          errorMessage += "Country, ";
        }
        if (_postalCodeController.text.isEmpty ||
            _postalCodeController.text.length != 6) {
          hasErrors = true;
          errorMessage += "6-digit Postal Code, ";
        }

        if (hasErrors) {
          errorMessage = errorMessage.substring(0, errorMessage.length - 2);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      setState(() {
        _currentStep++;
      });
    } else {
      // Submit form
      _submitForm();
    }
  }

  void _submitForm() {
    final uploadFiles = ref.read(uploadProvider);
    final hasAllUploads = uploadFiles.every((file) => file != null);

    if (!hasAllUploads) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all 4 required documents'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call API
    _callSignUpAPI();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _educationController.dispose();
    super.dispose();
  }
}

/// Custom clipper for Sign Up screen wave
class SignUpWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.8);

    final firstControlPoint = Offset(size.width * 0.3, size.height * 0.9);
    final firstEndPoint = Offset(size.width * 0.6, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.8, size.height * 0.7);
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
