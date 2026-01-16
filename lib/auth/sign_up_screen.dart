import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<int> selectedCourseIds = [];
  double selectedCourseTotal = 0.0;
  String selectedCountryCode = "in";
  // Form state
  String? _selectedGender;
  String? _selectedMaritalStatus;
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  final List<String> _uploadTitles = [
    "Passport Size Photo",
    "Photo ID",
    "Residential Proof",
    "Education Qualification",
  ];

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
    // log("${ selectedCourseIds.join(",")}");
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
          Positioned(
            top: size.height * 0.15,
            left: 0,
            right: 0,
            child: _buildProgressIndicator(),
          ),
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
                        // if (_currentStep == 3) _buildUploadStep(uploadFiles),j
                        if (_currentStep == 3)
                          CourseSelectionScreen(
                            onSelectionDone: (ids, total, countryCode) {
                              setState(() {
                                selectedCourseIds = ids;
                                selectedCourseTotal = total;
                                selectedCountryCode = countryCode;
                              });
                            },
                          ),

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
          _buildProgressLine(),
          _buildProgressStep(3, "Courses"),
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
          "Please upload the following documents (Optional):",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),

        for (int i = 0; i < _uploadTitles.length; i++)
          _buildUploadCard(i, uploadFiles[i]),

        const SizedBox(height: 20),

        // ✅ SKIP BUTTON
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _currentStep = 3; // Jump to Course / Subscription step
              });
            },
            child: const Text(
              "SKIP DOCUMENT UPLOAD",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ),
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
    if (selectedCourseIds.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a course")));
      return;
    }

    _openPaymentGateway(); // ✅ FIRST payment
  }

  late Razorpay _razorpay;

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
    _razorpay.clear();
    super.dispose();
  }

  void _openPaymentGateway() {
    final isIndia = selectedCountryCode == "in";

    if (isIndia) {
      // 🇮🇳 Razorpay
      _razorpay.open({
        'key': razorpayKey,
        'amount': (selectedCourseTotal * 100).toInt(), // ✅ course amount
        'name': _firstNameController.text.trim(),
        'description': 'Course Registration Payment',
        'prefill': {
          'contact': _mobileController.text.trim(),
          'email': _emailController.text.trim(),
        },
      });
    } else {
      // 🌍 PayPal
      _startPayPalPayment(context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful"),
        backgroundColor: Colors.green,
      ),
    );

    // ✅ REGISTER AFTER PAYMENT
    final userId = await _callSignUpAPI();

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration failed")));
      return;
    }

    // ✅ CALLBACK AFTER REGISTER
    await sendPaymentToBackend(
      userId: userId,
      status: "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
      amount: selectedCourseTotal.toInt(),
    );
  }

  Future<String?> _callSignUpAPI() async {
    try {
      final uploadFiles = ref.read(uploadProvider.notifier).getFiles();

      final formData = {
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
        "image1": _fileToBase64(uploadFiles[0]),
        "image2": _fileToBase64(uploadFiles[1]),
        "image3": _fileToBase64(uploadFiles[2]),
        "image4": _fileToBase64(uploadFiles[3]),
        "courseId": selectedCourseIds.join(","),
      };

      final dio = Dio();
      final response = await dio.post(
        therapist,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      final json = response.data;

      if (json["success"] == 1) {
        return json["data"]["id"].toString(); // ✅ USER ID
      }
      return null;
    } catch (e) {
      debugPrint("Register error: $e");
      return null;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _startPayPalPayment(BuildContext context) {
    // String amount = amountController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: isSandboxMode,

              clientId: paypalClientId,
              secretKey: paypalSecret,

              /// ✅ ONLY AMOUNT – NO PRODUCT
              transactions: [
                {
                  "amount": {
                    "total": "${selectedCourseTotal}", 
                    "currency": "USD",
                  },
                  "description": "Wallet / Service Payment",
                },
              ],

              note: "Demo PayPal payment",

              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"]; // PAYID-XXXX

                debugPrint("PayPal Payment ID: $paypalPaymentId");

                // 🔒 Safety check
                if (paypalPaymentId == null) {
                  debugPrint("❌ PayPal paymentId null");
                  return;
                }
                final userId = await _callSignUpAPI();

                await sendPaymentToBackend(
                  userId: userId!,
                  status: "success",
                  paymentId: paypalPaymentId,
                  orderId: null, // PayPal मध्ये orderId नसतो
                  amount: selectedCourseTotal.toInt(),
                );

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PayPal Payment Successful"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // close popup

                Navigator.pop(context); // close PayPal screen
              },

              onError: (error) async {
                final userId = await _callSignUpAPI();

                await sendPaymentToBackend(
                  userId: userId!,
                  status: "failed",
                  reason: error.toString(),
                  amount: selectedCourseTotal.toInt(),
                );
                debugPrint("❌ PayPal Error: $error");

                Navigator.pop(context);
              },

              onCancel: () async {
                final userId = await _callSignUpAPI();

                await sendPaymentToBackend(
                  userId: userId!,
                  status: "failed",
                  reason: "Payment cancelled",
                  amount: selectedCourseTotal.toInt(),
                );
                debugPrint("⚠️ PayPal Cancelled");
                Navigator.pop(context);
              },
            ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  }

  Future<bool> isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type");
    return deliveryType == "india";
  }

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
          "email": _emailController.text.trim(),
          "name":
              "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
          "contact": _mobileController.text.trim(),
        },
      );
    } catch (e) {
      debugPrint("❌ Callback error: $e");
    }
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

