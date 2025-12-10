import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/urls.dart';

import 'package:jin_reflex_new/model/dignosis_list_model.dart';
import 'package:jin_reflex_new/screens/Diagnosis/add_patient_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/Diagnosis/tritment_screen.dart';

class MemberListScreen extends StatefulWidget {
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  List<PatientData> patients = [];
  List<PatientData> filteredPatients = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  // ---------------- SEARCH FUNCTION ----------------
  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPatients = patients;
      });
      return;
    }

    final search = query.toLowerCase();

    setState(() {
      filteredPatients = patients.where((p) {
        return p.name.toLowerCase().contains(search) ||
               p.mobile.contains(query);
      }).toList();
    });
  }

  // ---------------- API CALL ----------------
  Future<void> fetchPatients() async {
    try {
      final response = await ApiService().postRequest(
        "https://jinreflexology.in/api/list_patients.php?pid=22",
        {},
      );

      if (response?.statusCode == 200) {

        dynamic jsonBody;

        if (response?.data is String) {
          jsonBody = jsonDecode(response?.data);
        } else {
          jsonBody = response?.data;
        }

        final raw = jsonBody['data'];

        List<PatientData> diagnosisLists = [];

        if (raw is List) {
          diagnosisLists = raw.map((e) => PatientData.fromJson(e)).toList();
        } else if (raw is Map) {
          diagnosisLists = raw.values.map((e) => PatientData.fromJson(e)).toList();
        }

        setState(() {
          patients = diagnosisLists;
          filteredPatients = diagnosisLists;   // <-- For search
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3DD),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ---------------- SEARCH + ADD BUTTON ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(Icons.search, color: Colors.orange, size: 26),
                          const SizedBox(width: 8),

                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: filterSearch,
                              decoration: const InputDecoration(
                                hintText: "Search name or mobile...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  InkWell(

                    onTap: (){
                      
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => AddPatientScreen()),
                                );
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: const Icon(Icons.add, color: Colors.orange, size: 28),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- PATIENT LIST ----------------
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : filteredPatients.isEmpty
                      ? const Center(
                          child: Text(
                            "No Patients Found",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          itemCount: filteredPatients.length,
                          itemBuilder: (context, index) {
                            final patient = filteredPatients[index];

                            return InkWell(
                              onTap: () {
                                
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => DiagnosisListScreen(patientName: patient.name,pid: "22",diagnosisId:patient.id ,patientId: patient.id,)),
                                );
                                
                              },
                              child: listItem(
                                id: patient.id,
                                name: patient.name,
                                phone: patient.mobile,
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Single Item UI ----------------
  Widget listItem({
    required String id,
    required String name,
    required String phone,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Text(
            phone,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

