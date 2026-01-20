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

// --------------------------------------------------
// MODEL
// --------------------------------------------------
class PointData {
  final String id;
  double x;
  double y;
  final String tag;
  final int index;
  final String group;

  /// 0 = white
  /// 1 = red
  /// 2 = green
  int state;

  PointData({
    required this.id,
    required this.x,
    required this.y,
    required this.tag,
    required this.index,
    required this.group,
    this.state = 0,
  });

  factory PointData.fromJson(Map<String, dynamic> json) {
    return PointData(
      id: json["id"].toString(),
      x: (json["x"] as num).toDouble(),
      y: (json["y"] as num).toDouble(),
      tag: json["tag"].toString(),
      index: int.parse(json["index"].toString()),
      group: json["group"].toString(),
      state: 0,
    );
  }
}

// --------------------------------------------------
// SCREEN
// --------------------------------------------------
class LeftFootScreenNew extends StatefulWidget {
  final String diagnosisId;
  final String patientId;
  final String pid;

  const LeftFootScreenNew({
    required this.diagnosisId,
    required this.patientId,
    this.pid = "22",
    Key? key,
  }) : super(key: key);

  @override
  _LeftFootScreenNewState createState() => _LeftFootScreenNewState();
}

class _LeftFootScreenNewState extends State<LeftFootScreenNew> {
  static const double baseWidth = 340;
  static const double baseHeight = 805;

  List<PointData> points = [];
  bool isLoading = true;

  final GlobalKey screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  // --------------------------------------------------
  // LOAD JSON + LOCAL + SERVER
  // --------------------------------------------------
  Future<void> loadPoints() async {
    try {
      final jsonString = await rootBundle.loadString("assets/button.json");
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final List<dynamic> jsonList = jsonMap["buttons"] as List<dynamic>;
      points = jsonList.map((p) => PointData.fromJson(p)).toList();

      // load saved local selections first (if any)
      // loadSavedLocal();

      // fetch server states and merge
      await fetchServerStates();

      setState(() => isLoading = false);
    } catch (e, st) {
      debugPrint("JSON ERROR: $e");
      debugPrint("$st");
      setState(() => isLoading = false);
    }
  }

  // ---------------------------------------------------
  // LOAD FROM SINGLE JSON STRING (FAST)
  // ---------------------------------------------------
  void loadSavedLocal() {
    final key = "LF_DATA_${widget.diagnosisId}_${widget.patientId}";
    final savedJson = AppPreference().getString(key);

    debugPrint("LOAD LOCAL KEY -> $key");
    debugPrint(
      "SAVED JSON PREVIEW -> ${savedJson.isNotEmpty ? savedJson.substring(0, savedJson.length.clamp(0, 120)) : 'EMPTY'}",
    );

    if (savedJson.isEmpty) return;

    try {
      final decoded = jsonDecode(savedJson) as Map<String, dynamic>;

      decoded.forEach((idx, val) {
        final parts = (val as String).split(",");
        try {
          final p = points.firstWhere((e) => e.index.toString() == idx);
          p.x = double.parse(parts[0]);
          p.y = double.parse(parts[1]);
          p.state = int.parse(parts[2]);
        } catch (e) {
          debugPrint("Error applying saved point $idx -> $e");
        }
      });
    } catch (e) {
      debugPrint("Error decoding saved JSON for LF: $e");
    }
  }

  // ---------------------------------------------------
  // FAST LOCAL SAVE (Only ONE write)
  // ---------------------------------------------------
  Future<void> saveAllPointsFast() async {
    Map<String, String> data = {};

    for (var p in points) {
      data[p.index.toString()] = "${p.x},${p.y},${p.state}";
    }

    final jsonData = jsonEncode(data);
    await AppPreference().setString(
      "LF_DATA_${widget.diagnosisId}_${widget.patientId}",
      jsonData,
    );

    debugPrint(
      "Saved LF_DATA length=${jsonData.length} key=LF_DATA_${widget.diagnosisId}_${widget.patientId}",
    );
  }

