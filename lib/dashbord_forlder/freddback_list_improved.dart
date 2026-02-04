import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'interactive_body_map.dart';

class BodyPartItem {
  final String name;
  String severity;

  BodyPartItem({required this.name, this.severity = "Severe"});

  Map<String, dynamic> toJson() => {
        'name': name,
        'severity': severity,
      };
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
              Text("Assessment Submitted Successfully!"),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Body Parts Assessment",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() => loading = true);
              fetchBodyParts();
            },
            tooltip: "Refresh",
          ),
        ],
      ),
      body: loading
          ? _buildLoadingState()
          : items.isEmpty
              ? _buildEmptyState()
              : _buildMainContent(),
      floatingActionButton: items.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: submitData,
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              elevation: 6,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Loading Body Parts...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please wait",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Body Parts Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please check your connection and try again",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => loading = true);
              fetchBodyParts();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final count = {
      "Mild": items.where((item) => item.severity == "Mild").length,
      "Moderate": items.where((item) => item.severity == "Moderate").length,
      "Severe": items.where((item) => item.severity == "Severe").length,
    };

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Stats Card
          _buildHeaderStatsCard(count),

          const SizedBox(height: 16),

          // Body Map Section
          _buildBodyMapSection(),

          const SizedBox(height: 16),

          // Instruction Card
          _buildInstructionCard(),

          const SizedBox(height: 16),

          // Severity Legend
          _buildSeverityLegend(),

          const SizedBox(height: 20),

          // Section Header
          _buildSectionHeader(),

          const SizedBox(height: 12),

          // Body Parts List
          _buildBodyPartsList(),

          // Spacer for FAB
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeaderStatsCard(Map<String, int> count) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assessment Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Select severity for each area",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Total", "${items.length}", Icons.list_alt),
              _buildStatItem(
                  "Mild", "${count["Mild"]}", Icons.check_circle_outline),
              _buildStatItem("Moderate", "${count["Moderate"]}",
                  Icons.warning_amber_rounded),
              _buildStatItem("Severe", "${count["Severe"]}", Icons.error_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildBodyMapSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.accessibility_new_rounded,
                  color: Colors.green[700],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Body Mapping Chart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Selection Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Areas: ${selectedCellIds.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.blue[900],
                        ),
                      ),
                      Text(
                        'Tap on body map to mark affected areas',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedCellIds.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearSelectedCells,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[700],
                      backgroundColor: Colors.red[50],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Body Map Image with Interactive Grid
          InteractiveBodyMap(
            initialSelection: selectedCellIds,
            onSelectionChanged: (selected) {
              setState(() {
                selectedCellIds = selected;
              });
            },
          ),

          // Selected Areas Chips
          if (selectedCellIds.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              "Selected Areas:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedCellIds.map((cellId) {
                return Chip(
                  label: Text(
                    cellId,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: Colors.blue[100],
                  deleteIconColor: Colors.blue[900],
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _toggleCellSelection(cellId),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.amber[800], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Tip: Select severity level for each body part below. This helps in accurate diagnosis and treatment planning.",
              style: TextStyle(
                color: Colors.amber[900],
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          const Text(
            "Severity Levels",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: levels.map((level) {
              return Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: severityColors[level],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: severityColors[level]!.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    level,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Body Parts List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            "${items.length} items",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPartsList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final severityColor = severityColors[item.severity] ?? Colors.grey;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: severityColor.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: severityColor.withOpacity(0.08),
                blurRadius: 8,
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        severityColor.withOpacity(0.15),
                        severityColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: severityColor.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    _getBodyPartIcon(item.name),
                    color: severityColor,
                    size: 24,
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
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: severityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.severity,
                            style: TextStyle(
                              fontSize: 13,
                              color: severityColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: severityColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: item.severity,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: severityColor,
                        size: 20,
                      ),
                      iconSize: 20,
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        fontSize: 14,
                        color: severityColor,
                        fontWeight: FontWeight.w600,
                      ),
                      items: levels.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: severityColors[value],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
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
