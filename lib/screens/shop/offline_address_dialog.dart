import 'package:flutter/material.dart';
import 'package:jin_reflex_new/widgets/offline_country_state_city_widget.dart';

class OfflineAddressDialog extends StatefulWidget {
  const OfflineAddressDialog({Key? key}) : super(key: key);

  @override
  State<OfflineAddressDialog> createState() => _OfflineAddressDialogState();
}

class _OfflineAddressDialogState extends State<OfflineAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String selectedType = "home";
  bool isDefault = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 19, 4, 66),
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
    );
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCountry == null || selectedCountry!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a country"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedState == null || selectedState!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a state"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedCity == null || selectedCity!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a city"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final addressData = {
      'name': nameController.text,
      'phone': phoneController.text,
      'address_line1': address1Controller.text,
      'address_line2': address2Controller.text,
      'country': selectedCountry,
      'state': selectedState,
      'city': selectedCity,
      'pincode': pincodeController.text,
      'type': selectedType,
      'is_default': isDefault,
    };

    Navigator.pop(context, addressData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Address Saved!\n"
          "Country: $selectedCountry\n"
          "State: $selectedState\n"
          "City: $selectedCity",
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add New Address",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 19, 4, 66),
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address Type",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("Home"),
                      selected: selectedType == "home",
                      onSelected: (selected) {
                        setState(() => selectedType = "home");
                      },
                      selectedColor: const Color.fromARGB(255, 19, 4, 66),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: selectedType == "home"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("Work"),
                      selected: selectedType == "work",
                      onSelected: (selected) {
                        setState(() => selectedType = "work");
                      },
                      selectedColor: const Color.fromARGB(255, 19, 4, 66),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: selectedType == "work"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("Other"),
                      selected: selectedType == "other",
                      onSelected: (selected) {
                        setState(() => selectedType = "other");
                      },
                      selectedColor: const Color.fromARGB(255, 19, 4, 66),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: selectedType == "other"
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: CheckboxListTile(
                  title: const Text(
                    "Set as default address",
                    style: TextStyle(fontSize: 14),
                  ),
                  value: isDefault,
                  onChanged: (value) {
                    setState(() => isDefault = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: _buildInputDecoration(
                  label: "Full Name *",
                  hint: "Enter your full name",
                  icon: Icons.person,
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: _buildInputDecoration(
                  label: "Phone Number *",
                  hint: "Enter 10-digit mobile number",
                  icon: Icons.phone,
                ).copyWith(
                  counterText: "",
                  prefix: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Text("+91 "),
                  ),
                ),
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  if (v.length != 10) return "10 digits required";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: address1Controller,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  label: "Address Line 1 *",
                  hint: "House no, Building, Street",
                  icon: Icons.home,
                ),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: address2Controller,
                maxLines: 2,
                decoration: _buildInputDecoration(
                  label: "Address Line 2 (Optional)",
                  hint: "Apartment, Floor, Landmark",
                  icon: Icons.location_on,
                ),
              ),
              const SizedBox(height: 16),
              OfflineCountryStateCityWidget(
                initialCountry: selectedCountry,
                initialState: selectedState,
                initialCity: selectedCity,
                onChanged: (country, state, city) {
                  setState(() {
                    selectedCountry = country;
                    selectedState = state;
                    selectedCity = city;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: _buildInputDecoration(
                  label: "Pincode *",
                  hint: "Enter 6-digit pincode",
                  icon: Icons.pin_drop,
                ).copyWith(counterText: ""),
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  if (v.length != 6) return "6 digits required";
                  return null;
                },
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "* Required fields",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
        ElevatedButton(
          onPressed: _saveAddress,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 19, 4, 66),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          child: const Text(
            "Save Address",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// Example usage in your screen
class ExampleUsage extends StatelessWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const OfflineAddressDialog(),
    ).then((addressData) {
      if (addressData != null) {
        print("Address saved: $addressData");
        // Use the returned data
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline Address Form"),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showAddressDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 19, 4, 66),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text("Open Address Dialog"),
        ),
      ),
    );
  }
}
