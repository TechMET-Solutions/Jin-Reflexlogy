import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Quick test screen to debug the API
class QuickApiTest extends StatefulWidget {
  const QuickApiTest({super.key});

  @override
  State<QuickApiTest> createState() => _QuickApiTestState();
}

class _QuickApiTestState extends State<QuickApiTest> {
  String log = '';
  bool isLoading = false;

  void addLog(String message) {
    setState(() {
      log += '$message\n';
    });
    debugPrint(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: isLoading ? null : testWithoutImage,
                  child: const Text('Test WITHOUT Image'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      log = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Clear Log'),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  log.isEmpty ? 'Tap a button to test...' : log,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> testWithoutImage() async {
    setState(() {
      isLoading = true;
      log = '';
    });

    addLog('=== Testing API WITHOUT Image ===\n');

    try {
      // Test 1: Minimal data
      addLog('Test 1: Minimal required fields');
      await _testApi({
        'therapistId': '222',
        'patientId': '1059',
        'day': 'first',
      });

      await Future.delayed(const Duration(seconds: 1));

      // Test 2: With selected cells
      addLog('\nTest 2: With selected cells');
      await _testApi({
        'therapistId': '222',
        'patientId': '1059',
        'day': 'first',
        'selectedCells': 'A1,B2,C3',
      });

      await Future.delayed(const Duration(seconds: 1));

      // Test 3: Different field names (snake_case)
      addLog('\nTest 3: Snake case field names');
      await _testApi({
        'therapist_id': '222',
        'patient_id': '1059',
        'day': 'first',
      });

      await Future.delayed(const Duration(seconds: 1));

      // Test 4: Check if diagnosisID is needed
      addLog('\nTest 4: With diagnosisID');
      await _testApi({
        'therapistId': '222',
        'patientId': '1059',
        'diagnosisID': '96',
        'day': 'first',
      });

    } catch (e) {
      addLog('Fatal error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _testApi(Map<String, dynamic> data) async {
    try {
      addLog('Sending: $data');

      FormData formData = FormData.fromMap(data);

      final response = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      addLog('✓ Status: ${response.statusCode}');
      addLog('✓ Response: ${response.data}');
      
      if (response.statusCode == 200) {
        addLog('✓ SUCCESS!\n');
      } else {
        addLog('✗ Failed with status ${response.statusCode}\n');
      }
    } catch (e) {
      if (e is DioException) {
        addLog('✗ Error: ${e.message}');
        addLog('✗ Status: ${e.response?.statusCode}');
        addLog('✗ Response: ${e.response?.data}\n');
      } else {
        addLog('✗ Error: $e\n');
      }
    }
  }
}
