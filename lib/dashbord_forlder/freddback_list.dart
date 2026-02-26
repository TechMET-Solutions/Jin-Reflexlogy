import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbord_forlder/image_fedback_selected.dart';
import 'package:jin_reflex_new/login_screen.dart';


import 'body_map_with_screenshot.dart';


class BodyPartItem {
  final String name;
  String severity;

  BodyPartItem({required this.name, this.severity = "severe"});

  Map<String, dynamic> toJson() => {'name': name, 'severity': severity};
}

class BodyPartScreen extends StatefulWidget {
  final String day;
  final pId;
  final dId;
  final bool isShow;

  const BodyPartScreen({
    super.key,
    this.day = 'first',
    this.pId,
    this.dId,
    this.isShow = true,
  });

  @override
  State<BodyPartScreen> createState() => _BodyPartScreenState();
}

class _BodyPartScreenState extends State<BodyPartScreen> {
  List<BodyPartItem> items = [];
  bool loading = true;
  bool? hasDayFile;
  String? dayFileName;
  String? dayFileBase64;
  Uint8List? dayImageBytes;
  Uint8List? firstDayImageBytes;
  Set<String> selectedCellIds = {};
  final GlobalKey _screenshotKey = GlobalKey();
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  List<String> get levels {
    if (widget.day == 'first') {
      return ["severe", "moderate", "mild25", "painful"];
    } else {
      return [
        "mild50",
        "recovered",
        "temporary",
        "miniMild",
        "progressive",
        "relax",
      ];
    }
  }

  Map<String, Color> get severityColors {
    if (widget.day == 'first') {
      return {
        "severe": Colors.red[700]!,
        "moderate": Colors.orange[700]!,
        "mild25": Colors.yellow[700]!,
        "painful": Colors.red[900]!,
      };
    } else {
      return {
        "mild50": Colors.lightGreen[600]!,
        "recovered": Colors.green[700]!,
        "temporary": Colors.blue[600]!,
        "miniMild": Colors.lightGreen[400]!,
        "progressive": Colors.teal[600]!,
        "relax": Colors.green[400]!,
      };
    }
  }

