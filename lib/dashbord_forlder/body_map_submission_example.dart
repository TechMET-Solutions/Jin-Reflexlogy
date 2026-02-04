import 'dart:io';
import 'package:flutter/material.dart';
import 'body_map_with_screenshot.dart';

/// Complete example showing how to use body map with screenshot and API submission
class BodyMapSubmissionExample extends StatefulWidget {
  final String therapistId;
  final String patientId;
  final String day;

  const BodyMapSubmissionExample({
    super.key,
    required this.therapistId,
    required this.patientId,
    required this.day,
  });

  @override
  State<BodyMapSubmissionExample> createState() =>
      _BodyMapSubmissionExampleState();
}

class _BodyMapSubmissionExampleState extends State<BodyMapSubmissionExample> {
  List<String> selectedCells = [];
  final GlobalKey _screenshotKey = GlobalKey();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Body Map Assessment",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tap on grid cells to mark affected body areas. The screenshot will be automatically captured and uploaded.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Body Map with Screenshot
            SizedBox(
              height: 450,
              child: BodyMapWithScreenshot(
                screenshotKey: _screenshotKey,
                initialSelection: selectedCells,
                onSelectionChanged: (selected) {
                  setState(() {
                    selectedCells = selected;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            // Selected Areas Display
            if (selectedCells.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Marked Areas: ${selectedCells.length}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              selectedCells.clear();
                            });
                          },
                          icon: const Icon(Icons.clear_all, size: 18),
                          label: const Text("Clear"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedCells.map((cell) {
                        return Chip(
                          label: Text(
                            cell,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: Colors.red[100],
                          deleteIconColor: Colors.red[900],
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              selectedCells.remove(cell);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // API Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cloud_upload, color: Colors.green[700], size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Submission Details",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow("Therapist ID", widget.therapistId),
                  _buildInfoRow("Patient ID", widget.patientId),
                  _buildInfoRow("Day", widget.day),
                  _buildInfoRow("Selected Cells", selectedCells.join(', ')),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: selectedCells.isNotEmpty && !isSubmitting
          ? FloatingActionButton.extended(
              onPressed: _handleSubmit,
              backgroundColor: Colors.blue[700],
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                "Submit Assessment",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'None' : value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[900],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() {
      isSubmitting = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Capturing screenshot...',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      // Step 1: Capture screenshot
      final screenshotFile =
          await ScreenshotHelper.captureWidget(_screenshotKey);

      if (!mounted) return;

      if (screenshotFile == null) {
        Navigator.pop(context);
        _showErrorDialog('Failed to capture screenshot');
        setState(() {
          isSubmitting = false;
        });
        return;
      }

      // Update dialog
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Uploading data...',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );


      if (!mounted) return;

      Navigator.pop(context);


    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        _showErrorDialog('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            const SizedBox(width: 12),
            const Text("Success!"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Body map assessment submitted successfully!"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "✓ ${selectedCells.length} areas marked",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[900],
                    ),
                  ),
                  Text(
                    "✓ Screenshot captured",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[900],
                    ),
                  ),
                  Text(
                    "✓ Data uploaded",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600], size: 28),
            const SizedBox(width: 12),
            const Text("Error"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
