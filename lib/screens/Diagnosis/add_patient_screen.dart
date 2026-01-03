import 'dart:convert';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

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
  final address = TextEditingController();
  final code = TextEditingController();
  final mobile = TextEditingController();
  final postalCode = TextEditingController();

  String? selectedBloodGroup;
  String? gender;
  String? maritalStatus;
  bool isLoading = false;

  // Location dropdown variables
  List<csc.Country> countries = [];
  List<csc.State> states = [];
  List<csc.City> cities = [];
  csc.Country? selectedCountry;
  csc.State? selectedState;
  csc.City? selectedCity;
  String countryCode = "+91";

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

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

  Widget buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Country", style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffF9CF63), width: 1.5),
          ),
          child: DropdownSearch<csc.Country>(
            items: countries,
            selectedItem: selectedCountry,
            popupProps: PopupProps.menu(showSearchBox: true),
            itemAsString: (csc.Country country) => country.name,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select Country",
              ),
            ),
            onChanged: (csc.Country? value) {
              setState(() {
                selectedCountry = value;
                selectedState = null;
                selectedCity = null;
                countryCode = "+" + (value?.phoneCode ?? "91");
                code.text = countryCode;
              });
              if (value != null) {
                _loadStates();
              }
            },
            validator: (value) {
              if (value == null) {
                return "Country is required";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("State", style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffF9CF63), width: 1.5),
          ),
          child: DropdownSearch<csc.State>(
            items: states,
            selectedItem: selectedState,
            popupProps: PopupProps.menu(showSearchBox: true),
            itemAsString: (csc.State state) => state.name,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select State",
              ),
            ),
            onChanged: (csc.State? value) {
              setState(() {
                selectedState = value;
                selectedCity = null;
              });
              if (value != null) {
                _loadCities();
              }
            },
            validator: (value) {
              if (value == null) {
                return "State is required";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("City", style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffF9CF63), width: 1.5),
          ),
          child: DropdownSearch<csc.City>(
            items: cities,
            selectedItem: selectedCity,
            popupProps: PopupProps.menu(showSearchBox: true),
            itemAsString: (csc.City city) => city.name,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select City",
              ),
            ),
            onChanged: (csc.City? value) {
              setState(() {
                selectedCity = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return "City is required";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Future<void> _loadCountries() async {
    try {
      countries = await csc.getAllCountries();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading countries")));
    }
  }

  Future<void> _loadStates() async {
    if (selectedCountry == null) return;

    try {
      states = await csc.getStatesOfCountry(selectedCountry!.isoCode);
      setState(() {
        selectedState = null;
        cities = [];
        selectedCity = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading states")));
    }
  }

  Future<void> _loadCities() async {
    if (selectedCountry == null || selectedState == null) return;

    try {
      cities = await csc.getStateCities(
        selectedCountry!.isoCode,
        selectedState!.isoCode,
      );
      setState(() {
        selectedCity = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading cities")));
    }
  }

  Future<Map<String, String>?> addPatient() async {
    debugPrint("=== STARTING addPatient METHOD ===");

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate form
    if (!formKey.currentState!.validate()) {
      debugPrint("ERROR: Form validation failed");
      return null;
    }
    debugPrint("SUCCESS: Form validation passed");

    // Validate gender
    if (gender == null || gender!.isEmpty) {
      debugPrint("ERROR: Gender not selected");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select gender")));
      return null;
    }
    debugPrint("SUCCESS: Gender selected - $gender");

    // Validate marital status
    if (maritalStatus == null || maritalStatus!.isEmpty) {
      debugPrint("ERROR: Marital status not selected");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select marital status")));
      return null;
    }
    debugPrint("SUCCESS: Marital status selected - $maritalStatus");

    setState(() {
      isLoading = true;
    });
    debugPrint("INFO: Loading state set to true");

    try {
      final fullName =
          "${firstName.text} ${middleName.text} ${lastName.text}".trim();
      debugPrint("INFO: Full name constructed - $fullName");

      final formData = FormData.fromMap({
        "pid": AppPreference().getString(PreferencesKey.userId),
        "name": fullName,
        "email": email.text,
        "m_no": mobile.text,
        "address": address.text,
        "city": selectedCity?.name ?? '',
        "state": selectedState?.name ?? '',
        "country": selectedCountry?.name ?? '',
        "country_code": countryCode,
        "pincode": postalCode.text,
        "bg": selectedBloodGroup,
        "age": age.text,
        "gender": gender,
        "mStatus": maritalStatus,
      });

      // Log all individual form fields
      debugPrint("=== FORM DATA FIELDS ===");
      for (var field in formData.fields) {
        debugPrint("${field.key} : ${field.value}");
      }
      debugPrint("=== END FORM DATA FIELDS ===");

      debugPrint("INFO: Form data prepared - ${formData.fields}");

      debugPrint("INFO: Making API request to $add_patient");
      final response = await ApiService().postRequest(add_patient, formData);
      debugPrint(
        "INFO: API response received - Status: ${response?.statusCode}",
      );
      debugPrint("DEBUG: Raw response data - ${response?.data}");

      dynamic jsonBody;
      if (response?.data is String) {
        debugPrint("INFO: Response data is String, attempting to decode JSON");
        try {
          jsonBody = jsonDecode(response!.data);
          debugPrint("SUCCESS: JSON decoded successfully");
        } catch (jsonError) {
          debugPrint("ERROR: Failed to decode JSON - $jsonError");
          debugPrint("ERROR: Response appears to be HTML or invalid JSON");
          debugPrint("ERROR: Full response data: ${response?.data}");
          // If it's HTML, set jsonBody to null or handle accordingly
          jsonBody = {
            "success": 0,
            "message": "Invalid response format from server",
          };
        }
      } else {
        debugPrint("INFO: Response data is already JSON");
        jsonBody = response?.data;
      }
      debugPrint("INFO: Final parsed body - $jsonBody");

      setState(() {
        isLoading = false;
      });
      debugPrint("INFO: Loading state set to false");

      if (jsonBody != null && jsonBody["success"] == 1) {
        debugPrint("SUCCESS: API response success = 1");

        /// 🔥 API RESPONSE SE DATA NIKALO
        final String patientId = jsonBody["data"]?["id"]?.toString() ?? "";
        final String patientName =
            jsonBody["data"]?["name"]?.toString() ?? fullName;

        debugPrint("INFO: Patient ID - $patientId");
        debugPrint("INFO: Patient Name - $patientName");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Patient Added Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        return {"id": patientId, "name": patientName};
      } else {
        debugPrint("ERROR: API response success != 1 or null response");
        debugPrint(
          "ERROR: Response message - ${jsonBody?["message"] ?? "No message"}",
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonBody?["message"] ?? "Failed to add patient"),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      debugPrint("ERROR: Exception occurred in addPatient - $e");
      debugPrint("ERROR: Stack trace - ${StackTrace.current}");

      setState(() {
        isLoading = false;
      });
      debugPrint("INFO: Loading state set to false due to error");

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

                  buildCountryDropdown(),
                  buildStateDropdown(),
                  buildCityDropdown(),
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
