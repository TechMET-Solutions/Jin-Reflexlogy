import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:jin_reflex_new/api_service/global/utils.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/urls.dart';
import 'package:jin_reflex_new/screens/Diagnosis/left_foot_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/left_hand_sc.dart';
import 'package:jin_reflex_new/screens/Diagnosis/right_hand_sc.dart';
import 'package:jin_reflex_new/screens/Diagnosis/right_screen.dart';
import 'package:jin_reflex_new/screens/right_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:path_provider/path_provider.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({
    super.key,
    this.patient_id,
    this.name,
    this.diagnosis_id,
    this.gender,
  });

  // keep dynamic for flexibility (int or String)
  final dynamic patient_id;
  final dynamic name;
  final dynamic diagnosis_id;
  final String? gender;

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String? satisfaction = "Yes";
  final TextEditingController matchedProblem = TextEditingController();
  final TextEditingController notDetected = TextEditingController();

  // Track which parts are completed
  bool lfSaved = false;
  bool rfSaved = false;
  bool lhSaved = false;
  bool rhSaved = false;

  // Store results
  String? lfData;
  String? lfImg64;
  String? lfResult;
  String? rfData;
  String? rfResult;
  String? rfImg;
  String? rhData;
  String? rhResult;
  String? rhImg;
  String? lhData;
  String? lhResult;
  String? lhImg;

  bool isLoading = false;

  final List<Map<String, dynamic>> diagnosisOptions = [
    {
      "title": "Diagnose Left Foot",
      "type": "lf",
      "screen": LeftFootScreenNew(
        diagnosisId: "", // Will be set dynamically
        patientId: "", // Will be set dynamically
      ),
    },
    {
      "title": "Diagnose Right Foot",
      "type": "rf",
      "screen": rightFootScreenNew(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
    {
      "title": "Diagnose Left Hand",
      "type": "lh",
      "screen": LeftHandScreen(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
    {
      "title": "Diagnose Right Hand",
      "type": "rh",
      "screen": RightHandScreen(
        pid: "", // Will be set dynamically
        diagnosisId: "", // Will be set dynamically
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  double uploadProgress = 0.0;
  void showSnack(BuildContext context, String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Check if all four parts are completed
  bool get allPartsCompleted {
    return lfSaved && rfSaved && lhSaved && rhSaved;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Confirm Exit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: const Text(
                    "Your data will not be saved if you go back.\nAre you sure you want to exit?",
                    style: TextStyle(fontSize: 15, height: 1.4),
                  ),
                  actionsPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  actions: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },

      child: Scaffold(
        backgroundColor: const Color(0xffF7F3EB),
        appBar: CommonAppBar(title: "Diagnosis"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF9CF63),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient ID : ${widget.patient_id}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Patient Name : ${widget.name}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Diagnosis Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xffF9CF63),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Center(
                  child: Text(
                    "Diagnosis",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Diagnosis Options with status indicators
              ...diagnosisOptions.map((option) {
                String type = option["type"];
                bool isCompleted = false;
                String result = "";

                switch (type) {
                  case "lf":
                    isCompleted = lfSaved;
                    result = lfResult ?? "";
                    break;
                  case "rf":
                    isCompleted = rfSaved;
                    result = rfResult ?? "";
                    break;
                  case "lh":
                    isCompleted = lhSaved;
                    result = lhResult ?? "";
                    break;
                  case "rh":
                    isCompleted = rhSaved;
                    result = rhResult ?? "";
                    break;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isCompleted ? Colors.green : const Color(0xffF9CF63),
                      width: isCompleted ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isCompleted
                                ? Colors.green
                                : const Color(0xffF9CF63),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          type.toUpperCase(),
                          style: TextStyle(
                            color: isCompleted ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      option["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    subtitle:
                        isCompleted && result.isNotEmpty
                            ? Text(
                              "Result: $result",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                            : null,
                    trailing: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : Icons.arrow_forward_ios,
                      color: isCompleted ? Colors.green : Colors.grey,
                      size: 20,
                    ),
                    onTap: () async {
                      dynamic result;

                      if (type == "lf") {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => LeftFootScreenNew(
                                  diagnosisId: widget.diagnosis_id.toString(),
                                  patientId: widget.patient_id.toString(),
                                ),
                          ),
                        );
                      } else if (type == "rf") {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => rightFootScreenNew(
                                  pid: widget.patient_id.toString(),
                                  diagnosisId: widget.diagnosis_id.toString(),
                                ),
                          ),
                        );
                      } else if (type == "rh") {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RightHandScreen(
                                  pid: widget.patient_id.toString(),
                                  diagnosisId: widget.diagnosis_id.toString(),
                                  gender: widget.gender,
                                ),
                          ),
                        );
                      } else if (type == "lh") {
                        result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => LeftHandScreen(
                                  pid: widget.patient_id.toString(),
                                  diagnosisId: widget.diagnosis_id.toString(),
                                  gender: widget.gender,
                                ),
                          ),
                        );
                      }

                      if (result != null && result is Map) {
                        debugPrint("⬅️ Data received from $type: $result");

                        setState(() {
                          switch (type) {
                            case "lf":
                              lfSaved = true;
                              lfResult = result['if_result'];
                              lfData = result['if_data'];
                              lfImg64 = result['screenshot_base64'];
                              debugPrint("LF RESULT => $lfResult");
                              break;
                            case "rf":
                              rfSaved = true;
                              rfData = result["rf_data"];
                              rfResult = result["rf_result"];
                              rfImg = result["rf_img"];
                              break;
                            case "rh":
                              rhSaved = true;
                              rhData = result["rh_data"];
                              rhResult = result["rh_result"];
                              rhImg = result["rh_img"];
                              break;
                            case "lh":
                              lhSaved = true;
                              lhData = result["lh_data"];
                              lhResult = result["lh_result"];
                              lhImg = result["lh_img"];
                              break;
                          }
                        });

                        // Show success message
                        if (mounted) {
                          showSnack(
                            context,
                            "${option["title"]} completed successfully!",
                          );
                        }
                      }
                    },
                  ),
                );
              }),

              // Status Summary
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusIndicator("LF", lfSaved),
                    _statusIndicator("RF", rfSaved),
                    _statusIndicator("LH", lhSaved),
                    _statusIndicator("RH", rhSaved),
                  ],
                ),
              ),

              // Satisfaction Section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Are You Satisfied with the Diagnosis?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: "Yes",
                            groupValue: satisfaction,
                            title: const Text("Yes"),
                            activeColor: Colors.orange,
                            onChanged: (value) {
                              setState(() => satisfaction = value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: "No",
                            groupValue: satisfaction,
                            title: const Text("No"),
                            activeColor: Colors.orange,
                            onChanged: (value) {
                              setState(() => satisfaction = value);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    _textInput(
                      "Which of the Diagnosis points match your problem?",
                      matchedProblem,
                    ),

                    const SizedBox(height: 12),

                    _textInput(
                      "Which problems were not detected?",
                      notDetected,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _button(
                "Cancel",
                Colors.black87,
                () => Navigator.pop(context),
                isEnabled: true,
              ),
              allPartsCompleted
                  ? InkWell(
                    onTap:
                        isLoading
                            ? null
                            : () {
                              if (matchedProblem.text.isEmpty) {
                                Utils().showToastMessage(
                                  "plse enter Which of the Diagnosis points match your problem?",
                                );
                                return;
                              }
                              if (matchedProblem.text.isEmpty) {
                                Utils().showToastMessage("message");
                                return;
                              }
                              submitDiagnosis();
                            },
                    borderRadius: BorderRadius.circular(30),
                    child:
                        isLoading
                            ? _loadingButton()
                            : _button("Submit", Colors.green, () {
                              submitDiagnosis();
                            }, isEnabled: true),
                  )
                  : _button("Submit", Colors.grey, () {
                    showSnack(
                      context,
                      "Please complete all 4 diagnosis parts first!",
                      error: true,
                    );
                  }, isEnabled: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? Colors.green.shade800 : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isCompleted ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isCompleted ? "✓ Done" : "Pending",
          style: TextStyle(
            color: isCompleted ? Colors.green : Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _textInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
    );
  }

  Widget _button(
    String label,
    Color color,
    VoidCallback onTap, {
    bool isEnabled = true,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? color : Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isEnabled ? Colors.white : Colors.grey,
          fontSize: 15,
        ),
      ),
    );
  }

  Future<String?> compressBase64Image(String? base64Image) async {
    if (base64Image == null || base64Image.isEmpty) {
      return null;
    }

    try {
      // Base64 string ला Uint8List मध्ये convert करा
      Uint8List imageBytes = base64Decode(base64Image);

      // Image size check करा
      int originalSize = imageBytes.lengthInBytes;
      debugPrint("Original image size: ${originalSize ~/ 1024} KB");

      // जर image 500KB पेक्षा लहान असेल तर compress करू नका
      if (originalSize < 500 * 1024) {
        return base64Image; // Original image return करा
      }

      // Quality based on size
      int quality = 70;
      if (originalSize > 2 * 1024 * 1024) {
        // 2MB पेक्षा मोठं
        quality = 50;
      } else if (originalSize > 1 * 1024 * 1024) {
        // 1MB पेक्षा मोठं
        quality = 60;
      }

      // Image compress करा
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 800,
        minWidth: 800,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes != null) {
        String compressedBase64 = base64Encode(compressedBytes);
        debugPrint(
          "Compressed image size: ${compressedBase64.length ~/ 1024} KB",
        );
        debugPrint(
          "Compression ratio: ${(compressedBase64.length / base64Image.length * 100).toStringAsFixed(1)}%",
        );

        return compressedBase64;
      }

      return base64Image; // जर compress fail झालं तर original return करा
    } catch (e) {
      debugPrint("Image compression error: $e");
      return base64Image; // Error आल्यास original return करा
    }
  }

  Future<void> submitDiagnosis() async {
    setState(() {
      isLoading = true;
      uploadProgress = 0.0;
    });

    try {
      // Debug: Original sizes
      debugPrint("=== Original Image Sizes ===");
      if (lfImg64 != null) debugPrint("LF: ${lfImg64!.length ~/ 1024} KB");
      if (rfImg != null) debugPrint("RF: ${rfImg!.length ~/ 1024} KB");
      if (lhImg != null) debugPrint("LH: ${lhImg!.length ~/ 1024} KB");
      if (rhImg != null) debugPrint("RH: ${rhImg!.length ~/ 1024} KB");

      // सर्व images compress करा
      // showSnack(context, "Compressing images...", duration: 2);

      // Parallel compression
      List<Future> compressionTasks = [];

      String? compressedLfImg;
      String? compressedRfImg;
      String? compressedLhImg;
      String? compressedRhImg;

      // प्रत्येक image साठी compress करा
      if (lfImg64 != null && lfImg64!.isNotEmpty) {
        compressionTasks.add(
          compressBase64Image(lfImg64!).then((value) {
            compressedLfImg = value;
          }),
        );
      }

      if (rfImg != null && rfImg!.isNotEmpty) {
        compressionTasks.add(
          compressBase64Image(rfImg!).then((value) {
            compressedRfImg = value;
          }),
        );
      }

      if (lhImg != null && lhImg!.isNotEmpty) {
        compressionTasks.add(
          compressBase64Image(lhImg!).then((value) {
            compressedLhImg = value;
          }),
        );
      }

      if (rhImg != null && rhImg!.isNotEmpty) {
        compressionTasks.add(
          compressBase64Image(rhImg!).then((value) {
            compressedRhImg = value;
          }),
        );
      }

      // Wait for all compression to complete
      if (compressionTasks.isNotEmpty) {
        await Future.wait(compressionTasks);

        // Debug: Compressed sizes
        debugPrint("=== Compressed Image Sizes ===");
        if (compressedLfImg != null)
          debugPrint("LF: ${compressedLfImg!.length ~/ 1024} KB");
        if (compressedRfImg != null)
          debugPrint("RF: ${compressedRfImg!.length ~/ 1024} KB");
        if (compressedLhImg != null)
          debugPrint("LH: ${compressedLhImg!.length ~/ 1024} KB");
        if (compressedRhImg != null)
          debugPrint("RH: ${compressedRhImg!.length ~/ 1024} KB");
      }

      // Calculate total size
      int totalSize = 0;
      totalSize += compressedLfImg?.length ?? 0;
      totalSize += compressedRfImg?.length ?? 0;
      totalSize += compressedLhImg?.length ?? 0;
      totalSize += compressedRhImg?.length ?? 0;

      debugPrint("Total size to upload: ${totalSize ~/ 1024} KB");

      // जर खूप मोठं असेल तर warning
      if (totalSize > 5 * 1024 * 1024) {
        // 5MB
        showSnack(
          context,
          "Warning: Large data size (${totalSize ~/ 1024}KB). Upload may take time.",
          error: true,
        );
      }

      FormData formData = FormData.fromMap({
        "lf_data": lfData ?? "",
        "lf_img":
            lfImg64 ?? (lfImg64 ?? ""), // जर compress fail झालं तर original
        "lf_result": lfResult ?? "",
        "rf_data": rfData ?? "",
        "rf_img": rfImg ?? (rfImg ?? ""),
        "rf_result": rfResult ?? "",
        "lh_data": lhData ?? "",
        "lh_img": lhImg ?? (lhImg ?? ""),
        "lh_result": lhResult ?? "",
        "rh_data": rhData ?? "",
        "rh_img": rhImg ?? (rhImg ?? ""),
        "rh_result": rhResult ?? "",
        "problems_matched": matchedProblem.text,
        "not_detected": notDetected.text,
        "patient_id": widget.patient_id,
        "pid": AppPreference().getString(PreferencesKey.userId).toString(),
        "diagnosis_id": widget.diagnosis_id,
        "is_satisfied": satisfaction ?? "Yes",
        "timestamp": DateTime.now().toString().replaceAll(" ", "+"),
      });

      final dio = Dio();

      // Increase timeout for large uploads
      dio.options.connectTimeout = Duration(seconds: 60);
      dio.options.receiveTimeout = Duration(seconds: 60);
      dio.options.sendTimeout = Duration(seconds: 120);

      // showSnack(context, "Uploading data...", duration: 2);

      final response = await dio.post(
        add_diagnosis,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
          responseType: ResponseType.plain,
          headers: {'Connection': 'keep-alive'},
        ),
        onSendProgress: (sent, total) {
          if (total != -1) {
            double progress = (sent / total) * 100;
            if (mounted) {
              setState(() {
                uploadProgress = progress;
              });
            }

            // Debug progress
            debugPrint(
              "Upload: ${sent ~/ 1024}KB / ${total ~/ 1024}KB (${progress.toStringAsFixed(1)}%)",
            );
          }
        },
      );
      // 🔍 DEBUG: FormData fields
      debugPrint("===== FORM DATA FIELDS =====");
      for (var field in formData.fields) {
        debugPrint(
          "${field.key} => ${field.value.length > 100 ? field.value.substring(0, 100) + '...' : field.value}",
        );
      }

      // 🔍 DEBUG: FormData files
      debugPrint("===== FORM DATA FILES =====");
      for (var file in formData.files) {
        debugPrint("${file.key} => ${file.value.filename}");
      }

      debugPrint("STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        setState(() {
          uploadProgress = 100;
        });

        await Future.delayed(Duration(milliseconds: 500));

        showSnack(context, "Diagnosis Submitted Successfully!");

        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        showSnack(context, "Server error: ${response.statusCode}", error: true);
      }
    } catch (e) {
      debugPrint("API ERROR: $e");

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          showSnack(
            context,
            "Connection timeout. Check internet.",
            error: true,
          );
        } else if (e.type == DioExceptionType.sendTimeout) {
          showSnack(context, "Upload timeout. Images too large.", error: true);
        } else if (e.response != null) {
          showSnack(
            context,
            "Server error: ${e.response!.statusCode}",
            error: true,
          );
        } else {
          showSnack(context, "Network error: ${e.message}", error: true);
        }
      } else {
        showSnack(context, "Error: $e", error: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _loadingButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              value: uploadProgress / 100,
              strokeWidth: 3,
              backgroundColor: Colors.green.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${uploadProgress.toStringAsFixed(0)}%",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
