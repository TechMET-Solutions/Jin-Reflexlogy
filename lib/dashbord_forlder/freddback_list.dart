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
  final dynamic pId;
  final dynamic dId;
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
  // ==================== VARIABLES ====================
  late String patientId;
  List<BodyPartItem> items = [];
  bool loading = true;
  bool? hasDayFile;
  String? dayFileName;
  String? dayFileBase64;
  Uint8List? dayImageBytes;
  Uint8List? firstDayImageBytes;
  Set<String> selectedCellIds = {};

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  String get defaultSeverity =>
      widget.day == 'first' ? levels.first : "fullyRecovered";

  // ==================== GETTERS ====================
  List<String> get levels =>
      widget.day == 'first'
          ? ["severe", "moderate50", "mild25", "painful"]
          : ["fullyRecovered", "moderate", "progressive", "relax25", "none0"];

  Map<String, Color> get severityColors {
    if (widget.day == 'first') {
      return {
        "severe": Colors.red[700]!,
        "moderate50": Colors.orange[700]!,
        "mild25": Colors.yellow[700]!,
        "painful": Colors.red[900]!,
      };
    } else {
      return {
        "fullyRecovered": Colors.green[700]!,
        "moderate": Colors.orange[700]!,
        "progressive": Colors.teal[600]!,
        "relax25": Colors.lightGreen[400]!,
        "none0": Colors.grey[500]!,
      };
    }
  }

  Map<String, String> get severityLabels {
    if (widget.day == 'first') {
      return {
        "severe": "Severe",
        "moderate50": "Moderate 50%",
        "mild25": "Mild (25%)",
        "painful": "Painful",
      };
    } else {
      return {
        "fullyRecovered": "Fully Recovered 100%",
        "moderate": "Moderate",
        "progressive": "Progressive 75%",
        "relax25": "Relax 25%",
        "none0": "None 0%",
      };
    }
  }

  String _normalizedSeverity(String severity) {
    final value = severity.trim();
    final normalizedKey = value.toLowerCase();

    if (widget.day == 'first') {
      switch (value) {
        case "severe":
        case "moderate50":
        case "mild25":
        case "painful":
          return value;
        case "moderate":
          return "moderate50";
        default:
          return "severe";
      }
    }

    switch (normalizedKey) {
      case "fullyrecovered":
        return "fullyRecovered";
      case "moderate":
        return "moderate";
      case "temporary":
        return "temporary";
      case "minimild":
        return "miniMild";
      case "progressive":
        return "progressive";
      case "relax25":
        return "relax25";
      case "none0":
        return "none0";
      case "relax":
        return "relax25";
      case "mild50":
      case "moderate50":
        return "moderate";
      case "recovered":
        return "fullyRecovered";
      default:
        return "fullyRecovered";
    }
  }

  String _painForBackend(String severity) {
    final normalized = _normalizedSeverity(severity);

    if (widget.day == 'first') {
      switch (normalized) {
        case "severe":
        case "painful":
          return "severe";
        case "moderate50":
          return "moderate50";
        case "mild25":
          return "mild25";
        default:
          return "severe";
      }
    }

    switch (normalized) {
      case "fullyRecovered":
        return "fullyRecovered";
      case "moderate":
        return "moderate";
      case "temporary":
        return "temporary";
      case "miniMild":
        return "miniMild";
      case "progressive":
        return "progressive";
      case "relax25":
        return "relax25";
      case "none0":
        return "none0";
      default:
        return "fullyRecovered";
    }
  }
  @override
  void initState() {
    super.initState();
    _initializePatientId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDayFile();
    });
  }

  void _initializePatientId() {
    final prefUserId = AppPreference().getString(PreferencesKey.userId) ?? "";

    // Safe conversion of widget.pId
    String? widgetPid;
    if (widget.pId != null) {
      widgetPid = widget.pId.toString().trim();
      if (widgetPid.isEmpty) widgetPid = null;
    }

    patientId = widgetPid ?? prefUserId;

    // Debug logs
    debugPrint("===== PATIENT ID INIT =====");
    debugPrint("📦 widget.pId: ${widget.pId ?? 'null'}");
    debugPrint("💾 prefs userId: '$prefUserId'");
    debugPrint("✅ FINAL patientId: '$patientId'");
    debugPrint("===========================");
  }

  // ==================== API CALLS ====================
  Future<void> checkDayFile() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/new/checkPatientHistoryFiles.php",
        data: FormData.fromMap({"patientID": patientId}),
      );

      final Map<String, dynamic> data = res.data;
      debugPrint("📁 File check response: ${res.data}");

      if (data["success"] == 1) {
        _processFileResponse(data);
        await fetchBodyParts();
      } else {
        if (mounted) setState(() => loading = false);
        _showSnackBar(
          "Failed to check files: ${data["message"] ?? "Unknown error"}",
          Colors.red,
        );
      }
    } catch (e, st) {
      debugPrint("❌ File check error: $e\n$st");
      if (mounted) setState(() => loading = false);
      _showSnackBar("Network error: ${e.toString()}", Colors.red);
    }
  }

  void _processFileResponse(Map<String, dynamic> data) {
    if (!mounted) return;

    setState(() {
      if (widget.day == 'first') {
        hasDayFile = data["firstDayFileFound"] == true;
        dayFileName = data["firstDayFileName"];
        dayFileBase64 = data["firstDayFileBase64"];
        dayImageBytes = _decodeBase64(dayFileBase64);
      } else {
        hasDayFile = data["lastDayFileFound"] == true;
        dayFileName = data["lastDayFileName"];
        dayFileBase64 = data["lastDayFileBase64"];
        dayImageBytes = _decodeBase64(dayFileBase64);
        firstDayImageBytes = _decodeBase64(data["firstDayFileBase64"]);
      }
    });
  }

  Uint8List? _decodeBase64(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      return base64.decode(base64String);
    } catch (e) {
      debugPrint("❌ Base64 decode error: $e");
      return null;
    }
  }

  Future<void> fetchBodyParts() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/new/bodyParts.php",
        data: FormData.fromMap({
          "diagnosisID": widget.dId,
          "patientID": patientId,
        }),
        options: Options(responseType: ResponseType.plain),
      );

      debugPrint("📥 BodyParts API - DId: ${widget.dId}, PId: $patientId");

      final String raw = res.data.toString();
      final Map<String, dynamic> data = jsonDecode(raw);

      if (data["success"] == true) {
        final List list = data["bodyParts"];
        if (mounted) {
          setState(() {
            items =
                list
                    .map(
                      (e) => BodyPartItem(
                        name: e.toString().trim(),
                        severity: defaultSeverity,
                      ),
                    )
                    .toList();
          });
        }
      } else {
        _showSnackBar("No body parts found", Colors.orange);
      }
    } catch (e, st) {
      debugPrint("❌ API Error: $e\n$st");
      _showSnackBar("Failed to load body parts", Colors.red);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _toggleCellSelection(String cellId) {
    if (hasDayFile == true) {
      _showSnackBar(
        "${widget.day.capitalize()} day file already uploaded. Cannot edit.",
        Colors.orange,
      );
      return;
    }

    if (mounted) {
      setState(() {
        selectedCellIds.contains(cellId)
            ? selectedCellIds.remove(cellId)
            : selectedCellIds.add(cellId);
      });
    }
  }

  Future<void> submitData() async {
    if (hasDayFile == true) {
      _showSnackBar(
        '${widget.day.capitalize()} day file already uploaded.',
        Colors.orange,
      );
      return;
    }
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final screenshotFile = await ScreenshotHelper.captureWidget(
        _repaintBoundaryKey,
      );
      List<Map<String, String>> diagnosisList = [];

      for (final item in items) {
        final String pain = _painForBackend(item.severity);

        diagnosisList.add({"bodyPart": item.name.trim(), "pain": pain});
      }

      debugPrint("📤 Submitting: ${jsonEncode(diagnosisList)}");
      final success = await ScreenshotHelper.submitBodyMapData(
        therapistId: AppPreference().getString(PreferencesKey.userId),
        patientId: patientId,
        day: widget.day,
        items: items,
        feedbackImage: screenshotFile,
      );
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      if (success) {
        _showSnackBar(
          "${widget.day.capitalize()} Day Assessment Submitted!",
          Colors.green,
        );
        if (mounted) {
          setState(() {
            selectedCellIds.clear();
          });
          checkDayFile();
        }
      } else {
        checkDayFile();
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
      debugPrint('❌ Submit Error: $e');
      _showSnackBar("Error: $e", Colors.red);
      checkDayFile();
    }
  }

  void _showFullScreenImage(bool isFirstDayImage) {
    final imageBytes = isFirstDayImage ? firstDayImageBytes : dayImageBytes;
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
                    child: Image.memory(imageBytes, fit: BoxFit.contain),
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

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = AppPreference().getString(PreferencesKey.type);

    final token = AppPreference().getString(PreferencesKey.token) ?? "";
    if (token.isEmpty) {
      debugPrint("🔐 Token empty - Showing LoginScreen");
      return JinLoginScreen(
        text: "BodyPartScreen",
        type: "patient",
        onTab: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BodyPartScreen()),
          );
        },
      );
    }

    debugPrint("✅ User logged in - Showing BodyPartScreen");
    return _buildBodyPartScreen();
  }

  Widget _buildBodyPartScreen() {
    final type = AppPreference().getString(PreferencesKey.type);

    final token = AppPreference().getString(PreferencesKey.token) ?? "";
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
              onPressed:
                  () => _showSnackBar(
                    hasDayFile == true
                        ? "${widget.day.capitalize()} day file uploaded: $dayFileName"
                        : "No ${widget.day} day file found",
                    hasDayFile == true ? Colors.green : Colors.orange,
                  ),
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
          ),
        ],
      ),
      body:
          widget.day == 'first'
              ? _buildBody()
              : type == "therapist" ||
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
              : _buildBody(),

      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (loading) return _buildLoadingState();
    if (items.isEmpty) return _buildEmptyState();
    return _buildMainContent();
  }

  Widget? _buildFloatingActionButton() {
    if (loading || items.isEmpty || hasDayFile == true) return null;

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
              if (mounted) setState(() => loading = true);
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

  Widget _buildMainContent() {
    final Map<String, int> count = {};
    for (var level in levels) {
      count[level] =
          items
              .where((item) => _normalizedSeverity(item.severity) == level)
              .length;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.day == 'last' && firstDayImageBytes != null)
            _buildReferenceImageCard(
              title: "First Day Image (Reference)",
              color: Colors.blue,
              imageBytes: firstDayImageBytes!,
              isFirstDay: true,
            ),
          if (widget.day == 'last' &&
              hasDayFile == true &&
              dayImageBytes != null)
            _buildReferenceImageCard(
              title: "Uploaded Last Day Image",
              color: Colors.green,
              imageBytes: dayImageBytes!,
              isFirstDay: false,
            ),
          if (widget.day == 'first' &&
              hasDayFile == true &&
              dayImageBytes != null)
            _buildReferenceImageCard(
              title: "Uploaded First Day Image",
              color: Colors.green,
              imageBytes: dayImageBytes!,
              isFirstDay: false,
            ),
          //  if (widget.day != 'first' && hasDayFile == false) _buildWarningCard(),
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
                _buildLegendCard(),
              ],
            ),
          ),

          // Body Parts List
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, i) => _buildBodyPartItem(items[i], i),
          ),

          // Summary Card
          _buildSummaryCard(count),

          // Selected Areas Card
          ///  if (selectedCellIds.isNotEmpty) _buildSelectedAreasCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildReferenceImageCard({
    required String title,
    required MaterialColor color,
    required Uint8List imageBytes,
    required bool isFirstDay,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image, color: color[800], size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color[800],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.fullscreen, color: color[700], size: 20),
                onPressed: () => _showFullScreenImage(isFirstDay),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showFullScreenImage(isFirstDay),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color[200]!),
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.contain,
                ),
              ),
              child: Stack(
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
                      child: Text(
                        isFirstDay ? "First Day" : "Last Day",
                        style: const TextStyle(
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
    );
  }

  Widget _buildWarningCard() {
    return Container(
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
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    widget.day == 'first' ? Colors.red[700] : Colors.green[700],
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
                levels
                    .map(
                      (level) => Row(
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
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPartItem(BodyPartItem item, int index) {
    final currentSeverity = _normalizedSeverity(item.severity);
    if (item.severity != currentSeverity) {
      item.severity = currentSeverity;
    }
    final severityColor = severityColors[currentSeverity] ?? Colors.grey;
    final bool isEditable = hasDayFile != true;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useVerticalLayout = constraints.maxWidth < 420;
        final Widget iconBox = Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getBodyPartIcon(item.name),
            color: severityColor,
            size: 22,
          ),
        );

        final Widget titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Severity: ${severityLabels[currentSeverity] ?? currentSeverity}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: severityColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

        final Widget actionWidget =
            isEditable
                ? _buildSeverityDropdown(item, currentSeverity, severityColor)
                : _buildReadOnlySeverityChip(currentSeverity, severityColor);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                useVerticalLayout
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            iconBox,
                            const SizedBox(width: 12),
                            Expanded(child: titleSection),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(width: double.infinity, child: actionWidget),
                      ],
                    )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        iconBox,
                        const SizedBox(width: 16),
                        Expanded(child: titleSection),
                        const SizedBox(width: 12),
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: actionWidget,
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Widget _buildSeverityDropdown(
    BodyPartItem item,
    String currentSeverity,
    Color severityColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentSeverity,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: severityColor),
          iconSize: 24,
          elevation: 0,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          style: TextStyle(
            fontSize: 14,
            color: severityColor,
            fontWeight: FontWeight.w600,
          ),
          items:
              levels.map((String value) {
                final color = severityColors[value] ?? Colors.grey;
                final label = severityLabels[value] ?? value;
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
                      Expanded(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (val) {
            if (mounted && val != null) {
              setState(() => item.severity = val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlySeverityChip(
    String currentSeverity,
    Color severityColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          Expanded(
            child: Text(
              severityLabels[currentSeverity] ?? currentSeverity,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.lock, size: 14, color: Colors.grey[500]),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, int> count) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
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
              Text(
                "Severity Count",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children:
                levels.map((severity) {
                  return _buildSeverityCount(severity, count[severity] ?? 0);
                }).toList(),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildSelectedAreasCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.day == 'first' ? Colors.blue[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.day == 'first' ? Colors.blue[100]! : Colors.green[100]!,
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
                  child: Icon(Icons.lock, size: 16, color: Colors.grey[600]),
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
                      color: widget.day == 'first' ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
          ),
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
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
