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

// --------------------------------------------------
// SCREEN
// --------------------------------------------------
class LeftHandScreen extends StatefulWidget {
  final String diagnosisId;
  final String pid;

  const LeftHandScreen({
    required this.diagnosisId,
    required this.pid,
    super.key,
  });

  @override
  State<LeftHandScreen> createState() => _LeftHandScreenState();
}

class _LeftHandScreenState extends State<LeftHandScreen> {
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
  // LOAD POINTS
  Future<void> loadPoints() async {
    try {
      final jsonString = await rootBundle.loadString(
        "assets/left_hand_btn.json",
      );

      if (!mounted) return;

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> jsonList = jsonMap["LeftHand"];

      points = jsonList.map((p) => PointData.fromJson(p)).toList();

      // loadSavedLocal();
      await fetchServer();

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("JSON ERROR: $e");
    }
  }

  // --------------------------------------------------
  // FETCH SERVER DATA
  Future<void> fetchServer() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/get_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "lh",
        }),
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (res.statusCode != 200) return;

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
        p.state = val == 1 ? 2 : (val == -1 ? 0 : 1);
      }
    } catch (e) {
      debugPrint("LH SERVER ERROR: $e");
    }
  }

  // --------------------------------------------------
  // LOAD FROM LOCAL
  void loadSavedLocal() {
    final key = "LH_DATA_${widget.diagnosisId}_${widget.pid}";
    final raw = AppPreference().getString(key);

    if (raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);
      p.x = double.parse(parts[0]);
      p.y = double.parse(parts[1]);
      p.state = int.parse(parts[2]);
    });
  }

  // --------------------------------------------------
  // SAVE LOCAL
  Future<void> saveAllPointsFast() async {
    Map<String, String> data = {};
    for (var p in points) {
      data[p.index.toString()] = "${p.x},${p.y},${p.state}";
    }

    await AppPreference().setString(
      "LH_DATA_${widget.diagnosisId}_${widget.pid}",
      jsonEncode(data),
    );
  }

  // --------------------------------------------------
  String encodeLhData() {
    StringBuffer sb = StringBuffer();
    for (var p in points) {
      int serverValue = p.state == 2 ? 1 : (p.state == 1 ? 0 : -1);
      sb.write("${p.index}:$serverValue;");
    }
    return sb.toString();
  }

  String encodeLhResult() {
    final Set<String> tags = {};
    for (var p in points) {
      if (p.state != 0 && p.tag.isNotEmpty) {
        tags.add(p.tag);
      }
    }
    return tags.join("|");
  }

  // --------------------------------------------------
  // SAVE & EXIT
  Future<void> _saveAndExit() async {
    final encodedLhData = encodeLhData();
    final encodedLhResult = encodeLhResult();

    await saveAllPointsFast();
    final base64 = await captureScreenshot();

    Navigator.pop(context, {
      "lh_data": encodedLhData,
      "lh_result": encodedLhResult,
      "lh_img": base64,
    });
  }

  // --------------------------------------------------
  // SCREENSHOT
  Future<String?> captureScreenshot() async {
    try {
      if (!mounted) return null;

      await Future.delayed(const Duration(milliseconds: 120));
      await WidgetsBinding.instance.endOfFrame;

      if (!mounted) return null;

      final boundary =
          screenshotKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      return base64Encode(byteData.buffer.asUint8List());
    } catch (e) {
      debugPrint("Screenshot error: $e");
      return null;
    }
  }

  // --------------------------------------------------
  // FIXED DOT (NO MOVE, NO COORDS)
  Widget _buildDot(PointData p) {
    Color color =
        p.state == 1
            ? Color(0xFF8B0000)
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

  // --------------------------------------------------
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
      appBar: CommonAppBar(title: "Left Hand"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        label: const Text("Save", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
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
                        Positioned.fill(
                          child: Image.asset(
                            "assets/images/hand2.jpeg", 
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
