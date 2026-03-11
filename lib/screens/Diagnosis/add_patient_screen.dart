import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:jin_reflex_new/widgets/offline_country_state_city_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPatientScreen extends ConsumerStatefulWidget {
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
  ConsumerState<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends ConsumerState<AddPatientScreen> {
  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final age = TextEditingController();
  final address = TextEditingController();
  final code = TextEditingController();
  final mobile = TextEditingController();
  final postalCode = TextEditingController();

  String? selectedBloodGroup = "A+";
  String? gender;
  String? maritalStatus;
  bool isLoading = false;
  bool isLoadingStates = false;
  bool isLoadingCities = false;

  // Location dropdown variables
  List<csc.Country> countries = [];
  List<csc.State> states = [];
  List<csc.City> cities = [];
  csc.Country? selectedCountry;
  csc.State? selectedState;
  csc.City? selectedCity;
  String countryCode = "+91";

  final formKey = GlobalKey<FormState>();

  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();
  String savedAmount = "0";
  bool showValidation = false;

  // Debouncing timers
  Timer? _statesTimer;
  Timer? _citiesTimer;

  @override
  void initState() {
    super.initState();
    _loadCountries();

    ref.refresh(
      therapistBalanceProvider(
        AppPreference().getString(PreferencesKey.userId).toString(),
      ),
    );

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _statesTimer?.cancel();
    _citiesTimer?.cancel();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Success\nPayment ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );

    await sendPaymentToBackend(
      status: "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
      amount: int.parse(amountController.text),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );

    await sendPaymentToBackend(
      status: "failed",
      reason: response.message,
      amount: int.parse(amountController.text),
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

  void _showPaymentPopup() {
    amountController.clear();
    showValidation = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<bool>(
          future: isIndianUser(),
          builder: (context, snapshot) {
            final bool isIndia = snapshot.data ?? true;

            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Insufficient Balance',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please add money to continue',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Amount ${isIndia ? "(₹)" : "(\$)"}',
                          border: const OutlineInputBorder(),
                          errorText:
                              showValidation ? 'Minimum 50 required' : null,
                        ),
                        onChanged: (_) {
                          if (showValidation) {
                            setState(() => showValidation = false);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final amountText = amountController.text.trim();

                        if (amountText.isEmpty ||
                            int.tryParse(amountText) == null ||
                            int.parse(amountText) < 50) {
                          setState(() => showValidation = true);
                          return;
                        }

                        final int rupees = int.parse(amountText);

                        Navigator.pop(context);

                        if (isIndia) {
                          _razorpay.open({
                            'key': razorpayKey,
                            'amount': rupees * 100,
                            'name': AppPreference().getString(
                              PreferencesKey.name,
                            ),
                            'description': 'Service Payment',
                            'prefill': {
                              'contact': AppPreference().getString(
                                PreferencesKey.contactNumber,
                              ),
                              'email': AppPreference().getString(
                                PreferencesKey.email,
                              ),
                            },
                          });
                        } else {
                          _startPayPalPayment(context);
                        }
                      },
                      child: const Text('Pay'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _startPayPalPayment(BuildContext context) {
    String amount = amountController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaypalCheckoutView(
          sandboxMode: isSandboxMode,
          clientId: paypalClientId,
          secretKey: paypalSecret,
          transactions: [
            {
              "amount": {
                "total": amount,
                "currency": "USD",
              },
              "description": "Wallet / Service Payment",
            },
          ],
          note: "Demo PayPal payment",
          onSuccess: (Map params) async {
            final paypalPaymentId = params["data"]?["id"];

            debugPrint("PayPal Payment ID: $paypalPaymentId");

            if (paypalPaymentId == null) {
              debugPrint("❌ PayPal paymentId null");
              return;
            }

            await sendPaymentToBackend(
              status: "success",
              paymentId: paypalPaymentId,
              orderId: null,
              amount: int.parse(amountController.text),
            );

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("PayPal Payment Successful"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onError: (error) async {
            await sendPaymentToBackend(
              status: "failed",
              reason: error.toString(),
              amount: int.parse(amountController.text),
            );
            debugPrint("❌ PayPal Error: $error");

            Navigator.pop(context);
          },
          onCancel: () async {
            debugPrint("⚠️ PayPal Cancelled");
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> sendPaymentToBackend({
    required String status,
    String? paymentId,
    String? orderId,
    String? reason,
    required int amount,
  }) async {
    try {
      final dio = Dio();
      var postData = {
        "user_id": AppPreference().getString(PreferencesKey.userId),
        "payment_id": paymentId,
        "orderid": orderId,
        "amount": amount.toString(),
        "status": status,
        "email": AppPreference().getString(PreferencesKey.email),
        "name": AppPreference().getString(PreferencesKey.name),
        "contact": AppPreference().getString(PreferencesKey.contactNumber),
      };
      log("$postData");
      final response = await dio.post(
        "https://admin.jinreflexology.in/api/payment_callback",
        data: postData,
      );

      debugPrint("✅ Payment sent to backend: ${response.data}");
    } catch (e) {
      debugPrint("❌ Backend API error: $e");
    }
  }

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
            validator: (value) =>
                value == null || value.isEmpty ? "$label is required" : null,
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
            items: bloodGroups
                .map((String group) => DropdownMenuItem<String>(
                      value: group,
                      child: Text(group),
                    ))
                .toList(),
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
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search country...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            itemAsString: (csc.Country country) => country.name,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select Country",
              ),
            ),
            onChanged: (csc.Country? value) async {
              if (value == null) return;
              
              setState(() {
                selectedCountry = value;
                selectedState = null;
                selectedCity = null;
                states = [];
                cities = [];
                countryCode = "+" + (value.phoneCode ?? "91");
                code.text = countryCode;
              });
              
              await _loadStates();
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
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search state...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            itemAsString: (csc.State state) => state.name,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                hintText: "Select State",
              ),
            ),
            onChanged: (csc.State? value) async {
              if (value == null) return;
              
              setState(() {
                selectedState = value;
                selectedCity = null;
                cities = [];
              });
              
              await _loadCities();
            },
            enabled: selectedCountry != null && !isLoadingStates,
            validator: (value) {
              if (selectedCountry != null && (value == null || states.isEmpty)) {
                return "State is required";
              }
              return null;
            },
          ),
        ),
        if (isLoadingStates)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                SizedBox(width: 12),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffF9CF63)),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Loading states...",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
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
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search city...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
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
            enabled: selectedState != null && !isLoadingCities,
            validator: (value) {
              if (selectedState != null && (value == null || cities.isEmpty)) {
                return "City is required";
              }
              return null;
            },
          ),
        ),
        if (isLoadingCities)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                SizedBox(width: 12),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffF9CF63)),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Loading cities...",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        SizedBox(height: 12),
      ],
    );
  }

  Future<void> _loadCountries() async {
    try {
      final allCountries = await csc.getAllCountries();
      if (!mounted) return;

      setState(() {
        countries = allCountries;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading countries: $e")),
        );
      }
    }
  }

  Future<void> _loadStates() async {
    if (selectedCountry == null) return;
    
    // Cancel previous timer
    _statesTimer?.cancel();
    
    setState(() {
      isLoadingStates = true;
      states = [];
      selectedState = null;
      cities = [];
      selectedCity = null;
    });
    
    try {
      final newStates = await csc.getStatesOfCountry(selectedCountry!.isoCode);
      if (mounted) {
        setState(() {
          states = newStates;
          isLoadingStates = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingStates = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading states: $e")),
        );
      }
    }
  }

  Widget buildOfflineLocationDropdown() {
    return OfflineCountryStateCityWidget(
      initialCountry: selectedCountry?.name,
      initialState: selectedState?.name,
      initialCity: selectedCity?.name,
      onChanged: (country, state, city) {
        setState(() {
          if (country == null || country.isEmpty) {
            selectedCountry = null;
            selectedState = null;
            selectedCity = null;
            countryCode = "+91";
            code.text = countryCode;
            return;
          }

          final matchedCountry = countries.where((c) => c.name == country).toList();
          if (matchedCountry.isNotEmpty) {
            selectedCountry = matchedCountry.first;
            countryCode = "+${selectedCountry!.phoneCode}";
            code.text = countryCode;
          } else {
            selectedCountry = csc.Country(
              name: country,
              isoCode: '',
              phoneCode: '91',
              flag: '',
              currency: '',
              latitude: '',
              longitude: '',
            );
            countryCode = "+91";
            code.text = countryCode;
          }

          selectedState = (state == null || state.isEmpty)
              ? null
              : csc.State(
                  name: state,
                  countryCode: selectedCountry?.isoCode ?? '',
                  isoCode: '',
                );

          selectedCity = (city == null || city.isEmpty)
              ? null
              : csc.City(
                  name: city,
                  countryCode: selectedCountry?.isoCode ?? '',
                  stateCode: selectedState?.isoCode ?? '',
                );
        });
      },
    );
  }

  Future<void> _loadCities() async {
    if (selectedCountry == null || selectedState == null) return;
    
    // Cancel previous timer
    _citiesTimer?.cancel();
    
    setState(() {
      isLoadingCities = true;
      cities = [];
      selectedCity = null;
    });
    
    try {
      // getStateCities can return empty on some datasets.
      List<csc.City> newCities = await csc.getStateCities(
        selectedCountry!.isoCode,
        selectedState!.isoCode,
      );

      if (newCities.isEmpty) {
        final allCountryCities = await csc.getCountryCities(
          selectedCountry!.isoCode,
        );
        final byStateCode = allCountryCities
            .where((city) => city.stateCode == selectedState!.isoCode)
            .toList();

        // Last fallback: show all country cities if mapping is missing.
        newCities = byStateCode.isNotEmpty ? byStateCode : allCountryCities;
      }

      if (mounted) {
        setState(() {
          cities = newCities;
          isLoadingCities = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCities = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading cities: $e")),
        );
      }
    }
  }

  Future<Map<String, String>?> addPatient() async {
    debugPrint("=== STARTING addPatient METHOD ===");

    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      debugPrint("ERROR: Form validation failed");
      return null;
    }
    debugPrint("SUCCESS: Form validation passed");

    if (gender == null || gender!.isEmpty) {
      debugPrint("ERROR: Gender not selected");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select gender")),
      );
      return null;
    }
    debugPrint("SUCCESS: Gender selected - $gender");

    if (maritalStatus == null || maritalStatus!.isEmpty) {
      debugPrint("ERROR: Marital status not selected");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select marital status")),
      );
      return null;
    }
    debugPrint("SUCCESS: Marital status selected - $maritalStatus");

    if (selectedCountry == null ||
        selectedState == null ||
        selectedCity == null ||
        selectedCountry!.name.isEmpty ||
        selectedState!.name.isEmpty ||
        selectedCity!.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select country, state and city")),
      );
      return null;
    }

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

      debugPrint("=== FORM DATA FIELDS ===");
      for (var field in formData.fields) {
        debugPrint("${field.key} : ${field.value}");
      }
      debugPrint("=== END FORM DATA FIELDS ===");

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
          debugPrint("SUCCESS: JSON decoded successfully$jsonBody");
        } catch (jsonError) {
          debugPrint("ERROR: Failed to decode JSON - $jsonError");
          debugPrint("ERROR: Response appears to be HTML or invalid JSON");
          debugPrint("ERROR: Full response data: ${response?.data}");
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
        ref.refresh(
          therapistBalanceProvider(
            AppPreference().getString(PreferencesKey.userId).toString(),
          ),
        );

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
        _showPaymentPopup();

        debugPrint("ERROR: API response success != 1 or null response");

        debugPrint(
          "ERROR: Response ss - ${jsonBody?["message"] ?? "No message"}",
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
    final userId = AppPreference().getString(PreferencesKey.userId).toString();
    return WillPopScope(
      onWillPop: () async {
        return await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Confirm Exit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: const Text(
                    "Your data will not be saved if you go back.\nAre you sure you want to exit?",
                    style: TextStyle(fontSize: 15, height: 1.4),
                  ),
                  actionsPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  actions: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFDF3DD),
        appBar: CommonAppBar(
          title: "Add a Patient",
          showBalance: true,
          userId: userId,
        ),
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

                    buildOfflineLocationDropdown(),
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

                    buildDropdownField(),

                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),

            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xffF9CF63),
                    ),
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
                  onPressed: isLoading
                      ? null
                      : () async {
                          final result = await addPatient();

                          if (result != null &&
                              result["id"] != null &&
                              result["id"]!.isNotEmpty) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DiagnosisScreen(
                                  patient_id: result["id"],
                                  name: result["name"],
                                  diagnosis_id: widget.diagnosisId,
                                ),
                              ),
                            );
                          }
                        },
                  child: isLoading
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
      ),
    );
  }
}
