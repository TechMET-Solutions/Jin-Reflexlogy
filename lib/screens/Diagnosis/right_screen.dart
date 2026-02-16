import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/global/utils.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class PointData {
  final String id;
  double x;
  double y;
  final String tag;
  final int index;
  final String group;
  int state = 0;

  PointData({
    required this.id,
    required this.x,
    required this.y,
    required this.tag,
    required this.index,
    required this.group,
  });

  factory PointData.fromJson(Map<String, dynamic> json) {
    return PointData(
      id: json['id'].toString(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      tag: json['tag'].toString(),
      index: int.parse(json['index'].toString()),
      group: json['group'].toString(),
    );
  }
}

class RightFootScreenNew extends StatefulWidget {
  final String diagnosisId;
  final String patientId;
  final bool isNew;

  const RightFootScreenNew({
    required this.diagnosisId,
    required this.patientId,
    this.isNew = false,
    Key? key,
  }) : super(key: key);

  @override
  State<RightFootScreenNew> createState() => _RightFootScreenNewState();
}

class _RightFootScreenNewState extends State<RightFootScreenNew> {
  static const double baseWidth = 340;
  static const double baseHeight = 800;

  List<PointData> points = [];
  bool isLoading = true;
  bool _isMounted = false;

  final GlobalKey screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    loadPoints();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  // Safe setState - check if mounted before calling
  void safeSetState(VoidCallback fn) {
    if (_isMounted) {
      setState(fn);
    }
  }

  // --------------------------------------------------
  // LOAD JSON + LOCAL + SERVER
  // --------------------------------------------------
  Future<void> loadPoints() async {
    try {
      // Load right foot JSON
      final jsonString = await rootBundle.loadString("assets/right_foot.json");
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Adjust key for right foot JSON structure
      final List<dynamic> jsonList = jsonMap["RightFoot"] as List<dynamic>;
      points = jsonList.map((p) => PointData.fromJson(p)).toList();

      // load saved local selections first (if any)
      await loadSavedLocal();

      // fetch server states and merge
      await fetchServerStates();

      if (_isMounted) {
        setState(() => isLoading = false);
      }
    } catch (e, st) {
      debugPrint("JSON ERROR: $e");
      debugPrint("$st");
      if (_isMounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ---------------------------------------------------
  // LOAD FROM SINGLE JSON STRING (FAST)
  // ---------------------------------------------------
  Future<void> loadSavedLocal() async {
    try {
      final key = "RF_DATA_${widget.diagnosisId}_${widget.patientId}";
      final savedJson = await AppPreference().getString(key);

      debugPrint("LOAD LOCAL KEY -> $key");
      debugPrint(
        "SAVED JSON PREVIEW -> ${savedJson.isNotEmpty ? savedJson.substring(0, math.min(savedJson.length, 120)) : 'EMPTY'}",
      );

      if (savedJson.isEmpty) return;

      final decoded = jsonDecode(savedJson) as Map<String, dynamic>;

      for (var p in points) {
        if (decoded.containsKey(p.index.toString())) {
          final val = decoded[p.index.toString()];
          final parts = (val as String).split(",");
          if (parts.length >= 3) {
            p.x = double.parse(parts[0]);
            p.y = double.parse(parts[1]);
            p.state = int.parse(parts[2]);
          }
        }
      }
      
      debugPrint("Loaded ${decoded.length} points from local storage");
    } catch (e) {
      debugPrint("Error decoding saved JSON for RF: $e");
    }
  }

  // ---------------------------------------------------
  // FAST LOCAL SAVE (Only ONE write)
  // ---------------------------------------------------
  Future<void> saveAllPointsFast() async {
    try {
      Map<String, String> data = {};

      for (var p in points) {
        data[p.index.toString()] = "${p.x},${p.y},${p.state}";
      }

      final jsonData = jsonEncode(data);
      await AppPreference().setString(
        "RF_DATA_${widget.diagnosisId}_${widget.patientId}",
        jsonData,
      );

      debugPrint(
        "✅ Saved RF_DATA length=${jsonData.length} key=RF_DATA_${widget.diagnosisId}_${widget.patientId}",
      );
      Utils().showToastMessage("Data saved locally");
    } catch (e) {
      debugPrint("Error saving local data: $e");
      Utils().showToastMessage("Error saving: $e");
    }
  }

  // --------------------------------------------------
  // FETCH SERVER STATES (FIXED URL)
  // --------------------------------------------------
  Future<void> fetchServerStates() async {
    try {
      final form = FormData.fromMap({
        "diagnosisId": widget.diagnosisId,
        "pid": widget.patientId,
        "which": "rf",  // Change to "rf" for right foot
      });

      debugPrint("FETCH SERVER STATES -> ${form.fields}");

      // Use the correct API URL
      const apiUrl = "https://jinreflexology.in/api1/new/get_data.php";

      final response = await Dio().post(
        apiUrl,
        data: form,
        options: Options(
          responseType: ResponseType.plain,
          contentType: "multipart/form-data",
          validateStatus:
              (status) => status! < 500, // Accept 404 as valid response
        ),
      );

      final raw = response.data.toString();
      debugPrint(
        "SERVER RESPONSE RAW -> ${raw.length > 200 ? raw.substring(0, 200) + '...' : raw}",
      );

      // Check if response contains JSON
      if (raw.contains("{") && raw.contains("}")) {
        final start = raw.indexOf("{");
        final end = raw.lastIndexOf("}");
        if (start != -1 && end != -1 && end > start) {
          final jsonString = raw.substring(start, end + 1);

          try {
            final jsonBody = jsonDecode(jsonString);

            if (jsonBody["success"] == 1) {
              final dataStr = jsonBody["data"] as String;
              final Map<int, int> serverMap = {};

              for (final item in dataStr.split(";")) {
                if (item.contains(":")) {
                  final part = item.split(":");
                  final idx = int.tryParse(part[0]);
                  final val = int.tryParse(part[1]);
                  if (idx != null && val != null) serverMap[idx] = val;
                }
              }

              for (var p in points) {
                if (serverMap.containsKey(p.index)) {
                  final v = serverMap[p.index]!;
                  if (v == 1)
                    p.state = 2;
                  else if (v == -1)
                    p.state = 0;
                  else
                    p.state = 1;
                }
              }

              debugPrint("Loaded ${serverMap.length} states from server");
            } else {
              debugPrint(
                "Server returned success!=1: ${jsonBody['message'] ?? 'No message'}",
              );
            }
          } catch (e) {
            debugPrint("JSON decode error: $e");
          }
        }
      } else {
        debugPrint("No JSON found in server response");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint(
          "API endpoint not found (404). This is OK for new diagnosis.",
        );
      } else {
        debugPrint("SERVER DioException: ${e.message}");
      }
    } catch (e, st) {
      debugPrint("SERVER ERROR: $e");
      debugPrint("$st");
    }
  }

  // --------------------------------------------------
  // SAVE TO SERVER (Background call) - FIXED URL
  // --------------------------------------------------
  Future<void> saveAllToServer() async {
    try {
      final StringBuffer sb = StringBuffer();

      for (var p in points) {
        int sendVal;
        if (p.state == 2)
          sendVal = 1;
        else if (p.state == 0)
          sendVal = -1;
        else
          sendVal = 0;

        sb.write("${p.index}:$sendVal;");
      }

      const apiUrl = "https://jinreflexology.in/api/save_data.php";
      final response = await Dio().post(
        apiUrl,
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.patientId,
          "which": "rf",
          "data": sb.toString(),
        }),
        options: Options(
          contentType: "multipart/form-data",
          validateStatus: (status) => status! < 500,
        ),
      );
      
      debugPrint("✅ Saved RF to server -> response: ${response.data}");
      Utils().showToastMessage("Data saved to server");
    } catch (e) {
      debugPrint("❌ SAVE TO SERVER ERROR: $e");
      Utils().showToastMessage("Server save failed: $e");
    }
  }

  // --------------------------------------------------
  // CAPTURE SCREENSHOT
  // --------------------------------------------------
Future<String?> captureScreenshot() async {
  try {
    await Future.delayed(const Duration(milliseconds: 100));

    final boundary =
        screenshotKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;

    if (boundary == null) {
      debugPrint("Screenshot: boundary null");
      return null;
    }

    // High quality
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);

    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData == null) return null;

    final bytes = byteData.buffer.asUint8List();

    return base64Encode(bytes);
  } catch (e, st) {
    debugPrint("Screenshot error: $e");
    debugPrint("$st");
    return null;
  }
}

  // --------------------------------------------------
  // ENCODE TAGS FOR SERVER (rf_result FORMAT)
  // --------------------------------------------------
  String _encodeTagsForServer() {
    // Group by state with UNIQUE tags
    final Set<String> redTags = {};
    final Set<String> greenTags = {};

    for (var point in points) {
      if (point.state == 1 && point.tag.isNotEmpty) {
        redTags.add(point.tag); // red
      } else if (point.state == 2 && point.tag.isNotEmpty) {
        greenTags.add(point.tag); // green
      }
    }

    final resultBuffer = StringBuffer();

    // Add red tags first
    if (redTags.isNotEmpty) {
      resultBuffer.write(redTags.join('|'));
    }

    // Separator only if both exist
    if (redTags.isNotEmpty && greenTags.isNotEmpty) {
      resultBuffer.write('|');
    }

    // Add green tags
    if (greenTags.isNotEmpty) {
      resultBuffer.write(greenTags.join('|'));
    }

    return resultBuffer.toString();
  }

  // --------------------------------------------------
  // DOT UI WITH DRAG FUNCTIONALITY
  // --------------------------------------------------
  Widget _buildDot(PointData p, double scale) {
    Color color;
    if (p.state == 1) {
      color = const Color.fromARGB(255, 161, 27, 15);
    } else if (p.state == 2) {
      color = Colors.green;
    } else {
      color = Colors.white
      ;
    }
 bool _isDisabledIndex(PointData p) {
    const disabledIndexes = {286, 287, 288, 289, 312, 291, 292};

    return disabledIndexes.contains(p.index);
  }
    return GestureDetector(
 onTap: () {
        if (_isDisabledIndex(p)) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This point is not selectable"),
              duration: Duration(milliseconds: 400),
            ),
          );
          return;
        }
        safeSetState(() {
          p.state = (p.state + 1) % 3;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(p.tag),
            duration: const Duration(milliseconds: 500),
          ),
        );
        print("ssssds${p.tag}");
        print(
          "RF CLICK => ID:${p.id}, Index:${p.index}, X:${p.x}, Y:${p.y}, State:${p.state}",
        );
      },
      
      child: Container(
        width: 14.5 * scale,
        height: 14.5 * scale,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // SAVE TAGS TO SERVER
  // --------------------------------------------------
  Future<void> _saveTagsToServer(String encodedTags) async {
    try {
      const apiUrl = "https://jinreflexology.in/api/save_tags.php";
      await Dio().post(
        apiUrl,
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.patientId,
          "which": "rf",
          "tags": encodedTags,
          "timestamp": DateTime.now().toString(),
        }),
        options: Options(
          contentType: "multipart/form-data",
          validateStatus: (status) => status! < 500,
        ),
      );
      debugPrint("✅ Saved RF tags to server: $encodedTags");
    } catch (e) {
      debugPrint("❌ Error saving RF tags: $e");
    }
  }
