import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/preference/app_preference.dart';
import 'package:jin_reflex_new/utils/comman_app_bar.dart';

/// ------------------ MODEL ------------------
class PointData {
  final String id;
  double x;
  double y;
  final String tag;
  final int index;
  final String group;
  int state = 0; // 0=white, 1=red, 2=green

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

/// ------------------ SCREEN ------------------
class LeftFootScreenNew extends StatefulWidget {
  final String diagnosisId;
  final String pid;

  const LeftFootScreenNew({
    super.key,
    required this.diagnosisId,
    required this.pid,
  });

  @override
  State<LeftFootScreenNew> createState() => _LeftFootScreenNewState();
}

class _LeftFootScreenNewState extends State<LeftFootScreenNew> {
  List<PointData> points = [];
  bool isLoading = true;

  final GlobalKey screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  /// ---------------------------------------------------------
  /// LOAD JSON + LOCAL + SERVER
  Future<void> loadPoints() async {
    try {
      final jsonString = await rootBundle.loadString("assets/button.json");
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> pointList = jsonMap["buttons"];

      points = pointList.map((p) => PointData.fromJson(p)).toList();

      loadSavedLocal();
      await fetchServerData();

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("LF JSON ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  /// ---------------------------------------------------------
  /// ENCODE LF DATA
  String encodeLfData() {
    StringBuffer sb = StringBuffer();

    for (var p in points) {
      int serverValue;
      if (p.state == 2)
        serverValue = 1; // GREEN
      else if (p.state == 1)
        serverValue = 0; // RED
      else
        serverValue = -1; // WHITE

      sb.write("${p.index}:$serverValue;");
    }

    return sb.toString();
  }

  /// ---------------------------------------------------------
  /// ENCODE LF RESULT
  String encodeLfResult() {
    final Set<String> tags = {};

    for (var p in points) {
      if (p.state != 0 && p.tag.isNotEmpty) {
        tags.add(p.tag);
      }
    }

    return tags.join("|");
  }

  /// ---------------------------------------------------------
  /// SAVE & EXIT
  Future<void> _saveAndExit() async {
    final encodedLfData = encodeLfData();
    final encodedLfResult = encodeLfResult();

    await saveAllPointsFast();

    final base64 = await captureScreenshot();
    if (base64 != null) {
      await AppPreference().setString(
        "LF_IMG_${widget.diagnosisId}_${widget.pid}",
        base64,
      );
    }

    await AppPreference().setBool(
      "LF_SAVED_${widget.diagnosisId}_${widget.pid}",
      true,
    );

    debugPrint("=== LF COMPLETE DATA ===");
    debugPrint("lf_data   : $encodedLfData");
    debugPrint("lf_result : $encodedLfResult");
    debugPrint("========================");

    Navigator.pop(context, {
      "if_data": encodedLfData,
      "if_result": encodedLfResult,
      "screenshot_base64": base64,
    });

    saveAllToServer();
  }

  /// ---------------------------------------------------------
  /// LOAD LOCAL STATE
  void loadSavedLocal() {
    final key = "LF_DATA_${widget.diagnosisId}_${widget.pid}";
    final savedJson = AppPreference().getString(key);

    if (savedJson.isEmpty) return;

    final decoded = jsonDecode(savedJson) as Map<String, dynamic>;

    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);
      p.state = int.parse(parts[2]);
    });
  }

  /// ---------------------------------------------------------
  /// SAVE LOCAL FAST
  Future<void> saveAllPointsFast() async {
    Map<String, String> data = {};

    for (var p in points) {
      data[p.index.toString()] = "${p.x},${p.y},${p.state}";
    }

    await AppPreference().setString(
      "LF_DATA_${widget.diagnosisId}_${widget.pid}",
      jsonEncode(data),
    );
  }

  /// ---------------------------------------------------------
  /// FETCH SERVER STATES
  Future<void> fetchServerData() async {
    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api/get_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "lf",
        }),
        options: Options(responseType: ResponseType.plain),
      );

      final raw = response.data.toString();
      final s = raw.indexOf("{");
      final e = raw.lastIndexOf("}");
      if (s == -1 || e == -1) return;

      final jsonBody = jsonDecode(raw.substring(s, e + 1));

      if (jsonBody["success"] == 1) {
        final String dataString = jsonBody["data"];
        Map<int, int> states = {};

        for (var item in dataString.split(";")) {
          if (item.contains(":")) {
            final p = item.split(":");
            states[int.parse(p[0])] = int.parse(p[1]);
          }
        }

        for (var p in points) {
          if (states.containsKey(p.index)) {
            int v = states[p.index]!;
            if (v == 1)
              p.state = 2;
            else if (v == -1)
              p.state = 0;
            else
              p.state = 1;
          }
        }
      }
    } catch (e) {
      debugPrint("LF SERVER LOAD ERROR: $e");
    }
  }

  /// ---------------------------------------------------------
  /// SAVE SERVER
  Future<void> saveAllToServer() async {
    StringBuffer sb = StringBuffer();

    for (var p in points) {
      int sendVal =
          p.state == 2
              ? 1
              : p.state == 0
              ? -1
              : 0;
      sb.write("${p.index}:$sendVal;");
    }

    try {
      await Dio().post(
        "https://jinreflexology.in/api/save_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "lf",
          "data": sb.toString(),
        }),
      );
    } catch (e) {
      debugPrint("LF SAVE ERROR: $e");
    }
  }

  /// ---------------------------------------------------------
  /// SCREENSHOT
  Future<String?> captureScreenshot() async {
    try {
      final boundary =
          screenshotKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return base64Encode(byteData!.buffer.asUint8List());
    } catch (e) {
      debugPrint("LF Screenshot error: $e");
      return null;
    }
  }

  /// ---------------------------------------------------------
  /// DOT UI
  Widget _buildDot(PointData p) {
    Color color =
        p.state == 1
            ? Colors.red
            : p.state == 2
            ? Colors.green
            : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() => p.state = (p.state + 1) % 3);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  /// ---------------------------------------------------------
  /// UI
  @override
  Widget build(BuildContext context) {
    double desiredAspect = 340 / 800;
    double screenW = MediaQuery.of(context).size.width * 0.95;
    double screenH = MediaQuery.of(context).size.height * 0.8;

    double containerW = math.min(screenW, screenH * desiredAspect);
    double containerH = containerW / desiredAspect;

    double scaleX = containerW / 340;
    double scaleY = containerH / 800;

    return Scaffold(
      appBar: CommonAppBar(title: "Left Foot"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        label: const Text("Save", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: SizedBox(
                  width: containerW,
                  height: containerH,
                  child: RepaintBoundary(
                    key: screenshotKey,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/point_finder_lf.png',
                          fit: BoxFit.contain,
                          width: containerW,
                          height: containerH,
                        ),
                        ...points.map((p) {
                          return Positioned(
                            left: p.x * scaleX,
                            top: p.y * scaleY,
                            child: _buildDot(p),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
