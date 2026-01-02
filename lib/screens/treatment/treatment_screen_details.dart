import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class DiseaseModel {
  final String diseaseDetail;
  final String diseaseCauses;
  final String diseaseSymptoms;
  final String diseaseRegimen;
  final String diseaseMainPoint;
  final String diseaseRelatedPoints;
  final String diseaseMicroMagnet;
  final String image; // base64 string

  DiseaseModel({
    required this.diseaseDetail,
    required this.diseaseCauses,
    required this.diseaseSymptoms,
    required this.diseaseRegimen,
    required this.diseaseMainPoint,
    required this.diseaseRelatedPoints,
    required this.diseaseMicroMagnet,
    required this.image,
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      diseaseDetail: json['diseaseDetail'],
      diseaseCauses: json['diseaseCauses'],
      diseaseSymptoms: json['diseaseSymptoms'],
      diseaseRegimen: json['diseaseRegimen'],
      diseaseMainPoint: json['diseaseMainPoint'],
      diseaseRelatedPoints: json['diseaseRelatedPoints'],
      diseaseMicroMagnet: json['diseaseMicroMagnet'],
      image: json['image'],
    );
  }
}



class DiseaseDetailPage extends StatefulWidget {
  final name;

  const DiseaseDetailPage({super.key, this.name});
  @override
  _DiseaseDetailPageState createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  DiseaseModel? disease;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    disease = await fetchDisease();
    setState(() => loading = false);
  }




// HTML → Plain Text Convert
String cleanHtml(String htmlString) {
  final document = parse(htmlString);
  return document.body?.text.trim() ?? "";
}

  Future<DiseaseModel?> fetchDisease() async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        "a": "1",
        "name": widget.name ,
      });

      Response response = await dio.post(
        "https://jinreflexology.in/api/request_dwt.php",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 200) {
        dynamic jsonBody;

        // 🔥 Case 1: Response is String JSON
        if (response.data is String) {
          jsonBody = jsonDecode(response.data);
        }
        // 🔥 Case 2: Response is already JSON Map
        else {
          jsonBody = response.data;
        }

        // 🔥 success check
        if (jsonBody["success"] == 1) {
          // API always sends list
          var item = jsonBody["data"][0];

          return DiseaseModel.fromJson(item);
        }
      }

      return null;

    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 232, 186),
      appBar: CommonAppBar(title: "${widget.name}"),
      body: loading
          ? Center(child: CircularProgressIndicator(color: Colors.amber,))
          : disease == null
              ? Center(child: Text("No Data"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      cardWidget("${widget.name} :", disease!.diseaseDetail),
                      cardWidget("Causes :", disease!.diseaseCauses),
                      cardWidget("Symptoms :", disease!.diseaseSymptoms),
                      cardWidget("Regimen :", disease!.diseaseRegimen),
                      cardWidget("Main Point :", disease!.diseaseMainPoint),
                      cardWidget("Related Points :", disease!.diseaseRelatedPoints),
                      cardWidget("Using Micro Magnet :", disease!.diseaseMicroMagnet),
                      SizedBox(height: 15),
                      buildImageBox(disease!.image),
                    ],
                  ),
                ),
    );
  }

  Widget cardWidget(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange.shade300, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            color: Colors.orange.shade200,
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(description),
          )
        ],
      ),
    );
  }

  Widget buildImageBox(String base64String) {
    final bytes = base64Decode(base64String);

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange.shade300, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Image.memory(bytes),
    );
  }
}
