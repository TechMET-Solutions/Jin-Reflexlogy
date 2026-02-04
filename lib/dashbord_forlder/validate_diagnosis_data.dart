import 'dart:convert';
import 'package:flutter/material.dart';

/// Helper to validate diagnosis data before sending to API
class DiagnosisDataValidator {
  /// Validate body parts data
  static Map<String, dynamic> validate(List<Map<String, String>> bodyPartsData) {
    List<String> errors = [];
    List<String> warnings = [];
    List<Map<String, String>> validData = [];

    for (int i = 0; i < bodyPartsData.length; i++) {
      final item = bodyPartsData[i];
      final bodyPart = item['bodyPart'] ?? '';
      final pain = item['pain'] ?? '';

      // Check if bodyPart is empty
      if (bodyPart.trim().isEmpty) {
        errors.add('Item $i: Body part is empty');
        continue;
      }

      // Check if pain level is valid
      if (!['mild', 'moderate', 'severe'].contains(pain.toLowerCase())) {
        warnings.add('Item $i ($bodyPart): Invalid pain level "$pain", using "severe"');
        validData.add({
          'bodyPart': bodyPart.trim(),
          'pain': 'severe',
        });
      } else {
        validData.add({
          'bodyPart': bodyPart.trim(),
          'pain': pain.toLowerCase(),
        });
      }

      // Check for special characters that might cause issues
      if (bodyPart.contains('"') || bodyPart.contains('\\')) {
        warnings.add('Item $i ($bodyPart): Contains special characters');
      }
    }

    // Check JSON size
    final jsonString = jsonEncode(validData);
    final jsonSize = jsonString.length;
    
    if (jsonSize > 10000) {
      warnings.add('JSON size is large: $jsonSize characters (${validData.length} items)');
    }

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'warnings': warnings,
      'validData': validData,
      'jsonSize': jsonSize,
      'itemCount': validData.length,
    };
  }

  /// Show validation results in a dialog
  static void showValidationDialog(
    BuildContext context,
    Map<String, dynamic> validation,
  ) {
    final errors = validation['errors'] as List<String>;
    final warnings = validation['warnings'] as List<String>;
    final itemCount = validation['itemCount'] as int;
    final jsonSize = validation['jsonSize'] as int;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              errors.isEmpty ? Icons.check_circle : Icons.error,
              color: errors.isEmpty ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            const Text('Data Validation'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Items: $itemCount',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'JSON Size: $jsonSize characters',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              if (errors.isNotEmpty) ...[
                const Text(
                  'Errors:',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...errors.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $e', style: const TextStyle(color: Colors.red)),
                )),
                const SizedBox(height: 16),
              ],
              
              if (warnings.isNotEmpty) ...[
                const Text(
                  'Warnings:',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...warnings.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $w', style: const TextStyle(color: Colors.orange)),
                )),
              ],
              
              if (errors.isEmpty && warnings.isEmpty) ...[
                const Text(
                  '✓ All data is valid!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Print validation results to console
  static void printValidation(Map<String, dynamic> validation) {
    debugPrint('=== Data Validation ===');
    debugPrint('Valid: ${validation['isValid']}');
    debugPrint('Item Count: ${validation['itemCount']}');
    debugPrint('JSON Size: ${validation['jsonSize']} characters');
    
    final errors = validation['errors'] as List<String>;
    if (errors.isNotEmpty) {
      debugPrint('\nErrors:');
      for (var error in errors) {
        debugPrint('  ✗ $error');
      }
    }
    
    final warnings = validation['warnings'] as List<String>;
    if (warnings.isNotEmpty) {
      debugPrint('\nWarnings:');
      for (var warning in warnings) {
        debugPrint('  ⚠ $warning');
      }
    }
    
    if (errors.isEmpty && warnings.isEmpty) {
      debugPrint('✓ All data is valid!');
    }
    
    // Print sample data
    final validData = validation['validData'] as List<Map<String, String>>;
    if (validData.isNotEmpty) {
      debugPrint('\nSample data (first 3 items):');
      for (int i = 0; i < 3 && i < validData.length; i++) {
        debugPrint('  ${i + 1}. ${validData[i]}');
      }
      if (validData.length > 3) {
        debugPrint('  ... and ${validData.length - 3} more items');
      }
    }
  }
}
