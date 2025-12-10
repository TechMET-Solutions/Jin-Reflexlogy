import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';

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

  /// UI STATES:
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
class LeftFootScreenNew extends StatefulWidget {
  final String diagnosisId;
  final String pid;

  const LeftFootScreenNew({
    required this.diagnosisId,
    required this.pid,
  });

  @override
  _LeftFootScreenNewState createState() => _LeftFootScreenNewState();
}

class _LeftFootScreenNewState extends State<LeftFootScreenNew> {
  static const double baseWidth = 340;
  static const double baseHeight = 800;

  List<PointData> points = [];
  bool isLoading = true;

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

      final List<dynamic> jsonList = jsonMap["buttons"];
      points = jsonList.map((p) => PointData.fromJson(p)).toList();

      loadSavedLocalStates();

      await fetchServerStates(); // Server map apply

      setState(() => isLoading = false);

    } catch (e) {
      print("JSON ERROR: $e");
    }
  }

  // Load saved points from SharedPreferences
  void loadSavedLocalStates() {
    for (var p in points) {
      String saved = AppPreference().getString("LF_${p.index}");

      if (saved.isNotEmpty) {
        List<String> part = saved.split(",");
        p.x = double.parse(part[0]);
        p.y = double.parse(part[1]);
        p.state = int.parse(part[2]);
      }
    }
  }

  Future<void> savePointLocal(PointData p) async {
    await AppPreference().setString("LF_${p.index}", "${p.x},${p.y},${p.state}");
  }

  Future<void> saveAllPointsLocal() async {
    for (var p in points) {
      await savePointLocal(p);
    }
  }

  // --------------------------------------------------
  // FETCH SERVER STATES
  // --------------------------------------------------
  Future<void> fetchServerStates() async {
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

      // Extract pure JSON from HTML
      String raw = response.data.toString();
      int start = raw.indexOf("{");
      int end = raw.lastIndexOf("}");
      String jsonString = raw.substring(start, end + 1);

      final jsonBody = jsonDecode(jsonString);

      if (jsonBody["success"] == 1) {

        String dataStr = jsonBody["data"];

        Map<int, int> serverMap = {};

        for (String item in dataStr.split(";")) {
          if (item.contains(":")) {
            var part = item.split(":");
            serverMap[int.parse(part[0])] = int.parse(part[1]);
          }
        }

        // Map server → UI
        for (var p in points) {
          if (serverMap.containsKey(p.index)) {
            int v = serverMap[p.index]!;

            if (v == 1)
              p.state = 2; // GREEN
            else if (v == -1)
              p.state = 0; // WHITE
            else
              p.state = 1; // RED
          }
        }
      }
    } catch (e) {
      print("SERVER ERROR: $e");
    }
  }

  // --------------------------------------------------
  // SAVE TO SERVER
  // --------------------------------------------------
  Future<void> saveAllToServer() async {
    StringBuffer sb = StringBuffer();

    for (var p in points) {
      int sendVal;

      if (p.state == 2)
        sendVal = 1; // GREEN
      else if (p.state == 0)
        sendVal = -1; // WHITE
      else
        sendVal = 0; // RED

      sb.write("${p.index}:$sendVal;");
    }

    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api/save_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "lf",
          "data": sb.toString(),
        }),
      );

      print("SAVE SERVER RESPONSE: ${response.data}");
    } catch (e) {
      print("SAVE ERROR: $e");
    }
  }

  // --------------------------------------------------
  // DOT UI
  // --------------------------------------------------
  Widget _buildDot(PointData p, double scale) {
    Color color;

    if (p.state == 1)
      color = Colors.red;
    else if (p.state == 2)
      color = Colors.green;
    else
      color = Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          p.state = (p.state + 1) % 3;
        });

        savePointLocal(p);
      },
      child: Container(
        width: 18 * scale,
        height: 18 * scale,
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
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Left Foot Editor"),
        backgroundColor: Colors.green,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await saveAllPointsLocal();
          await saveAllToServer();
          Navigator.pop(context);
        },
        label: Text("Save"),
        backgroundColor: Colors.green,
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: AspectRatio(
                aspectRatio: baseWidth / baseHeight,
                child: LayoutBuilder(
                  builder: (context, c) {
                    final double scaleX = c.maxWidth / baseWidth;
                    final double scaleY = c.maxHeight / baseHeight;
                    final double scale = (scaleX + scaleY) / 2;

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/point_finder_lf.png',
                            fit: BoxFit.fill,
                          ),
                        ),

                        ...points.map((p) {
                          return Positioned(
                            left: p.x * scaleX,
                            top: p.y * scaleY,
                            child: _buildDot(p, scale),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
