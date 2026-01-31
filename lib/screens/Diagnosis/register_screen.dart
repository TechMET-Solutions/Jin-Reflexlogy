import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
class AddPatientForm extends StatefulWidget {
  const AddPatientForm({super.key});

  @override
  State<AddPatientForm> createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final _formKey = GlobalKey<FormState>();

  String? gender;
  String? maritalStatus;
  String? bloodGroup;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController dealerId = TextEditingController();
  final TextEditingController postalCode = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CommonAppBar(title: "Add a Patient"),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("First Name*", firstName, required: true),
                  _buildTextField("Middle Name", middleName),
                  _buildTextField("Last Name*", lastName, required: true),
                  _buildTextField("Email",email,inputType: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  _buildCard(
                    title: "Gender*",
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text("Male"),
                          value: "Male",
                          groupValue: gender,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                        RadioListTile<String>(
                          title: const Text("Female"),
                          value: "Female",
                          groupValue: gender,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Marital Status Card
                  _buildCard(
                    title: "Marital Status*",
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text("Married"),
                          value: "Married",
                          groupValue: maritalStatus,
                          onChanged:
                              (value) => setState(() => maritalStatus = value),
                        ),
                        RadioListTile<String>(
                          title: const Text("Single"),
                          value: "Single",
                          groupValue: maritalStatus,
                          onChanged:
                              (value) => setState(() => maritalStatus = value),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildTextField("Age", age, inputType: TextInputType.number),
                  _buildTextField("Country*", country, required: true),
                  _buildTextField("State*", state, required: true),
                  _buildTextField("City*", city, required: true),
                  _buildTextField("Address*", address, required: true),
                  _buildTextField(
                    "Mobile No*",
                    mobile,
                    required: true,
                    inputType: TextInputType.phone,
                  ),
                  _buildTextField("Dealer ID (Optional)", dealerId),
                  _buildTextField("Postal Code*", postalCode, required: true),

                  const SizedBox(height: 10),

                  // Blood Group Dropdown
                  DropdownButtonFormField<String>(
                    value: bloodGroup,
                    items:
                        bloodGroups
                            .map(
                              (bg) =>
                                  DropdownMenuItem(value: bg, child: Text(bg)),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => bloodGroup = value),
                    decoration: _inputDecoration("Blood Group"),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Button Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    label: "CANCEL",
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildButton(
                    label: "CONFIRM",
                    color: Colors.green,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Patient Added Successfully ✅"),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧱 Common TextField
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: _inputDecoration(label),
        validator:
            required
                ? (value) => value!.isEmpty ? "Field can't be empty" : null
                : null,
      ),
    );
  }

  // 🎨 Input field style
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
    );
  }

  // 🪶 Card container for gender/marital
  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  // ✅ Buttons
  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
