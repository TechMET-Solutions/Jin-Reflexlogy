import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
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
      id: json['id'],
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      tag: json['tag'],
      index: json['index'],
      group: json['group'],
    );
  }
}

// ------------------ SCREEN ------------------
class rightFootScreenNew extends StatefulWidget {
  final String diagnosisId;
  final String pid;

  rightFootScreenNew({required this.diagnosisId, required this.pid});

  @override
  _rightFootScreenNewState createState() => _rightFootScreenNewState();
}

class _rightFootScreenNewState extends State<rightFootScreenNew> {
  List<PointData> points = [];
  bool isLoading = true;

  final GlobalKey screenshotKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadPoints();
  }

  // ---------------------------------------------------------
  // LOAD JSON + LOCAL + SERVER
  Future<void> loadPoints() async {
    try {
      final jsonString = await rootBundle.loadString("assets/right_foot.json");
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> pointList = jsonMap["RightFoot"];

      points = pointList.map((p) => PointData.fromJson(p)).toList();

      loadSavedLocal();

      await fetchServerData();

      setState(() => isLoading = false);
    } catch (e) {
      print("JSON ERROR: $e");
    }
  }
  String encodeRfData() {
  StringBuffer sb = StringBuffer();

  for (var p in points) {
    int serverValue;
    if (p.state == 2) {
      serverValue = 1; // GREEN
    } else if (p.state == 1) {
      serverValue = 0; // RED
    } else {
      serverValue = -1; // WHITE
    }

    sb.write("${p.index}:$serverValue;");
  }

  return sb.toString();
}
String encodeRfResult() {
  final Set<String> tags = {};

  for (var p in points) {
    if (p.state != 0 && p.tag != null && p.tag!.isNotEmpty) {
      tags.add(p.tag!);
    }
  }

  return tags.join("|");
}
Future<void> _saveAndExit() async {
  // 1. Encode
  final encodedRfData = encodeRfData();
  final encodedRfResult = encodeRfResult();

  // 2. Fast local save
  await saveAllPointsFast();

  // 3. Screenshot
  final base64 = await captureScreenshot();

  if (base64 != null) {
    await AppPreference().setString(
      "RF_IMG_${widget.diagnosisId}_${widget.pid}",
      base64,
    );
  }

  // 4. Mark completed
  await AppPreference().setBool(
    "RF_SAVED_${widget.diagnosisId}_${widget.pid}",
    true,
  );

  // 5. Debug print (VERY IMPORTANT)
  debugPrint("=== RF COMPLETE DATA ===");
  debugPrint("rf_data   : $encodedRfData");
  debugPrint("rf_result : $encodedRfResult");
  debugPrint("========================");

  // 6. Return data to DiagnosisScreen 🔥🔥
  Navigator.pop(context, {
    "rf_data": encodedRfData,
    "rf_result": encodedRfResult,
    "rf_img": base64,
    // "diagnosisId": widget.diagnosisId,
    // "patientId": widget.pid,
  });

  // 7. Background server save
  saveAllToServer();
}


  // ---------------------------------------------------------
  // FAST LOAD FROM LOCAL (ONLY STATE)
  void loadSavedLocal() {
    final key = "RF_DATA_${widget.diagnosisId}_${widget.pid}";
    final savedJson = AppPreference().getString(key);

    if (savedJson.isEmpty) return;

    final decoded = jsonDecode(savedJson) as Map<String, dynamic>;

    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);

      // ❌ DO NOT CHANGE X,Y
      // p.x = double.parse(parts[0]);
      // p.y = double.parse(parts[1]);

      p.state = int.parse(parts[2]);
    });
  }

  // ---------------------------------------------------------
  // FAST SAVE (ONE WRITE ONLY)
  Future<void> saveAllPointsFast() async {
    Map<String, String> data = {};

    for (var p in points) {
      // Save XY just for info but not used for restoring
      data[p.index.toString()] = "${p.x},${p.y},${p.state}";
    }

    String jsonData = jsonEncode(data);

    await AppPreference().setString(
      "RF_DATA_${widget.diagnosisId}_${widget.pid}",
      jsonData,
    );
  }

  // ---------------------------------------------------------
  // FETCH SERVER DATA STATES
  Future<void> fetchServerData() async {
    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api/get_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "rf",
        }),
        options: Options(responseType: ResponseType.plain),
      );

      String raw = response.data.toString();
      int s = raw.indexOf("{");
      int e = raw.lastIndexOf("}");
      String jsonStr = raw.substring(s, e + 1);

      final jsonBody = jsonDecode(jsonStr);

      if (jsonBody["success"] == 1) {
        String dataString = jsonBody["data"];

        Map<int, int> states = {};

        for (String item in dataString.split(";")) {
          if (item.contains(":")) {
            var part = item.split(":");
            states[int.parse(part[0])] = int.parse(part[1]);
          }
        }

        for (var p in points) {
          if (states.containsKey(p.index)) {
            int val = states[p.index]!;
            if (val == 1)
              p.state = 2; // GREEN
            else if (val == -1)
              p.state = 0; // WHITE
            else
              p.state = 1; // RED
          }
        }
      }
    } catch (e) {
      print("Server load error: $e");
    }

    setState(() => isLoading = false);
  }

  // ---------------------------------------------------------
  // SAVE TO SERVER (BACKGROUND)
  Future<void> saveAllToServer() async {
    StringBuffer sb = StringBuffer();

    for (var p in points) {
      int sendVal =
          (p.state == 2)
              ? 1
              : (p.state == 0)
              ? -1
              : 0;
      sb.write("${p.index}:$sendVal;");
    }

    try {
      await Dio().post(
        "https://jinreflexology.in/api1/save_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "rf",
          "data": sb.toString(),
        }),
      );
    } catch (e) {
      print("SAVE ERROR: $e");
    }
  }

  // --------------------------------------------------
  // CAPTURE SCREENSHOT
  // --------------------------------------------------
  Future<String?> captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      String base64 = base64Encode(pngBytes);
      return base64;
    } catch (e) {
      print("Screenshot error: $e");
      return null;
    }
  }

  // ---------------------------------------------------------
  // DOT UI (FIXED DOT – NO MOVE)
  Widget _buildDot(PointData p, double scaleX, double scaleY) {
    Color color;
    if (p.state == 1)
      color = Colors.red;
    else if (p.state == 2)
      color = Colors.green;
    else
      color = Colors.white;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        setState(() {
          p.state = (p.state + 1) % 3;
        });

        print(
          "RF CLICK => ID:${p.id}, Index:${p.index}, X:${p.x}, Y:${p.y}, State:${p.state}",
        );
      },

      // ❌ REMOVE onPanUpdate => fixed dot
      onPanUpdate: null,

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

  // ---------------------------------------------------------
  // SAVE & EXIT

  // ---------------------------------------------------------
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
     
      appBar:CommonAppBar(title:"Right Foot"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        backgroundColor: Colors.green,
        label:Text("Save",style: TextStyle(fontSize: 15,color: Colors.white),),
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
                          'assets/images/point_finder_rf.png',
                          width: containerW,
                          height: containerH,
                          fit: BoxFit.contain,
                        ),

                        ...points.map((p) {
                          return Positioned(
                            left: p.x * scaleX,
                            top: p.y * scaleY,
                            child: _buildDot(p, scaleX, scaleY),
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