  Map<String, String> get severityLabels {
    if (widget.day == 'first') {
      return {
        "severe": "Severe",
        "moderate": "Moderate",
        "mild25": "Mild (25%)",
        "painful": "Painful",
      };
    } else {
      return {
        "mild50": "Mild (50%)",
        "recovered": "Recovered",
        "temporary": "Temporary",
        "miniMild": "Mini Mild",
        "progressive": "Progressive",
        "relax": "Relax",
      };
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDayFile();
    });
  }

  Future<void> checkDayFile() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/new/checkPatientHistoryFiles.php",
        data: FormData.fromMap({"patientID": widget.pId}),
      );

      final Map<String, dynamic> data = res.data;
      debugPrint("File check response: ${res.data}");

      if (data["success"] == 1) {
        if (mounted) {
          setState(() {
            if (widget.day == 'first') {
              hasDayFile = data["firstDayFileFound"] == true;
              dayFileName = data["firstDayFileName"];
              dayFileBase64 = data["firstDayFileBase64"];

              if (dayFileBase64 != null && dayFileBase64!.isNotEmpty) {
                try {
                  dayImageBytes = base64.decode(dayFileBase64!);
                  debugPrint("✅ ${widget.day} day image decoded successfully");
                } catch (e) {
                  debugPrint("❌ Error decoding base64 image: $e");
                  dayImageBytes = null;
                }
              }
            } else {
              hasDayFile = data["lastDayFileFound"] == true;
              dayFileName = data["lastDayFileName"];
              dayFileBase64 = data["lastDayFileBase64"];

              if (data["firstDayFileBase64"] != null &&
                  data["firstDayFileBase64"].isNotEmpty) {
                try {
                  firstDayImageBytes = base64.decode(
                    data["firstDayFileBase64"],
                  );
                  debugPrint("✅ First day image loaded for reference");
                } catch (e) {
                  debugPrint("❌ Error decoding first day base64 image: $e");
                  firstDayImageBytes = null;
                }
              }

              if (dayFileBase64 != null && dayFileBase64!.isNotEmpty) {
                try {
                  dayImageBytes = base64.decode(dayFileBase64!);
                  debugPrint("✅ Last day image decoded successfully");
                } catch (e) {
                  debugPrint("❌ Error decoding last day base64 image: $e");
                  dayImageBytes = null;
                }
              }
            }
          });
        }

        await fetchBodyParts();
      } else {
        if (mounted) {
          setState(() => loading = false);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to check files: ${data["message"] ?? "Unknown error"}",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, st) {
      debugPrint("File check error: $e\n$st");
      if (mounted) {
        setState(() => loading = false);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> fetchBodyParts() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/new/bodyParts.php",
        data: FormData.fromMap({
          "diagnosisID": widget.dId,
          "patientID": widget.pId,
        }),
        options: Options(responseType: ResponseType.plain),
      );

      debugPrint("this...........DId${widget.dId}");
      debugPrint("this..........Pid${widget.pId}");
      final String raw = res.data.toString();
      final Map<String, dynamic> data = jsonDecode(raw);
      debugPrint(res.data.toString());

      if (data["success"] == true) {
        final List list = data["bodyParts"];
        if (mounted) {
          setState(() {
            items =
                list
                    .map(
                      (e) => BodyPartItem(
                        name: e.toString().trim(),
                        severity: levels.first,
                      ),
                    )
                    .toList();
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No body parts found: ${data["message"] ?? ""}"),
              backgroundColor: Colors.orange,
            ),
          );
        }
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

  void _toggleCellSelection(String cellId) {
    if (hasDayFile == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${widget.day.capitalize()} day file already uploaded. Cannot edit body map.",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        if (selectedCellIds.contains(cellId)) {
          selectedCellIds.remove(cellId);
        } else {
          selectedCellIds.add(cellId);
        }
        debugPrint('Selected cells: ${selectedCellIds.toList()}');
      });
    }
  }

  Future<void> submitData() async {
    /// रोक जर आधी file upload आहे
    if (hasDayFile == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.day.capitalize()} day file already uploaded. Cannot submit again.',
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    /// ✅ SHOW LOADING DIALOG
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      /// ✅ CAPTURE SCREENSHOT
      final screenshotFile = await ScreenshotHelper.captureWidget(
        _repaintBoundaryKey,
      );

      /// ✅ BUILD JSON LIST
      List<Map<String, String>> diagnosisList = [];

      for (final item in items) {
        String pain = item.severity.toLowerCase().replaceAll(
          RegExp(r'[0-9]'),
          '',
        );

        if (!['mild', 'moderate', 'severe'].contains(pain)) {
          pain = 'severe';
        }

        diagnosisList.add({"bodyPart": item.name.trim(), "pain": pain});
      }

      debugPrint("FINAL JSON => ${jsonEncode(diagnosisList)}");

      /// ✅ API CALL
      final success = await ScreenshotHelper.submitBodyMapData(
        therapistId: AppPreference().getString(PreferencesKey.userId),
        patientId: widget.pId,
        day: widget.day,
        items: items,
        feedbackImage: screenshotFile,
      );

      /// ✅ CLOSE LOADING (SAFE)
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      /// SUCCESS
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${widget.day.capitalize()} Day Assessment Submitted Successfully!",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        if (mounted) {
          setState(() {
            selectedCellIds.clear();
          });
          checkDayFile();
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("Submission failed. Try again."),
        //     backgroundColor: Colors.red,
        //   ),
        // );

        checkDayFile();
      }
    } catch (e) {
      /// CLOSE LOADING SAFE
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      debugPrint('Submit Error => $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );

      checkDayFile();
    }
  }

  void _showFullScreenImage(bool isFirstDayImage) {
    Uint8List? imageBytes =
        isFirstDayImage ? firstDayImageBytes : dayImageBytes;
    if (imageBytes == null) return;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.5,
                    maxScale: 3,
                    child: Image.memory(imageBytes!, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isFirstDayImage
                          ? 'First Day Image'
                          : '${widget.day.capitalize()} Day Image',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = AppPreference().getString(PreferencesKey.token) ?? "";
    final type = AppPreference().getString(PreferencesKey.type) ?? "";
    debugPrint("User Type: $type, Token empty: ${token.isEmpty}");
    if (widget.isShow == false) {
      debugPrint("✅ Showing BodyPartScreen - Patient is logged in");
      return _buildBodyPartScreen();
    } else {
      debugPrint(
        "❌ Showing LoginScreen - Type: $type, Token empty: ${token.isEmpty}",
      );
      return type == "therapist" ||
              type == "prouser" ||
              type == "user" ||
              token.isEmpty
          ? JinLoginScreen(
            text: "BodyPartScreen",
            type: "patient",
            // registershow: true,
            onTab: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BodyPartScreen()),
              );
            },
          )
          : _buildBodyPartScreen();
    }
  }

  Widget _buildBodyPartScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.day == 'first'
              ? "First Day Assessment"
              : "Last Day Assessment",
          style: const TextStyle(
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
              colors:
                  widget.day == 'first'
                      ? [Colors.blue[700]!, Colors.blue[500]!]
                      : [Colors.green[700]!, Colors.green[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (hasDayFile != null)
            IconButton(
              icon: Icon(
                hasDayFile == true ? Icons.check_circle : Icons.error_outline,
                color:
                    hasDayFile == true ? Colors.green[100] : Colors.orange[100],
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      hasDayFile == true
                          ? "${widget.day.capitalize()} day file already uploaded: $dayFileName"
                          : "No ${widget.day} day file found. Please upload.",
                    ),
                    backgroundColor:
                        hasDayFile == true ? Colors.green : Colors.orange,
                  ),
                );
              },
              tooltip: "File Status",
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              if (mounted) {
                setState(() {
                  loading = true;
                  hasDayFile = null;
                  dayImageBytes = null;
                  firstDayImageBytes = null;
                });
              }
              checkDayFile();
            },
            tooltip: "Refresh",
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return _buildLoadingState();
    }

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSingleScrollView();
  }

  Widget? _buildFloatingActionButton() {
    if (loading || items.isEmpty) {
      return null;
    }

    if (hasDayFile == true) {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: submitData,
      backgroundColor:
          widget.day == 'first' ? Colors.blue[700] : Colors.green[700],
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.check_circle_outline),
      label: Text(
        "Submit ${widget.day.capitalize()} Assessment",
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
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
                  color: (widget.day == 'first' ? Colors.blue : Colors.green)
                      .withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.day == 'first' ? Colors.blue : Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.day == 'first'
                ? "Checking first day file..."
                : "Checking last day file...",
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
              if (mounted) {
                setState(() => loading = true);
              }
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
    Map<String, int> count = {};
    for (var level in levels) {
      count[level] = items.where((item) => item.severity == level).length;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.day == 'last' && firstDayImageBytes != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: Colors.blue[800], size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "First Day Image (Reference)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        onPressed: () => _showFullScreenImage(true),
                        tooltip: "View Fullscreen",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "First day body map for comparison",
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(true),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                        image:
                            firstDayImageBytes != null
                                ? DecorationImage(
                                  image: MemoryImage(firstDayImageBytes!),
                                  fit: BoxFit.contain,
                                )
                                : null,
                      ),
                      child:
                          firstDayImageBytes == null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                    Text(
                                      "First day image not available",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : Stack(
                                children: [
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "First Day",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap image to view fullscreen",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          if (widget.day == 'last' &&
              hasDayFile == true &&
              dayImageBytes != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.image, color: Colors.green[800], size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Uploaded Last Day Image",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.green[700],
                          size: 20,
                        ),
                        onPressed: () => _showFullScreenImage(false),
                        tooltip: "View Fullscreen",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(false),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                        image:
                            dayImageBytes != null
                                ? DecorationImage(
                                  image: MemoryImage(dayImageBytes!),
                                  fit: BoxFit.contain,
                                )
                                : null,
                      ),
                      child:
                          dayImageBytes == null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                    Text(
                                      "Image not available",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : Stack(
                                children: [
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "Last Day",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap image to view fullscreen",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          if (widget.day == 'first' &&
              hasDayFile == true &&
              dayImageBytes != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.image, color: Colors.green[800], size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Uploaded First Day Image",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.fullscreen,
                          color: Colors.green[700],
                          size: 20,
                        ),
                        onPressed: () => _showFullScreenImage(false),
                        tooltip: "View Fullscreen",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(false),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                        image:
                            dayImageBytes != null
                                ? DecorationImage(
                                  image: MemoryImage(dayImageBytes!),
                                  fit: BoxFit.contain,
                                )
                                : null,
                      ),
                      child:
                          dayImageBytes == null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                    Text(
                                      "Image not available",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap image to view fullscreen",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          if (widget.day == 'first' && hasDayFile == false)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[800], size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No ${widget.day.capitalize()} Day File Found",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Please upload a body map screenshot",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          RepaintBoundary(
            key: _repaintBoundaryKey,
            child: Column(
              children: [
                ImagesSelectedBodyPart(
                  selectedCellIds: selectedCellIds,
                  onCellSelectionChanged: _toggleCellSelection,
                  day: widget.day,
                  isReadOnly: hasDayFile == true,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.day == 'first'
                                ? Icons.calendar_today
                                : Icons.event_available,
                            size: 16,
                            color:
                                widget.day == 'first'
                                    ? Colors.red[700]
                                    : Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.day == 'first'
                                ? 'First Day Assessment'
                                : 'Last Day Assessment',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color:
                                  widget.day == 'first'
                                      ? Colors.red[700]
                                      : Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children:
                            levels.map((level) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
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
                                    severityLabels[level] ?? level,
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              final severityColor =
                  severityColors[item.severity] ?? Colors.grey;
              final bool isEditable = hasDayFile != true;

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
                      if (isEditable)
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
                                    final color =
                                        severityColors[value] ?? Colors.grey;
                                    final label =
                                        severityLabels[value] ?? value;
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(label),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (val) {
                                if (isEditable && mounted) {
                                  setState(() {
                                    item.severity = val!;
                                  });
                                }
                              },
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: severityColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                severityLabels[item.severity] ?? item.severity,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.lock,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

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
                  children:
                      levels.take(3).map((severity) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildSeverityCount(
                            severity,
                            count[severity] ?? 0,
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),

          if (selectedCellIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.day == 'first' ? Colors.blue[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      widget.day == 'first'
                          ? Colors.blue[100]!
                          : Colors.green[100]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color:
                            widget.day == 'first'
                                ? Colors.blue[700]
                                : Colors.green[700],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Selected Body Areas",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.day == 'first'
                                  ? Colors.blue[700]
                                  : Colors.green[700],
                        ),
                      ),
                      if (hasDayFile == true)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.lock,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        selectedCellIds.map((cellId) {
                          return Chip(
                            label: Text(cellId),
                            backgroundColor:
                                widget.day == 'first'
                                    ? Colors.blue[100]
                                    : Colors.green[100],
                            labelStyle: TextStyle(
                              color:
                                  widget.day == 'first'
                                      ? Colors.blue
                                      : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSeverityCount(String severity, int count) {
    final color = severityColors[severity] ?? Colors.grey;
    final label = severityLabels[severity] ?? severity;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getBodyPartIcon(String bodyPart) {
    final part = bodyPart.toLowerCase();
    if (part.contains('head') || part.contains('brain')) return Icons.face;
    if (part.contains('neck')) return Icons.person_outline;
    if (part.contains('shoulder')) return Icons.accessibility;
    if (part.contains('arm') || part.contains('hand')) return Icons.back_hand;
    if (part.contains('chest') || part.contains('lung'))
      return Icons.favorite_border;
    if (part.contains('back') || part.contains('spine'))
      return Icons.linear_scale;
    if (part.contains('stomach') || part.contains('abdomen'))
      return Icons.medical_services;
    if (part.contains('leg') || part.contains('knee') || part.contains('foot'))
      return Icons.directions_walk;
    return Icons.medical_services_outlined;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
