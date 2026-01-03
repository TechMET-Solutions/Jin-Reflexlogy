import 'package:flutter/material.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

class PatientDiagnosisScreen extends StatelessWidget {
  const PatientDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example diagnosis data
    final List<Map<String, String>> diagnosisList = [
      {'id': '23970', 'date': '21-05-2024', 'time': '16:10:46'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar:  CommonAppBar(title: "Diagnosis Record"), 
      body: Column(
        children: [
          // 🧾 Patient Info Card
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: const [
                Text(
                  "Patient Id: 1012",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Patient Name: Sapna Kalpesh Gandhi",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          // ➕ Add Diagnosis Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiagnosisScreen(),
                      ),
                    );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Add Diagnosis Clicked")),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 22),
                label: const Text(
                  "Add Diagnosis",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // 📋 Diagnosis List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: diagnosisList.length,
              itemBuilder: (context, index) {
                final item = diagnosisList[index];
                return InkWell(
                  onTap: (){
                    //   Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>  ModernDiagnosisScreen(),
                    //   ),
                    // );

  //                     Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => DiagnosisDetailsCard(
  //     patientName: ,
  //   )),
  // );
                    
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['id']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            item['date']!,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            item['time']!,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
