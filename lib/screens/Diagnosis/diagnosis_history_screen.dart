import 'package:flutter/material.dart';

class DiagnosisHistoryScreen extends StatelessWidget {
  final String patientId;
  final String diagnosisId;
  final String patientName;

  DiagnosisHistoryScreen({
    required this.patientId,
    required this.diagnosisId,
    required this.patientName,
  });

  // -------- HARD CODED LIST --------
  final List<Map<String, String>> historyList = [
    {
      "id": "15211",
      "day": "Day 1",
      "date": "21-05-2024",
      "time": "05:53:20",
    },
    {
      "id": "15828",
      "day": "Day 2",
      "date": "11-11-2025",
      "time": "05:15:28",
    },
    {
      "id": "15838",
      "day": "Day 3",
      "date": "28-11-2025",
      "time": "03:38:01",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8FA),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35),

          Row(
            children: [
              _buildHeaderBox("Patient Id: $patientId", Colors.orange),
              _buildHeaderBox("Diagnosis Id: $diagnosisId", Colors.blue),
            ],
          ),

          SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Patient Name: $patientName",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LEFT SIDE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["id"]!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            item["day"]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      // RIGHT SIDE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item["date"]!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            item["time"]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.add, size: 28),
        onPressed: () {
          // Add new diagnosis screen navigation
        },
      ),
    );
  }

  // ------- Header Widget -------
  Widget _buildHeaderBox(String title, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
