import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';

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

  rightFootScreenNew({
    required this.diagnosisId,
    required this.pid,
  });

  @override
  _rightFootScreenNewState createState() => _rightFootScreenNewState();
}

class _rightFootScreenNewState extends State<rightFootScreenNew> {
  List<PointData> points = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPoints();
    fetchServerData();
  }

  // ---------------------------------------------------------
  // SAVE ONE POINT LOCALLY
  Future<void> savePoint(PointData p) async {
    String key = "RF_${p.index}";
    String value = "${p.x},${p.y},${p.state}";
    await AppPreference().setString(key, value);
  }

  // SAVE ALL POINTS LOCALLY
  Future<void> saveAllPoints() async {
    for (var p in points) {
      await savePoint(p);
    }
  }

  // ---------------------------------------------------------
  // LOAD SAVED LOCAL DATA
  void loadSavedPoints() {
    for (var p in points) {
      String key = "RF_${p.index}";
      String saved = AppPreference().getString(key);

      if (saved.isNotEmpty) {
        List<String> parts = saved.split(",");
        p.x = double.parse(parts[0]);
        p.y = double.parse(parts[1]);
        p.state = int.parse(parts[2]);
      }
    }
  }

  // ---------------------------------------------------------
  // LOAD JSON FILE POINTS
Future<void> loadPoints() async {
  try {
    final jsonString = await rootBundle.loadString("assets/right_foot.json");
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> pointList = jsonMap["RightFoot"];

    points = pointList.map((p) => PointData.fromJson(p)).toList();

    loadSavedPoints();

    // 🔥 AFTER points loaded → now apply server states
    await fetchServerData();

    setState(() {});

  } catch (e) {
    print("JSON ERROR: $e");
  }
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

      // extract json inside html
      String raw = response.data.toString();
      int s = raw.indexOf("{");
      int e = raw.lastIndexOf("}");
      String jsonStr = raw.substring(s, e + 1);

      final jsonBody = jsonDecode(jsonStr);

      if (jsonBody["success"] == 1) {
        String dataString = jsonBody["data"]; // example: 377:1;190:-1;191:1;

        Map<int, int> states = {};

        for (String item in dataString.split(";")) {
          if (item.contains(":")) {
            var part = item.split(":");
            states[int.parse(part[0])] = int.parse(part[1]);
          }
        }

        // APPLY STATE COLORS
      // APPLY STATE COLORS
for (var p in points) {
  if (states.containsKey(p.index)) {
    int val = states[p.index]!;

    if (val == 1)
      p.state = 1;   // GREEN
    else if (val == -1)
      p.state = 0;   // WHITE (empty)
    else
      p.state = 2;   // RED
  }
}

      }
    } catch (e) {
      print("Server load error: $e");
    }

    setState(() => isLoading = false);
  }

  // ---------------------------------------------------------
  // SAVE TO SERVER
  Future<void> saveAllToServer() async {
    StringBuffer sb = StringBuffer();

    for (var p in points) {
      int sendVal = (p.state == 1) ? 1 : (p.state == 2) ? -1 : 0;
      sb.write("${p.index}:$sendVal;");
    }

    try {
      final response = await Dio().post(
        "https://jinreflexology.in/api/save_data.php",
        data: FormData.fromMap({
          "diagnosisId": widget.diagnosisId,
          "pid": widget.pid,
          "which": "rf",
          "data": sb.toString(),
        }),
      );

      print("SAVE RESULT: ${response.data}");
    } catch (e) {
      print("SAVE ERROR: $e");
    }
  }

  // ---------------------------------------------------------
  // DOT UI
  Widget _buildDot(PointData p) {
    Color color;
    if (p.state == 1)
      color = Colors.red;
    else if (p.state == 2)
      color = Colors.green;
    else
      color = Colors.white;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
      ),
    );
  }

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
      appBar: AppBar(
        title: Text("Right Foot Editor"),
        backgroundColor: Colors.green,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await saveAllPoints();
          await saveAllToServer();
          Navigator.pop(context);
        },
        backgroundColor: Colors.green,
        label: Text("Save"),
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: containerW,
                height: containerH,
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
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              p.state = (p.state + 1) % 3;
                            });
                            savePoint(p);
                          },

                          onPanUpdate: (details) {
                            setState(() {
                              p.x += details.delta.dx / scaleX;
                              p.y += details.delta.dy / scaleY;
                            });
                          },

                          child: _buildDot(p),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
