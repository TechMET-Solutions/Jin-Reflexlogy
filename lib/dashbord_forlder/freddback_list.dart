import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BodyPartItem {
  final String name;
  String severity; // Mild / Moderate / Severe

  BodyPartItem({required this.name, this.severity = "Severe"});
}

class BodyPartScreen extends StatefulWidget {
  const BodyPartScreen({super.key});

  @override
  State<BodyPartScreen> createState() => _BodyPartScreenState();
}

class _BodyPartScreenState extends State<BodyPartScreen> {
  List<BodyPartItem> items = [];
  bool loading = true;
  List<String> selectedCellIds = [];

  final List<String> levels = ["Mild", "Moderate", "Severe"];
  final Map<String, Color> severityColors = {
    "Mild": Colors.green,
    "Moderate": Colors.orange,
    "Severe": Colors.red,
  };

  @override
  void initState() {
    super.initState();
    fetchBodyParts();
  }

  void _toggleCellSelection(String cellId) {
    setState(() {
      if (selectedCellIds.contains(cellId)) {
        selectedCellIds.remove(cellId);
      } else {
        selectedCellIds.add(cellId);
      }
    });
  }

  Future<void> fetchBodyParts() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/new/bodyParts.php",
        data: FormData.fromMap({"diagnosisID": 96, "patientID": 1089}),
        options: Options(responseType: ResponseType.plain),
      );

      final String raw = res.data.toString();
      final Map<String, dynamic> data = jsonDecode(raw);

      if (data["success"] == true) {
        final List list = data["bodyParts"];
        items =
            list.map((e) => BodyPartItem(name: e.toString().trim())).toList();
      }
    } catch (e, st) {
      debugPrint("API Error: $e");
      debugPrint("$st");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to load body parts: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> submitData() async {
    Map<String, String> result = {};

    for (var item in items) {
      result[item.name] = item.severity;
    }

    debugPrint("FINAL DATA = $result");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text("Submitted Successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _clearSelectedCells() {
    setState(() {
      selectedCellIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Body Parts Assessment",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => loading = true);
              fetchBodyParts();
            },
            tooltip: "Refresh",
          ),
        ],
      ),
      body:
          loading
              ? _buildLoadingState()
              : items.isEmpty
              ? _buildEmptyState()
              : _buildSingleScrollView(),
      floatingActionButton:
          items.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: submitData,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 4,
                icon: const Icon(Icons.send),
                label: const Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
              : null,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading Body Parts...",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            "No Body Parts Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please check your connection and try again",
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => loading = true);
              fetchBodyParts();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleScrollView() {
    final count = {
      "Mild": items.where((item) => item.severity == "Mild").length,
      "Moderate": items.where((item) => item.severity == "Moderate").length,
      "Severe": items.where((item) => item.severity == "Severe").length,
    };

    return SingleChildScrollView(
      child: Column(
        children: [
          // Body Map Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.medical_services, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Body Areas Selection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Areas: ${selectedCellIds.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Tap on body map to select/deselect',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      if (selectedCellIds.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: _clearSelectedCells,
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text('Clear All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Body Map Image Placeholder
                // Body Map Image - Actual Image Display
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,  
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/fedback.jpeg',
                          fit: BoxFit.contain,
                          height: 300,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[100],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Image not found",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Check assets/images/fedback.jpeg",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Handle tap on image
                              },
                              splashColor: Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Selected Areas Chips
                if (selectedCellIds.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        selectedCellIds.map((cellId) {
                          return Chip(
                            label: Text(cellId),
                            backgroundColor: Colors.blue[50],
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => _toggleCellSelection(cellId),
                          );
                        }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Instruction Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Select severity level for each body part. This assessment will help in diagnosis.",
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Severity Legend
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  levels.map((level) {
                    return Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: severityColors[level],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          level,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),

          // Body Parts List
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              final severityColor =
                  severityColors[item.severity] ?? Colors.grey;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Body Part Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getBodyPartIcon(item.name),
                          color: severityColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Body Part Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Severity: ${item.severity}",
                              style: TextStyle(
                                fontSize: 12,
                                color: severityColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: severityColor.withOpacity(0.3),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: item.severity,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: severityColor,
                            ),
                            iconSize: 24,
                            elevation: 0,
                            borderRadius: BorderRadius.circular(8),
                            dropdownColor: Colors.white,
                            style: TextStyle(
                              fontSize: 14,
                              color: severityColor,
                              fontWeight: FontWeight.w500,
                            ),
                            items:
                                levels.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: severityColors[value],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(value),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                item.severity = val!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Summary Bar
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Conditions",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      "${items.length} items",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildSeverityCount("Mild", count["Mild"]!),
                    const SizedBox(width: 16),
                    _buildSeverityCount("Moderate", count["Moderate"]!),
                    const SizedBox(width: 16),
                    _buildSeverityCount("Severe", count["Severe"]!),
                  ],
                ),
              ],
            ),
          ),

          // Spacer for FAB
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSeverityCount(String severity, int count) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: severityColors[severity],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "$count",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(severity, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  IconData _getBodyPartIcon(String bodyPart) {
    final part = bodyPart.toLowerCase();
    if (part.contains('head') || part.contains('brain')) return Icons.face;
    if (part.contains('neck')) return Icons.person_outline;
    if (part.contains('shoulder')) return Icons.accessibility;
    if (part.contains('arm') || part.contains('hand')) return Icons.back_hand;
    if (part.contains('chest') || part.contains('lung')) {
      return Icons.favorite_border;
    }
    if (part.contains('back') || part.contains('spine')) {
      return Icons.linear_scale;
    }
    if (part.contains('stomach') || part.contains('abdomen')) {
      return Icons.medical_services;
    }
    if (part.contains('leg') ||
        part.contains('knee') ||
        part.contains('foot')) {
      return Icons.directions_walk;
    }
    return Icons.medical_services_outlined;
  }
}