class Course {
  final String code;
  final String title;
  final String amount;
  bool isSelected;

  Course({
    required this.code,
    required this.title,
    required this.amount,
    this.isSelected = false,
  });
}

class CourseSelectionScreen extends StatefulWidget {
  final Function(List<int> ids, double total, String countryCode)
  onSelectionDone;

  const CourseSelectionScreen({super.key, required this.onSelectionDone});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  List<Map<String, dynamic>> courses = [];
  bool isLoading = true;
  bool hasError = false;

  // Corrected: Changed return type to Future<String> for country
  Future<String> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type");
    return deliveryType == "india" ? "in" : "us";
  }

  // Toggle function removed as it's not being used in the current UI
  // void toggleCourseSelection(int index) {
  //   setState(() {
  //     courses[index].isSelected = !courses[index].isSelected;
  //   });
  // }

  @override
  void initState() {
    fetchCourses();
    // TODO: implement initState
    super.initState();
  }
  String countryCode = "in";
  Future<void> fetchCourses() async {
    try {
      // Get country code correctly
      countryCode = await getCountryCode();

      final response = await http.post(
        Uri.parse("https://admin.jinreflexology.in/api/courses/by-country"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"country": countryCode}),
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

            // 👇👇 इथेच हा line टाकायचा
            final total = (pricingForCountry?['total_price'] ?? 0).toDouble();

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

  void toggleCourseSelection(int index) {
    setState(() {
      for (int i = 0; i < courses.length; i++) {
        courses[i]["isSelected"] = i == index;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    print(countryCode);
    final currency = countryCode == "us" ? "\$" : "₹";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Courses',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (hasError)
          const Center(child: Text('Error loading courses'))
        else if (courses.isEmpty)
          const Center(child: Text('No courses available'))
        else
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: courses.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final course = courses[index];
              final isPopular = index % 3 == 0;
              final isSelected = course["isSelected"] ?? false;

              return Container(
                //  margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      color: isSelected ? Colors.blue[50] : Colors.white,
                      child: InkWell(
                        onTap: () {
                          // ✅ FIRST toggle selection
                          toggleCourseSelection(index);

                          // ⏳ UI update होईपर्यंत wait
                          Future.delayed(Duration.zero, () {
                            final selected =
                                courses
                                    .where((c) => c["isSelected"] == true)
                                    .toList();

                            if (selected.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select at least one course',
                                  ),
                                ),
                              );
                              return;
                            }

                            final ids =
                                selected
                                    .map<int>((e) => e["id"] as int)
                                    .toList();
                            final total = selected.fold<double>(
                              0,
                              (sum, e) => sum + (e["total"] as double),
                            );

                            // ✅ SEND DATA TO PARENT
                            widget.onSelectionDone(ids, total, countryCode);
                          });
                        },

                        splashColor: Colors.blue.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Popular badge
                              if (isPopular)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Popular",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amber[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(height: isPopular ? 12 : 0),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Course Image
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[100],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          course['image'] != null &&
                                                  course['image']
                                                      .toString()
                                                      .isNotEmpty
                                              ? Image.network(
                                                course['image'].toString(),
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => Center(
                                                      child: Icon(
                                                        Icons.school_outlined,
                                                        size: 40,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                              )
                                              : Center(
                                                child: Icon(
                                                  Icons.school_outlined,
                                                  size: 40,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Course Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Title with selection indicator
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                course['title']?.toString() ??
                                                    'Untitled Course',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[900],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (isSelected)
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 6),

                                        // Description
                                        Text(
                                          course['description']?.toString() ??
                                              'No description available',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 12),

                                        // Price and Enroll Button Row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // Price
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "$currency${course['total']}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.green[800],
                                                ),
                                              ),
                                            ),

                                            // Selection/Enroll Button
                                            ElevatedButton(
                                              onPressed: () {
                                                final selected =
                                                    courses
                                                        .where(
                                                          (c) =>
                                                              c["isSelected"] ==
                                                              true,
                                                        )
                                                        .toList();

                                                if (selected.isEmpty) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Please select at least one course',
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                final ids =
                                                    selected
                                                        .map<int>(
                                                          (e) => e["id"] as int,
                                                        )
                                                        .toList();
                                                final total = selected
                                                    .fold<double>(
                                                      0,
                                                      (sum, e) =>
                                                          sum +
                                                          (e["total"]
                                                              as double),
                                                    );

                                                widget.onSelectionDone(
                                                  ids,
                                                  total,
                                                  countryCode,
                                                );
                                                // Toggle selection on button press
                                                toggleCourseSelection(index);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    isSelected
                                                        ? Colors.green
                                                        : Colors.blue,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 13,
                                                      vertical: 10,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                elevation: 0,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    isSelected
                                                        ? Icons.check
                                                        : Icons
                                                            .add_circle_outline,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    isSelected
                                                        ? "Selected"
                                                        : "Select",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
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

                              // Divider
                              if (index != courses.length - 1)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
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
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 20),
        // Container(
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     color: Colors.grey[100],
        //     borderRadius: BorderRadius.circular(12),
        //     border: Border.all(color: Colors.grey[300]!),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           const Text(
        //             'Selected Courses:',
        //             style: TextStyle(
        //               fontWeight: FontWeight.w500,
        //               color: Colors.grey,
        //             ),
        //           ),
        //           const SizedBox(height: 4),
        //           Text(
        //             '${courses.where((c) => c["isSelected"] == true).length} courses',
        //             style: const TextStyle(
        //               fontSize: 22,
        //               fontWeight: FontWeight.bold,
        //               color: Colors.blue,
        //             ),
        //           ),
        //         ],
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           final selectedCourses =
        //               courses.where((c) => c["isSelected"] == true).toList();
        //           if (selectedCourses.isEmpty) {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               const SnackBar(
        //                 content: Text('Please select at least one course'),
        //               ),
        //             );
        //           } else {
        //             // Navigate to next screen or process selection
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(
        //                 content: Text(
        //                   '${selectedCourses.length} courses selected',
        //                 ),
        //               ),
        //             );
        //             // TODO: Add navigation logic here
        //             // Navigator.push(context, MaterialPageRoute(builder: (_) => NextScreen()));
        //           }
        //         },
        //         style: ElevatedButton.styleFrom(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 32,
        //             vertical: 12,
        //           ),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //         ),
        //         child: const Text('Continue'),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
