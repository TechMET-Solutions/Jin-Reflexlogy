import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';


class AddPatientScreen extends StatefulWidget {
  @override
 State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  // ---------------- Controllers ----------------
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
  final bloodGroup = TextEditingController();

  String gender = "";
  String maritalStatus = "";

  final formKey = GlobalKey<FormState>();

  // ---------------- TextField Builder ----------------
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
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
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

Future<void> addPatient() async {
  if (!formKey.currentState!.validate()) return;

  if (gender.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Please select gender")));
    return;
  }

  if (maritalStatus.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Please select marital status")));
    return;
  }

  try {
final formData = FormData.fromMap({
  "address": address.text,
  "age": age.text,
  "bg": bloodGroup.text,
  "city": city.text,
  "country": country.text,
  "email": email.text,
  "gender": gender,
  "m_no": mobile.text,
  "mStatus": maritalStatus,
  "name": "${firstName.text} ${middleName.text} ${lastName.text}",
  "pid":"22",   // ⭐ MUST
  "pincode": postalCode.text,
  "state": stateC.text,
});


    final response = await ApiService().postRequest(
      "https://jinreflexology.in/api/add_patient.php",
      formData,
    );

    print("RAW RESPONSE: ${response?.data}");

    //---------------- JSON FIX ----------------//
    dynamic jsonBody;

    if (response?.data is String) {
      try {
        jsonBody = jsonDecode(response!.data);
      } catch (e) {
        throw Exception("Invalid JSON from server");
      }
    } else {
      jsonBody = response?.data;
    }
    //-------------------------------------------//

    print("PARSED JSON: $jsonBody");

    if (jsonBody != null && jsonBody["success"] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient Added Successfully")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonBody["message"] ?? "Failed to add patient")),
      );
    }
  } catch (e) {
    print("Add Patient Error: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
  }
}


  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF3DD),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xffF9CF63),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Add a Patient",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("First Name", firstName),
              buildTextField("Middle Name", middleName),
              buildTextField("Last Name", lastName),
              buildTextField("Email", email, keyboard: TextInputType.emailAddress),
              buildTextField("Age", age, keyboard: TextInputType.number),

              // ---------------- Gender + Marital ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gender"),
                  Text("Marital Status"),
                ],
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GENDER
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => gender = "Male"),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              gender == "Male" ? Colors.orange : Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text("Male"),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => gender = "Female"),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              gender == "Female" ? Colors.orange : Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text("Female"),
                    ],
                  ),

                  // MARITAL STATUS
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => maritalStatus = "Married"),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: maritalStatus == "Married"
                              ? Colors.orange
                              : Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text("Married"),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => maritalStatus = "Single"),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: maritalStatus == "Single"
                              ? Colors.orange
                              : Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text("Single"),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15),

              buildTextField("Country", country),
              buildTextField("State", stateC),
              buildTextField("City", city),
              buildTextField("Address", address),

              Row(
                children: [
                  Expanded(child: buildTextField("Code", code)),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildTextField(
                        "Mobile No", mobile, keyboard: TextInputType.phone),
                  ),
                ],
              ),

              buildTextField("Postal Code", postalCode,
                  keyboard: TextInputType.number),
              buildTextField("Blood Group", bloodGroup),

              SizedBox(height: 70),
            ],
          ),
        ),
      ),

      // ---------------- Bottom Buttons ----------------
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
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
                ),
                onPressed: addPatient,
                child: Text(
                  "Confirm",
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
