import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:screenshot/screenshot.dart';

const String _diagnosisImageFlipPrefKey = "diagnosisImageFlip";

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

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    debugPrint("LH Gender: ${widget.gender}");
    loadPoints();
  }

  Future<void> loadPoints() async {
    try {
      final normalizedGender = (widget.gender ?? "").trim().toLowerCase();
      final isFemale = normalizedGender == "female" || normalizedGender == "f";
      final jsonPath =
          isFemale ? "assets/left_hand_btnf.json" : "assets/left_hand_btn.json";

      debugPrint("Loading LH JSON: $jsonPath");

      final jsonString = await rootBundle.loadString(jsonPath);
      final jsonMap = jsonDecode(jsonString);

      points =
          (jsonMap["LeftHand"] as List)
              .map((e) => PointData.fromJson(e))
              .toList();

      final hasLocalDraft =
          AppPreference()
              .getString("LH_DATA_${widget.diagnosisId}_${widget.pid}")
              .isNotEmpty;

      loadSavedLocal();
      if (!hasLocalDraft) {
        await fetchServer();
      }

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("LH LOAD ERROR: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void loadSavedLocal() {
    final key = "LH_DATA_${widget.diagnosisId}_${widget.pid}";
    final raw = AppPreference().getString(key);
    if (raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    decoded.forEach((idx, val) {
      final parts = val.toString().split(",");
      final p = points.firstWhere((e) => e.index.toString() == idx);

      // Keep JSON coordinates as the source of truth for hand layouts.
      // Restoring stale x/y can misplace female points after JSON changes.
      if (parts.length >= 3) {
        p.state = int.tryParse(parts[2]) ?? 0;
      } else if (parts.isNotEmpty) {
        p.state = int.tryParse(parts.last) ?? 0;
      }
    });
  }

  Future<void> saveAllPointsFast() async {
    final Map<String, String> data = {};
    for (final p in points) {
      data[p.index.toString()] = p.state.toString();
    }

    await AppPreference().setString(
      "LH_DATA_${widget.diagnosisId}_${widget.pid}",
      jsonEncode(data),
    );
  }

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
      if (start == -1 || end == -1) return;

      final body = jsonDecode(raw.substring(start, end + 1));
      if (body["success"] != 1) return;

      for (final item in body["data"].split(";")) {
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

  String encodeLhData() {
    final StringBuffer sb = StringBuffer();
    for (final p in points) {
      final int serverValue = p.state == 2 ? 1 : (p.state == 1 ? 0 : -1);
      sb.write("${p.index}:$serverValue;");
    }
    return sb.toString();
  }

  String encodeLhResult() {
    final Set<String> tags = {};
    for (final p in points) {
      if (p.state != 0 && p.tag.isNotEmpty) {
        tags.add(p.tag);
      }
    }
    return tags.join("|");
  }

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

  Future<void> _saveAndExit() async {
    await saveAllPointsFast();
    final base64 = await captureScreenshot();

    Navigator.pop(context, {
      "lh_data": encodeLhData(),
      "lh_result": encodeLhResult(),
      "lh_img": base64,
    });
  }

  Widget _buildDot(PointData p, double scaleX, double scaleY) {
    final double dotSize = 25 * ((scaleX + scaleY) / 2);

    final Color color =
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
          SnackBar(
            content: Text(p.tag),
            duration: const Duration(milliseconds: 500),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    final double desiredAspect = baseWidth / baseHeight;
    final double screenW = MediaQuery.of(context).size.width * 0.95;
    final double screenH = MediaQuery.of(context).size.height * 0.30;

    final double containerW = math.min(screenW, screenH * desiredAspect);
    final double containerH = containerW / desiredAspect;

    final double scaleX = containerW / baseWidth;
    final double scaleY = containerH / baseHeight;

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
                    child: Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "assets/images/Hand_Left_final.png",
                              fit: BoxFit.contain,
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
