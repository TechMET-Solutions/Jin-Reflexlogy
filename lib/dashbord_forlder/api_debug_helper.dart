import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiDebugHelper {
  /// Test API with different parameter formats to find the correct one
  static Future<Map<String, dynamic>> testApiFormats({
    required String therapistId,
    required String patientId,
    required String day,
    required List<String> selectedCells,
    File? feedbackImage,
  }) async {
    final results = <String, dynamic>{};

    // Test 1: Without quotes (as in cURL)
    debugPrint('\n=== Test 1: Without quotes ===');
    try {
      FormData formData = FormData.fromMap({
        'therapistId': therapistId,
        'patientId': patientId,
        'day': day,
        'selectedCells': selectedCells.join(','),
        if (feedbackImage != null)
          'feedbackImage': await MultipartFile.fromFile(
            feedbackImage.path,
            filename: 'body_map.png',
          ),
      });

      final response = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      results['test1'] = {
        'status': response.statusCode,
        'data': response.data,
      };
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');
    } catch (e) {
      results['test1'] = {'error': e.toString()};
      debugPrint('Error: $e');
    }

    // Test 2: With quotes (as string values)
    debugPrint('\n=== Test 2: With quotes ===');
    try {
      FormData formData = FormData.fromMap({
        'therapistId': '"$therapistId"',
        'patientId': '"$patientId"',
        'day': '"$day"',
        'selectedCells': '"${selectedCells.join(',')}"',
        if (feedbackImage != null)
          'feedbackImage': await MultipartFile.fromFile(
            feedbackImage.path,
            filename: 'body_map.png',
          ),
      });

      final response = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      results['test2'] = {
        'status': response.statusCode,
        'data': response.data,
      };
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');
    } catch (e) {
      results['test2'] = {'error': e.toString()};
      debugPrint('Error: $e');
    }

    // Test 3: Without image
    debugPrint('\n=== Test 3: Without image ===');
    try {
      FormData formData = FormData.fromMap({
        'therapistId': therapistId,
        'patientId': patientId,
        'day': day,
        'selectedCells': selectedCells.join(','),
      });

      final response = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      results['test3'] = {
        'status': response.statusCode,
        'data': response.data,
      };
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');
    } catch (e) {
      results['test3'] = {'error': e.toString()};
      debugPrint('Error: $e');
    }

    // Test 4: Different field names
    debugPrint('\n=== Test 4: Different field names ===');
    try {
      FormData formData = FormData.fromMap({
        'therapist_id': therapistId,
        'patient_id': patientId,
        'day': day,
        'selected_cells': selectedCells.join(','),
        if (feedbackImage != null)
          'feedback_image': await MultipartFile.fromFile(
            feedbackImage.path,
            filename: 'body_map.png',
          ),
      });

      final response = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      results['test4'] = {
        'status': response.statusCode,
        'data': response.data,
      };
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');
    } catch (e) {
      results['test4'] = {'error': e.toString()};
      debugPrint('Error: $e');
    }

    return results;
  }

  /// Simple test without image
  static Future<bool> testSimpleSubmit({
    required String therapistId,
    required String patientId,
    required String day,
  }) async {
    try {
      debugPrint('\n=== Simple Test (No Image, No Selected Cells) ===');
      
      FormData formData = FormData.fromMap({
        'therapistId': therapistId,
        'patientId': patientId,
        'day': day,
      });

      final response = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  /// Check what the API actually expects
  static Future<void> inspectApiEndpoint() async {
    try {
      debugPrint('\n=== Inspecting API Endpoint ===');
      
      // Try GET request to see if it returns any info
      final getResponse = await Dio().get(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('GET Status: ${getResponse.statusCode}');
      debugPrint('GET Response: ${getResponse.data}');

      // Try POST with empty data
      final postResponse = await Dio().post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('POST (empty) Status: ${postResponse.statusCode}');
      debugPrint('POST (empty) Response: ${postResponse.data}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}

/// Widget to test API in the app
class ApiDebugScreen extends StatefulWidget {
  const ApiDebugScreen({super.key});

  @override
  State<ApiDebugScreen> createState() => _ApiDebugScreenState();
}

class _ApiDebugScreenState extends State<ApiDebugScreen> {
  String output = 'Tap a button to test...';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Debug Tool'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : _testSimple,
              child: const Text('Test Simple Submit'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: isLoading ? null : _inspectEndpoint,
              child: const Text('Inspect Endpoint'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: isLoading ? null : _testAllFormats,
              child: const Text('Test All Formats'),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      output,
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
      ),
    );
  }

  Future<void> _testSimple() async {
    setState(() {
      isLoading = true;
      output = 'Testing simple submit...\n';
    });

    final success = await ApiDebugHelper.testSimpleSubmit(
      therapistId: '222',
      patientId: '1059',
      day: 'first',
    );

    setState(() {
      isLoading = false;
      output += '\nResult: ${success ? 'SUCCESS' : 'FAILED'}';
    });
  }

  Future<void> _inspectEndpoint() async {
    setState(() {
      isLoading = true;
      output = 'Inspecting endpoint...\n';
    });

    await ApiDebugHelper.inspectApiEndpoint();

    setState(() {
      isLoading = false;
      output += '\nCheck console for results';
    });
  }

  Future<void> _testAllFormats() async {
    setState(() {
      isLoading = true;
      output = 'Testing all formats...\n';
    });

    final results = await ApiDebugHelper.testApiFormats(
      therapistId: '222',
      patientId: '1059',
      day: 'first',
      selectedCells: ['A1', 'B2', 'C3'],
    );

    String resultText = '';
    results.forEach((key, value) {
      resultText += '\n$key:\n';
      resultText += '  Status: ${value['status'] ?? 'N/A'}\n';
      resultText += '  Data: ${value['data'] ?? value['error']}\n';
    });

    setState(() {
      isLoading = false;
      output += resultText;
    });
  }
}
