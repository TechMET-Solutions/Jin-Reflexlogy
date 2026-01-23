import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

/// --------------------------------------------------
/// MODEL
/// --------------------------------------------------
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
      id: json["id"].toString(),
      x: (json["x"] as num).toDouble(),
      y: (json["y"] as num).toDouble(),
      tag: json["tag"] ?? "",
      index: json["index"],
      group: json["group"] ?? "",
      state: 0,
    );
  }
}

/// --------------------------------------------------
/// SCREEN
/// --------------------------------------------------
class LeftHandScreen extends StatefulWidget {
  final String diagnosisId;
  final String pid;
  final String? gender;

  const LeftHandScreen({
    Key? key,
    required this.diagnosisId,
    required this.pid,
    this.gender,
  }) : super(key: key);

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
    debugPrint("👤 LH Gender: ${widget.gender}");
    loadPoints();
  }

  /// --------------------------------------------------
  /// LOAD POINTS BASED ON GENDER
  Future<void> loadPoints() async {
    try {
      final jsonPath =
          widget.gender?.toLowerCase() == "female"
              ? "assets/left_hand_btnf.json"
              : "assets/left_hand_btn.json";

      debugPrint("📄 Loading LH JSON: $jsonPath");

      final jsonString = await rootBundle.loadString(jsonPath);
      final jsonMap = jsonDecode(jsonString);

      points =
          (jsonMap["LeftHand"] as List)
              .map((e) => PointData.fromJson(e))
              .toList();

      loadSavedLocal();
      await fetchServer();

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("❌ LH LOAD ERROR: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// --------------------------------------------------
  /// LOAD SAVED LOCAL
  void loadSavedLocal() {
    final key = "LH_DATA_${widget.diagnosisId}_${widget.pid}";
    final raw = AppPreference().getString(key);
    if (raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);
      // p.state = int.parse(parts[2]);
      p.x = double.parse(parts[0]);   // ✅ restore X
p.y = double.parse(parts[1]);   // ✅ restore Y
p.state = int.parse(parts[2]);  // ✅ restore state

    });
  }

  /// --------------------------------------------------
  /// SAVE LOCAL FAST
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

  /// --------------------------------------------------
  /// FETCH SERVER DATA
  Future<void> fetchServer() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/get_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "lh",
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
        p.state = val == 1 ? 2 : (val == -1 ? 0 : 1);
      }
    } catch (e) {
      debugPrint("❌ LH SERVER ERROR: $e");
    }
  }

  /// --------------------------------------------------
  /// ENCODE DATA
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
      if (p.state != 0 && p.tag.isNotEmpty) tags.add(p.tag);
    }
    return tags.join("|");
  }

  /// --------------------------------------------------
  /// SCREENSHOT
  Future<String?> captureScreenshot() async {
    try {
      await Future.delayed(const Duration(milliseconds: 120));
      final boundary =
          screenshotKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 2.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      return base64Encode(byteData.buffer.asUint8List());
    } catch (e) {
      debugPrint("❌ LH Screenshot error: $e");
      return null;
    }
  }

  /// --------------------------------------------------
  /// SAVE & EXIT
  Future<void> _saveAndExit() async {
    await saveAllPointsFast();
    final base64 = await captureScreenshot();

    Navigator.pop(context, {
      "lh_data": encodeLhData(),
      "lh_result": encodeLhResult(),
      "lh_img": base64,
    });
  }

  /// --------------------------------------------------
  /// DOT UI
Widget _buildDot(PointData p, double scaleX, double scaleY) {
  Color color =
      p.state == 1
          ? const Color(0xFF8B0000)
          : p.state == 2
              ? Colors.green
              : Colors.white;

  return GestureDetector(
    onTap: () {
      setState(() {
        p.state = (p.state + 1) % 3;
      });
    },

    /// 👉 DRAG MOVE
    onPanUpdate: (details) {
      // setState(() {
      //   p.x += details.delta.dx / scaleX;
      //   p.y += details.delta.dy / scaleY;

      //   // boundary
      //   // p.x = p.x.clamp(0.0, baseWidth - 20);
      //   // p.y = p.y.clamp(0.0, baseHeight - 20);

      //   debugPrint("LH DOT => id:${p.index}, x:${p.x}, y:${p.y}");
      // });
    },

    child: Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    ),
  );
}

  /// --------------------------------------------------
  /// UI
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
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: SizedBox(
                    width: containerW,
                    height: containerH,
                    child: RepaintBoundary(
                      key: screenshotKey,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "assets/images/hand2.jpeg", // same bg
                              fit: BoxFit.fill,
                            ),
                          ),
                          ...points.map(
                            (p) => Positioned(
                left: (p.x * scaleX) - 10,
                top: (p.y * scaleY) - 10,
                child: _buildDot(p, scaleX, scaleY),
                          
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
