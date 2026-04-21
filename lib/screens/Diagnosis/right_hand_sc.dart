import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/global/utils.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:image/image.dart' as img;
import 'package:screenshot/screenshot.dart';

const String _diagnosisImageFlipPrefKey = "diagnosisImageFlip";

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
class RightHandScreen extends StatefulWidget {
  final String diagnosisId;
  final String pid;
  final String? gender;

  const RightHandScreen({
    Key? key,
    required this.diagnosisId,
    required this.pid,
    this.gender,
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
    debugPrint("👤 RH Gender: ${widget.gender}");
    loadPoints();
  }

  /// --------------------------------------------------
  /// LOAD POINTS BASED ON GENDER
  bool _loadedOnce = false;

  Future<void> loadPoints() async {
    if (_loadedOnce) return; // ✅ HOT RELOAD SAFE
    _loadedOnce = true;

    try {
      final normalizedGender = (widget.gender ?? "").trim().toLowerCase();
      final isFemale = normalizedGender == "female" || normalizedGender == "f";
      final jsonPath =
          isFemale ? "assets/right_handf_btn.json" : "assets/right_hand_btn.json";

      final jsonString = await rootBundle.loadString(jsonPath);
      final jsonMap = jsonDecode(jsonString);

      points =
          (jsonMap["RightHand"] as List)
              .map((e) => PointData.fromJson(e))
              .toList();

      final hasLocalDraft =
          AppPreference()
              .getString("RH_DATA_${widget.diagnosisId}_${widget.pid}")
              .isNotEmpty;

      loadSavedState();
      if (!hasLocalDraft) {
        await fetchServer();
      }

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("❌ RH LOAD ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  /// --------------------------------------------------
  /// LOAD SAVED STATE (LOCAL)
  void loadSavedState() {
    final key = "RH_DATA_${widget.diagnosisId}_${widget.pid}";
    final raw = AppPreference().getString(key);
    if (raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    decoded.forEach((idx, val) {
      final parts = val.split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);

      p.x = double.parse(parts[0]); // ✅ restore X
      p.y = double.parse(parts[1]); // ✅ restore Y
      p.state = int.parse(parts[2]);
    });
  }

  /// --------------------------------------------------
  /// SAVE FAST LOCAL
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

  /// --------------------------------------------------_buildDot
  /// FETCH SERVER DATA
  Future<void> fetchServer() async {
    try {
      final res = await Dio().post(
        "https://jinreflexology.in/api1/get_data.php",
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
        p.state =
            val == 1
                ? 2
                : val == -1
                ? 0
                : 1;
      }
    } catch (e) {
      debugPrint("❌ RH SERVER ERROR: $e");
    }
  }

  /// --------------------------------------------------
  /// ENCODE DATA
  String encodeRhData() {
    StringBuffer sb = StringBuffer();
    for (var p in points) {
      int serverValue = p.state == 2 ? 1 : (p.state == 1 ? 0 : -1);
      sb.write("${p.index}:$serverValue;");
    }
    return sb.toString();
  }

  String encodeRhResult() {
    final Set<String> tags = {};
    for (var p in points) {
      if (p.state != 0 && p.tag.isNotEmpty) tags.add(p.tag);
    }
    return tags.join("|");
  }

  /// --------------------------------------------------
  /// SCREENSHOT
  ScreenshotController screenshotController = ScreenshotController();
  Future<String?> captureScreenshot() async {
    try {
      final bytes = await screenshotController.capture(
        pixelRatio: 2,
        delay: const Duration(milliseconds: 350),
      );

      if (bytes == null) return null;

      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      if (AppPreference().getBool(_diagnosisImageFlipPrefKey, defValue: true)) {
        image = img.flipVertical(image);
      }
      image = img.copyResize(image, width: 900);
      final compressed = img.encodePng(image, level: 6);

      return base64Encode(compressed);
    } catch (e) {
      debugPrint("Screenshot error: $e");
      return null;
    }
  }

  // Future<String?> captureScreenshot() async {
  //   try {
  //     await WidgetsBinding.instance.endOfFrame;
  //     await Future.delayed(const Duration(milliseconds: 80));

  //     final boundary =
  //         screenshotKey.currentContext?.findRenderObject()
  //             as RenderRepaintBoundary?;

  //     if (boundary == null) return null;

  //     final image = await boundary.toImage(
  //       pixelRatio: MediaQuery.of(context).devicePixelRatio,
  //     );

  //     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //     if (byteData == null) return null;

  //     final bytes = byteData.buffer.asUint8List();

  //     final decoded = img.decodeImage(bytes);
  //     if (decoded == null) return null;

  //     /// ⭐ ALWAYS fix orientation (NO detection needed)
  //     final fixed = img.flipVertical(decoded); // ← main fix

  //     return base64Encode(img.encodePng(fixed));
  //   } catch (e) {
  //     debugPrint("Screenshot error: $e");
  //     return null;
  //   }
  // }

  /// --------------------------------------------------
  /// SAVE & EXIT
  Future<void> _saveAndExit() async {
    await saveAllPointsFast();

    final base64 = await captureScreenshot();

    Navigator.pop(context, {
      "rh_data": encodeRhData(),
      "rh_result": encodeRhResult(),
      "rh_img": base64,
    });
  }

  double _dotSize(double scaleX, double scaleY) {
    return 25 * ((scaleX + scaleY) / 2);
  }

 Widget _buildDot(PointData p, double dotSize) {
 
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

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(p.tag), duration: Duration(milliseconds: 500)),
      );
    },

    onPanUpdate: (details) {
      // setState(() {
      //   p.x += details.delta.dx / scaleX;
      //   p.y += details.delta.dy / scaleY;
      // });
    },

     child: Container(
       width: dotSize,
       height: dotSize,
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
    double screenW = MediaQuery.of(context).size.width * 0.90;
    double screenH = MediaQuery.of(context).size.height * 10;

    double containerW = math.min(screenW, screenH * desiredAspect);
    double containerH = containerW / desiredAspect;

    double scaleX = containerW / baseWidth;
    double scaleY = containerH / baseHeight;
    final double dotSize = _dotSize(scaleX, scaleY);

    return Scaffold(
      appBar: CommonAppBar(title: "Right Hand"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndExit,
        label: const Text("Save", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: SizedBox(
                    width: containerW,
                    height: containerH,
                    child: Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "assets/images/HandRight_final.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                           ...points.map(
                             (p) => Positioned(
                               left: (p.x * scaleX) - (dotSize / 2),
                               top: (p.y * scaleY) - (dotSize / 2),
                               child: _buildDot(p, dotSize),
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