  // --------------------------------------------------
  // FETCH SERVER STATES
  // --------------------------------------------------
 Future<void> fetchServerStates() async {
  try {
    final form = FormData.fromMap({
      "diagnosisId": widget.diagnosisId,
      "pid": widget.patientId,
      "which": "lf",
    });

    debugPrint("FETCH SERVER STATES -> ${form.fields}");

    final response = await Dio().post(
      "https://jinreflexology.in/api1/new/get_data.php",
      data: form,
      options: Options(responseType: ResponseType.plain),
    );

    final raw = response.data.toString();

    /// 🔹 Extract pure JSON
    final start = raw.indexOf("{");
    final end = raw.lastIndexOf("}");
    if (start == -1 || end == -1 || end < start) {
      debugPrint("Invalid server response: $raw");
      return;
    }

    final jsonBody = jsonDecode(raw.substring(start, end + 1));

    if (jsonBody["success"] != 1) {
      debugPrint("Server success != 1 → $jsonBody");
      return;
    }

    /// 🔹 STEP 1: CLEAN ALL PREVIOUS STATES
    for (final p in points) {
      p.state = 1; // default / neutral
    }

    /// 🔹 STEP 2: PARSE SERVER DATA
    final String dataStr = jsonBody["data"] as String;
    final Map<int, int> serverMap = {};

    for (final item in dataStr.split(";")) {
      if (!item.contains(":")) continue;

      final parts = item.split(":");
      final idx = int.tryParse(parts[0]);
      final val = int.tryParse(parts[1]);

      if (idx != null && val != null) {
        serverMap[idx] = val;
      }
    }

    /// 🔹 STEP 3: APPLY NEW SERVER STATES
    for (final p in points) {
      final v = serverMap[p.index];
      if (v == null) continue;

      if (v == 1) {
        p.state = 2; // active
      } else if (v == -1) {
        p.state = 0; // disabled
      } else {
        p.state = 1; // neutral
      }
    }

    debugPrint("Server states applied successfully");
  } catch (e, st) {
    debugPrint("SERVER ERROR: $e");
    debugPrint("$st");
  }
}


