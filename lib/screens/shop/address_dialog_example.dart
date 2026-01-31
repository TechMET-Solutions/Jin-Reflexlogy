import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/shop/country_state_city_widget.dart';

class AddressDialogExample extends StatefulWidget {
  const AddressDialogExample({Key? key}) : super(key: key);

  @override
  State<AddressDialogExample> createState() => _AddressDialogExampleState();
}

class _AddressDialogExampleState extends State<AddressDialogExample> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Form Example"),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showAddressDialog(),
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

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                              selectedColor:
                                  const Color.fromARGB(255, 19, 4, 66),
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
                              selectedColor:
                                  const Color.fromARGB(255, 19, 4, 66),
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
                              selectedColor:
                                  const Color.fromARGB(255, 19, 4, 66),
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
                      Text(
                        "Full Name *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter your full name",
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
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Phone Number *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: "Enter 10-digit mobile number",
                          counterText: "",
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
                      Text(
                        "Address Line 1 *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: address1Controller,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "House no, Building, Street",
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
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Address Line 2 (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: address2Controller,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "Apartment, Floor, Landmark",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CountryStateCityWidget(
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
                      Text(
                        "Pincode *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: "Enter 6-digit pincode",
                          counterText: "",
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
                        ),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (selectedCountry == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select country"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedState == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select state"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedCity == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select city"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Address Saved!\n"
                            "Name: ${nameController.text}\n"
                            "Phone: ${phoneController.text}\n"
                            "Address: ${address1Controller.text}\n"
                            "City: $selectedCity\n"
                            "State: $selectedState\n"
                            "Country: $selectedCountry\n"
                            "Pincode: ${pincodeController.text}",
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 4),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
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
          },
        );
      },
    );
  }
}