bool _isSaving = false;

  String _encodeRfData() {
    final List<String> items = [];

    for (var point in points) {
      int serverValue;
      if (point.state == 2) {
        serverValue = 1; // green
      } else if (point.state == 1) {
        serverValue = 0; // red
      } else {
        serverValue = -1; // white/unselected
      }

      items.add("${point.index}:$serverValue");
    }

    return items.join(";");
  }

  // --------------------------------------------------
  // SAVE & EXIT BUTTON - FIXED VERSION
  // --------------------------------------------------
 Future<void> _saveAndExit() async {
  // Prevent double click
  if (_isSaving) return;
  _isSaving = true;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Saving data..."),
      duration: Duration(seconds: 2),
    ),
  );

  try {
    // 1. Encode tags
    final encodedTags = _encodeTagsForServer();

    // 2. Encode data
    final encodedRfData = _encodeRfData();

    // 3. Save locally
    await saveAllPointsFast();

    // 4. Capture screenshot
    final base64 = await captureScreenshot();

    // ❗ If image failed → stop
    if (base64 == null) {
      Utils().showToastMessage("❌ Image capture failed. Try again.");
      _isSaving = false;
      return;
    }

    // 5. Save image in preference
    final imageKey =
        "RF_IMG_${widget.diagnosisId}_${widget.patientId}";

    await AppPreference().setString(imageKey, base64);

    debugPrint(
      "✅ Image Saved: key=$imageKey length=${base64.length}",
    );

    // 6. Mark completed
    await AppPreference().setBool(
      "RF_SAVED_${widget.diagnosisId}_${widget.patientId}",
      true,
    );

    // 7. Debug logs
    debugPrint("=== RF COMPLETE DATA ===");
    debugPrint("rf_result: $encodedTags");
    debugPrint("rf_data: $encodedRfData");
    debugPrint(
        "Selected: ${points.where((p) => p.state != 0).length}/${points.length}");
    debugPrint("=========================");

    // 8. Prepare result
    final Map<String, dynamic> resultData = {
      'rf_result': encodedTags,
      'rf_data': encodedRfData,
      'rf_img': base64,
      'points_count': points.length,
      'selected_points': points.where((p) => p.state != 0).length,
      'timestamp': DateTime.now().toString(),
    };

    // 9. Background server save
    Future.microtask(() async {
      try {
        await saveAllToServer();
        await _saveTagsToServer(encodedTags);

        debugPrint("✅ Server save done");
      } catch (e) {
        debugPrint("❌ Server save error: $e");
      }
    });

    // 10. Return result
    if (mounted) {
      Navigator.pop(context, resultData);
    }

    Utils().showToastMessage("✅ Data saved successfully!");

  } catch (e, st) {
    debugPrint("❌ Save Error: $e");
    debugPrint("$st");

    Utils().showToastMessage("Error while saving!");

  } finally {
    // Always unlock button
    _isSaving = false;
  }
}

  // --------------------------------------------------
  // TEST BUTTON - Save button kaam न करे तो यह टेस्ट करें
  // --------------------------------------------------
  Widget _buildTestButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () async {
          debugPrint("Test button pressed");
          await saveAllPointsFast();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double desiredAspect = baseWidth / baseHeight;
    double screenW = MediaQuery.of(context).size.width * 0.98;
    double screenH = MediaQuery.of(context).size.height * 0.8;

    double containerW = math.min(screenW, screenH * desiredAspect);
    double containerH = containerW / desiredAspect;

    double scaleX = containerW / baseWidth;
    double scaleY = containerH / baseHeight;
    double scale = math.min(scaleX, scaleY);

    return Scaffold(
     
      appBar: CommonAppBar(title: " Right Foot"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Center(
                  child: Container(
                    width: containerW,
                    height: containerH,
                    child: RepaintBoundary(
                      key: screenshotKey,
                      
                      child: Stack(
                        children: [
                          // Right foot image
                          Image.asset(
                            'assets/images/foot_right.png',
                            width: containerW,
                            height: containerH,
                            fit: BoxFit.contain,
                          ),
                          ...points.map((p) {
                            return Positioned(
                              left: p.x * scaleX,
                              top: p.y * scaleY,
                              child: _buildDot(p, scale),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Test button
                _buildTestButton(),
              ],
            ),
    );
  }
}