import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/api_state.dart' hide ApiService;
import 'package:jin_reflex_new/api_service/preference/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/preference/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

class AddPatientScreen extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String pid;
  final String diagnosisId;

  AddPatientScreen({
    required this.patientName,
    required this.patientId,
    required this.pid,
    required this.diagnosisId,
  });
  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final age = TextEditingController();
  final country = TextEditingController();
  final stateC = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final code = TextEditingController();
  final mobile = TextEditingController();
  final postalCode = TextEditingController();

  String? selectedBloodGroup;
  String? gender;
  String? maritalStatus;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  // Blood groups list
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffF9CF63), width: 1.5),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboard,
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? "$label is required"
                        : null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter $label",
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget buildRadioOption(
    String title,
    String value,
    String groupValue,
    Function(String?) onChanged,
  ) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Color(0xffF9CF63),
        ),
        SizedBox(width: 4),
        Text(title),
      ],
    );
  }

  Widget buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Blood Group", style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffF9CF63), width: 1.5),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedBloodGroup,
            decoration: InputDecoration(border: InputBorder.none),
            hint: Text("Select Blood Group"),
            items:
                bloodGroups.map((String group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedBloodGroup = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Blood group is required";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Future<Map<String, String>?> addPatient() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!formKey.currentState!.validate()) {
      return null;
    }

    // Validate gender
    if (gender == null || gender!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select gender")));
      return null;
    }

    // Validate marital status
    if (maritalStatus == null || maritalStatus!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select marital status")));
      return null;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final fullName =
          "${firstName.text} ${middleName.text} ${lastName.text}".trim();

      final formData = FormData.fromMap({
        "address": address.text,
        "age": age.text,
        "bg": selectedBloodGroup ?? "",
        "city": city.text,
        "country": country.text,
        "email": email.text,
        "gender": gender,
        "m_no": mobile.text,
        "mStatus": maritalStatus,
        "name": fullName,
        "pid": AppPreference().getString(PreferencesKey.userId),
        "pincode": postalCode.text,
        "state": stateC.text,
      });

      final response = await ApiService().postRequest(add_patient, formData);

      dynamic jsonBody;
      if (response?.data is String) {
        jsonBody = jsonDecode(response!.data);
      } else {
        jsonBody = response?.data;
      }

      setState(() {
        isLoading = false;
      });

      if (jsonBody != null && jsonBody["success"] == 1) {
        /// 🔥 API RESPONSE SE DATA NIKALO
        final String patientId = jsonBody["data"]?["id"]?.toString() ?? "";
        final String patientName =
            jsonBody["data"]?["name"]?.toString() ?? fullName;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Patient Added Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        return {"id": patientId, "name": patientName};
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonBody["message"] ?? "Failed to add patient"),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF3DD),
      appBar: CommonAppBar(title: "Add a Patient"),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField("First Name", firstName),
                  buildTextField("Middle Name", middleName),
                  buildTextField("Last Name", lastName),
                  buildTextField(
                    "Email",
                    email,
                    keyboard: TextInputType.emailAddress,
                  ),
                  buildTextField("Age", age, keyboard: TextInputType.number),

                  // Gender Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          buildRadioOption("Male", "Male", gender ?? "", (
                            value,
                          ) {
                            setState(() {
                              gender = value;
                            });
                          }),
                          SizedBox(width: 20),
                          buildRadioOption("Female", "Female", gender ?? "", (
                            value,
                          ) {
                            setState(() {
                              gender = value;
                            });
                          }),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                  ),

                  // Marital Status Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Marital Status",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          buildRadioOption(
                            "Married",
                            "Married",
                            maritalStatus ?? "",
                            (value) {
                              setState(() {
                                maritalStatus = value;
                              });
                            },
                          ),
                          SizedBox(width: 20),
                          buildRadioOption(
                            "Single",
                            "Single",
                            maritalStatus ?? "",
                            (value) {
                              setState(() {
                                maritalStatus = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                    ],
                  ),

                  buildTextField("Country", country),
                  buildTextField("State", stateC),
                  buildTextField("City", city),
                  buildTextField("Address", address),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Code",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xffF9CF63),
                                  width: 1.5,
                                ),
                              ),
                              child: TextFormField(
                                controller: code,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "+91",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: buildTextField(
                          "Mobile No",
                          mobile,
                          keyboard: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),
                  buildTextField(
                    "Postal Code",
                    postalCode,
                    keyboard: TextInputType.number,
                  ),

                  buildDropdownField(), // Blood group dropdown

                  SizedBox(height: 70),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffF9CF63)),
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Color(0xFFFDF3DD),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF9CF63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          final result = await addPatient();

                          if (result != null &&
                              result["id"] != null &&
                              result["id"]!.isNotEmpty) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DiagnosisScreen(
                                      patient_id: result["id"],
                                      name: result["name"],
                                      diagnosis_id: widget.diagnosisId,
                                    ),
                              ),
                            );
                          }
                        },

                child:
                    isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                        : Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
