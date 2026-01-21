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

// ------------------ MODEL ------------------
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

// ------------------ SCREEN ------------------
class LeftFootScreenNew extends StatefulWidget {
  final String diagnosisId;
  final String patientId;

  const LeftFootScreenNew({
    required this.diagnosisId,
    required this.patientId,
    Key? key,
  }) : super(key: key);

  @override
  State<LeftFootScreenNew> createState() => _LeftFootScreenNewState();
}

class _LeftFootScreenNewState extends State<LeftFootScreenNew> {
  static const double baseWidth = 340;
  static const double baseHeight = 800;

  List<PointData> points = [];
  bool isLoading = true;

  final GlobalKey screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  // --------------------------------------------------
  Future<void> loadPoints() async {
    try {
      final jsonString = await rootBundle.loadString("assets/button.json");
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> list = jsonMap["buttons"];
      points = list.map((e) => PointData.fromJson(e)).toList();

      loadSavedLocal();
      await fetchServerStates();

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("LF JSON ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  // --------------------------------------------------
  void loadSavedLocal() {
    final key = "LF_DATA_${widget.diagnosisId}_${widget.patientId}";
    final saved = AppPreference().getString(key);
    if (saved.isEmpty) return;

    final decoded = jsonDecode(saved) as Map<String, dynamic>;
    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);
      p.state = int.parse(parts[2]); // ❗ DO NOT TOUCH X,Y
    });
  }

  // --------------------------------------------------
  Future<void> fetchServerStates() async {
    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api1/new/get_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.patientId,
          "which": "lf",
        }),
        options: Options(responseType: ResponseType.plain),
      );

      final raw = response.data.toString();
      final s = raw.indexOf("{");
      final e = raw.lastIndexOf("}");
      final jsonStr = raw.substring(s, e + 1);
      final jsonBody = jsonDecode(jsonStr);

      if (jsonBody["success"] == 1) {
        final data = jsonBody["data"] as String;
        for (var item in data.split(";")) {
          if (!item.contains(":")) continue;
          final parts = item.split(":");
          final idx = int.parse(parts[0]);
          final val = int.parse(parts[1]);
          final p = points.firstWhere((e) => e.index == idx);
          if (val == 1)
            p.state = 2;
          else if (val == -1)
            p.state = 0;
          else
            p.state = 1;
        }
      }
    } catch (e) {
      debugPrint("LF SERVER ERROR: $e");
    }
  }

  Widget _buildDot(PointData p) {
    Color color =
        p.state == 1
            ? const Color.fromARGB(255, 63, 16, 12)
            : p.state == 2
            ? Colors.green
            : Colors.transparent;

    return GestureDetector(
      onTap: () {
        setState(() {
          p.state = (p.state + 1) % 3;
          Utils().showToastMessage(p.tag);
        });
      },
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }

  // --------------------------------------------------
  Future<String?> captureScreenshot() async {
    try {
      final boundary =
          screenshotKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return base64Encode(data!.buffer.asUint8List());
    } catch (e) {
      debugPrint("LF Screenshot error: $e");
      return null;
    }
  }

  // --------------------------------------------------
  Future<void> _saveAndExit() async {
    await saveAllPointsFast();
    final base64 = await captureScreenshot();
    if (base64 != null) {
      await AppPreference().setString(
        "LF_IMG_${widget.diagnosisId}_${widget.patientId}",
        base64,
      );
    }
    Navigator.pop(context, true);
    saveAllToServer();
  }

  // --------------------------------------------------
  Future<void> saveAllPointsFast() async {
    Map<String, String> data = {};
    for (var p in points) {
      data[p.index.toString()] = "${p.x},${p.y},${p.state}";
    }
    await AppPreference().setString(
      "LF_DATA_${widget.diagnosisId}_${widget.patientId}",
      jsonEncode(data),
    );
  }

  // --------------------------------------------------
  Future<void> saveAllToServer() async {
    final sb = StringBuffer();
    for (var p in points) {
      final val =
          p.state == 2
              ? 1
              : p.state == 0
              ? -1
              : 0;
      sb.write("${p.index}:$val;");
    }
    await Dio().post(
      "https://jinreflexology.in/api/save_data.php",
      data: FormData.fromMap({
        "diagnosisId": widget.diagnosisId,
        "pid": widget.patientId,
        "which": "lf",
        "data": sb.toString(),
      }),
    );
  }

  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double desiredAspect = baseWidth / baseHeight;
    double screenW = MediaQuery.of(context).size.width * 0.95;
    double screenH = MediaQuery.of(context).size.height * 0.8;

    double containerW = math.min(screenW, screenH * desiredAspect);
    double containerH = containerW / desiredAspect;

    double scaleX = containerW / baseWidth;
    double scaleY = containerH / baseHeight;

    return Scaffold(
      appBar: CommonAppBar(title: "Left Foot Editor"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        label: Text("Save", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: Container(
                  width: containerW,
                  height: containerH,
                  child: RepaintBoundary(
                    key: screenshotKey,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/left_foot_test.jpeg',
                          width: containerW,
                          height: containerH,
                          fit: BoxFit.contain,
                        ),
                        ...points.map((p) {
                          return Positioned(
                            left: p.x * scaleX,
                            top: p.y * scaleY,
                            child: _buildDot(p),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
