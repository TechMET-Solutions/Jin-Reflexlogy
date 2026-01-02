import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
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
      id: json["id"],
      x: json["x"].toDouble(),
      y: json["y"].toDouble(),
      tag: json["tag"],
      index: json["index"],
      group: json["group"],
      state: 0,
    );
  }
}


class RightHandScreen extends StatefulWidget {
  final String diagnosisId;
  final String pid;

  const RightHandScreen({
    required this.diagnosisId,
    required this.pid,
    Key? key,
  }) : super(key: key);

  @override
  State<RightHandScreen> createState() => _RightHandScreenState();
}

class _RightHandScreenState extends State<RightHandScreen> {
  static const double baseWidth = 340;
  static const double baseHeight = 130;

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
  Future<void> loadPoints() async {
    try {
      final jsonString =
          await rootBundle.loadString("assets/right_hand_btn.json");
      final jsonMap = jsonDecode(jsonString);

      points = (jsonMap["RightHand"] as List)
          .map((e) => PointData.fromJson(e))
          .toList();

      loadSavedState();
      await fetchServer();

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("RH LOAD ERROR: $e");
    }
  }

  // --------------------------------------------------
  // LOAD ONLY STATE FROM LOCAL
  void loadSavedState() {
    final key = "RH_DATA_${widget.diagnosisId}_${widget.pid}";
    final raw = AppPreference().getString(key);
    if (raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);
      p.state = int.parse(parts[2]);
    });
  }

  // --------------------------------------------------
  // FAST LOCAL SAVE
  Future<void> saveAllPointsFast() async {
    Map<String, String> data = {};
    for (var p in points) {
      data[p.index.toString()] = "${p.x},${p.y},${p.state}";
    }
    await AppPreference().setString(
      "RH_DATA_${widget.diagnosisId}_${widget.pid}",
      jsonEncode(data),
    );
  }


  Future<void> fetchServer() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api/get_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "rh",
        }),
        options: Options(responseType: ResponseType.plain),
      );

      final raw = res.data.toString();
      final start = raw.indexOf("{");
      final end = raw.lastIndexOf("}");
      if (start == -1) return;

      final body = jsonDecode(raw.substring(start, end + 1));
      if (body["success"] != 1) return;

      for (var item in body["data"].split(";")) {
        if (!item.contains(":")) continue;
        final parts = item.split(":");
        final idx = int.parse(parts[0]);
        final val = int.parse(parts[1]);

        final p = points.firstWhere((e) => e.index == idx);
        p.state = val == 1 ? 2 : val == -1 ? 0 : 1;
      }
    } catch (e) {
      debugPrint("RH SERVER ERROR: $e");
    }
  }

  // --------------------------------------------------
  // ENCODE RH DATA
  String encodeRhData() {
    StringBuffer sb = StringBuffer();
    for (var p in points) {
      int serverValue =
          p.state == 2 ? 1 : (p.state == 1 ? 0 : -1);
      sb.write("${p.index}:$serverValue;");
    }
    return sb.toString();
  }

  // --------------------------------------------------
  // ENCODE RH RESULT
  String encodeRhResult() {
    final Set<String> tags = {};
    for (var p in points) {
      if (p.state != 0 && p.tag.isNotEmpty) {
        tags.add(p.tag);
      }
    }
    return tags.join("|");
  }

  // --------------------------------------------------
  // 🔥 FIXED SCREENSHOT (IMPORTANT)
  Future<String?> captureScreenshot() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      await WidgetsBinding.instance.endOfFrame;

      final boundary = screenshotKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("❌ RH boundary null");
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      return base64Encode(byteData.buffer.asUint8List());
    } catch (e) {
      debugPrint("RH Screenshot error: $e");
      return null;
    }
  }

  // --------------------------------------------------
  // SAVE & EXIT
  Future<void> _saveAndExit() async {
    final encodedRhData = encodeRhData();
    final encodedRhResult = encodeRhResult();

    await saveAllPointsFast();

    final base64 = await captureScreenshot();

    debugPrint("=== RH COMPLETE DATA ===");
    debugPrint("rh_data   : $encodedRhData");
    debugPrint("rh_result : $encodedRhResult");
    debugPrint("rh_img len: ${base64?.length}");
    debugPrint("========================");

    Navigator.pop(context, {
      "rh_data": encodedRhData,
      "rh_result": encodedRhResult,
      "rh_img": base64,
    });
  }

  // --------------------------------------------------
  // DOT UI
  Widget _buildDot(PointData p) {
    Color color =
        p.state == 1 ? Colors.red : p.state == 2 ? Colors.green : Colors.white;

    return GestureDetector(
      onTap: () => setState(() => p.state = (p.state + 1) % 3),
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

  // --------------------------------------------------
  // UI
  @override
  Widget build(BuildContext context) {
    double desiredAspect = baseWidth / baseHeight;
    double screenW = MediaQuery.of(context).size.width * 0.95;
    double screenH = MediaQuery.of(context).size.height * 0.30;

    double containerW = math.min(screenW, screenH * desiredAspect);
    double containerH = containerW / desiredAspect;

    double scaleX = containerW / baseWidth;
    double scaleY = containerH / baseHeight;

    return Scaffold(
      appBar: CommonAppBar(title:"Left Hand"),
      // appBar: AppBar(
      //   title: const Text("Right Hand Editor"),
      //   backgroundColor: Colors.green,b
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        label: const Text("Save",style: TextStyle(color:Colors.white),),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: containerW,
                height: containerH,
                child: RepaintBoundary(
                  key: screenshotKey,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/hand_right.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      ...points.map(
                        (p) => Positioned(
                          left: p.x * scaleX,
                          top: p.y * scaleY,
                          child: _buildDot(p),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