  // --------------------------------------------------
  // SAVE TO SERVER (Background call)
  // --------------------------------------------------
  Future<void> saveAllToServer() async {
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

    try {
      await Dio().post(
        "https://jinreflexology.in/api/save_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.patientId, // PASS patientId as pid param
          "which": "lf",
          "data": sb.toString(),
        }),
      );
      debugPrint("Saved LF to server -> length=${sb.toString().length}");
    } catch (e, st) {
      debugPrint("SAVE ERROR: $e");
      debugPrint("$st");
    }
  }

  // --------------------------------------------------
  // CAPTURE SCREENSHOT
  // --------------------------------------------------
  Future<String?> captureScreenshot() async {
    try {
      final boundary =
          screenshotKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint("captureScreenshot: boundary is null");
        return null;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        debugPrint("captureScreenshot: byteData is null");
        return null;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final String base64Str = base64Encode(pngBytes);

      debugPrint(
        "captureScreenshot: size=${pngBytes.lengthInBytes}, base64Len=${base64Str.length}",
      );
      return base64Str;
    } catch (e, st) {
      debugPrint("Screenshot error: $e");
      debugPrint("$st");
      return null;
    }
  }

  // --------------------------------------------------
  // ENCODE TAGS FOR SERVER (if_result FORMAT)
  // --------------------------------------------------
  String _encodeTagsForServer() {
    // Group by state: 1=red, 2=green
    final redTags = <String>[];
    final greenTags = <String>[];

    for (var point in points) {
      if (point.state == 1) {
        // red
        redTags.add(point.tag);
      } else if (point.state == 2) {
        // green
        greenTags.add(point.tag);
      }
    }

    // Format: Head | Solar Plexus|Small Intestine|Ear|Urinary
    final resultBuffer = StringBuffer();

    // Add red tags first (if any)
    if (redTags.isNotEmpty) {
      resultBuffer.write(redTags.join('|'));
    }

    // Add separator if both red and green exist
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
  // DOT UI
  // --------------------------------------------------
  Widget _buildDot(PointData p, double scale) {
    Color color;
    if (p.state == 1)
      color = Color(0xFF8B0000);
    else if (p.state == 2)
      color = Colors.green;
    else
      color = Colors.transparent;

    return GestureDetector(
      onTap: () {
        setState(() {
          p.state = (p.state + 1) % 3;
          Utils().showToastMessage(p.tag);
        });
      },
      child: Container(
        width: 15 * scale,
        height: 15 * scale,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent, width: 2),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // SAVE TAGS TO SERVER (Additional API call if needed)
  // --------------------------------------------------
  Future<void> _saveTagsToServer(String encodedTags) async {
    try {
      await Dio().post(
        "https://jinreflexology.in/api/save_tags.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.patientId,
          "which": "lf",
          "tags": encodedTags,
          "timestamp": DateTime.now().toString(),
        }),
      );
      debugPrint("Saved tags to server: $encodedTags");
    } catch (e) {
      debugPrint("Error saving tags: $e");
    }
  }

  String _encodeIfData() {
    final List<String> items = [];

    for (var point in points) {
      int serverValue;
      if (point.state == 2) {
        serverValue = 1;
      } else if (point.state == 1) {
        serverValue = 0;
      } else {
        serverValue = -1;
      }

      items.add("${point.index}:$serverValue");
    }
    return items.join(";");
  }

  Future<void> _saveAndExit() async {
    final encodedTags = _encodeTagsForServer();
    await saveAllPointsFast();
    final encodedIfData = _encodeIfData();
    final base64 = await captureScreenshot();
    if (base64 != null) {
      await AppPreference().setString(
        "LF_IMG_${widget.diagnosisId}_${widget.patientId}",
        base64,
      );
      debugPrint(
        "Saved LF image key=LF_IMG_${widget.diagnosisId}_${widget.patientId} length=${base64.length}",
      );
    } else {
      debugPrint("LF screenshot returned null");
    }
    await AppPreference().setBool(
      "LF_SAVED_${widget.diagnosisId}_${widget.patientId}",
      true,
    );
    debugPrint("=== LF COMPLETE DATA ===");
    debugPrint("if_result format: $encodedTags");
    debugPrint("if_data format: $encodedIfData");
    for (var point in points) {
      int serverValue;
      if (point.state == 2) {
        serverValue = 1;
      } else if (point.state == 1) {
        serverValue = 0;
      } else {
        serverValue = -1;
      }

      debugPrint(
        "Point ${point.index} (${point.tag}): "
        "UI State=${point.state}, "
        "Server Value=$serverValue, "
        "Position=${point.x},${point.y}",
      );
    }
    debugPrint("=========================");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saving data..."), duration: Duration(seconds: 2)),
    );
    final Map<String, dynamic> resultData = {
      'if_result': encodedTags,
      'if_data': encodedIfData,
      'screenshot_base64': base64,
      'points_count': points.length,
      'selected_points': points.where((p) => p.state != 0).length,
      // 'diagnosisId': widget.diagnosisId,
      // 'patientId': widget.patientId,
      'timestamp': DateTime.now().toString(),
    };
    Navigator.pop(context, resultData);
    saveAllToServer();
    _saveTagsToServer(encodedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Left Foot Editor"),
      // appBar: AppBar(
      //   title: Text("Left Foot Editor"),
      //   backgroundColor: Colors.green,
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        label: Text("Save", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: AspectRatio(
                  aspectRatio: baseWidth / baseHeight,
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final double scaleX = c.maxWidth / baseWidth;
                      final double scaleY = c.maxHeight / baseHeight;
                      final double scale = (scaleX + scaleY) / 2;
                      return RepaintBoundary(
                        key: screenshotKey,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/left_foot_new.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            ...points.map((p) {
                              double rightOffset =
                                  5 * scaleX; // value adjust kar (5–15 try kar)
                              double topOffset = -1 * scaleY;
                              return Positioned(
                                left: p.x * scaleX + rightOffset,
                                top: (p.y * scaleY) + topOffset,
                                child: _buildDot(p, scale),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
