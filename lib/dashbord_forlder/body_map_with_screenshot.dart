import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:jin_reflex_new/dashbord_forlder/freddback_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'body_cell_model.dart';

class BodyMapWithScreenshot extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;
  final List<String> initialSelection;
  final GlobalKey screenshotKey;
  final String? patientId; // Added back
  final String? diagnosisId; // Added back
  final String day; // Added back

  const BodyMapWithScreenshot({
    super.key,
    required this.onSelectionChanged,
    required this.screenshotKey,
    this.initialSelection = const [],
    this.patientId,
    this.diagnosisId,
    this.day = 'first', // Default value
  });

  @override
  State<BodyMapWithScreenshot> createState() => _BodyMapWithScreenshotState();
}

class _BodyMapWithScreenshotState extends State<BodyMapWithScreenshot> {
  Set<String> selectedCells = {};
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedCells = widget.initialSelection.toSet();
  }

  void _handleTap(TapDownDetails details) {
    // Get the RenderBox of the image
    final RenderBox? renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      debugPrint('❌ RenderBox is null');
      return;
    }

    // Get local position relative to the image
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final imageSize = renderBox.size;

    debugPrint('\n🖱️ ========== TAP DETECTED ==========');
    debugPrint('Global position: ${details.globalPosition}');
    debugPrint('Local position: $localPosition');
    debugPrint('Image size: $imageSize');
    final tappedCell = BodyCellDetector.detectCell(localPosition, imageSize);
    if (tappedCell != null) {
      setState(() {
        if (selectedCells.contains(tappedCell.id)) {
          selectedCells.remove(tappedCell.id);
          debugPrint('🔴 Cell ${tappedCell.id} DESELECTED');
        } else {
          selectedCells.add(tappedCell.id);
          debugPrint('🟢 Cell ${tappedCell.id} SELECTED');
        }
      });

      // Notify parent
      widget.onSelectionChanged(selectedCells.toList());

      debugPrint('📋 Total selected cells: ${selectedCells.length}');
      debugPrint('📋 Selected: ${selectedCells.toList()}');
    }
    debugPrint('====================================\n');
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.screenshotKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTapDown: _handleTap,
            child: Stack(
              children: [
                // Background body image
                Image.asset(
                  'assets/images/fedback.jpeg',
                  key: _imageKey,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[100]!, Colors.grey[200]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.accessibility_new_rounded,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Body Map",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Cell overlay using body cell coordinates
                Positioned.fill(
                  child: CustomPaint(
                    painter: BodyCellOverlayPainter(
                      selectedCellIds: selectedCells,
                    ),
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

/// Custom painter to draw cell overlays using body cell coordinates
class BodyCellOverlayPainter extends CustomPainter {
  final Set<String> selectedCellIds;

  BodyCellOverlayPainter({required this.selectedCellIds});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw each selected cell
    for (final cell in bodyCells) {
      if (selectedCellIds.contains(cell.id)) {
        final rect = Rect.fromLTWH(
          cell.x * size.width,
          cell.y * size.height,
          cell.w * size.width,
          cell.h * size.height,
        );

        // Draw red background
        final paint =
            Paint()
              ..color = Colors.red.withOpacity(0.6)
              ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);

        // Draw border
        final borderPaint =
            Paint()
              ..color = Colors.red[700]!
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.0;
        canvas.drawRect(rect, borderPaint);

        // Draw cell ID
        final textPainter = TextPainter(
          text: TextSpan(
            text: cell.id,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 3),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            rect.center.dx - textPainter.width / 2,
            rect.center.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(BodyCellOverlayPainter oldDelegate) {
    return oldDelegate.selectedCellIds != selectedCellIds;
  }
}

// Screenshot utility class
class ScreenshotHelper {
  static void _printLongLog(String message) {
    const int chunkSize = 800;
    for (int i = 0; i < message.length; i += chunkSize) {
      final end = (i + chunkSize < message.length)
          ? i + chunkSize
          : message.length;
      debugPrint(message.substring(i, end));
    }
  }

  static String _mapPainForBackend(String severity, String day) {
    final normalizedSeverity = severity.trim();
    final normalizedKey = normalizedSeverity.toLowerCase();

    if (day == 'first') {
      switch (normalizedKey) {
        case 'severe':
          return 'severe';
        case 'moderate50':
          return 'moderate50';
        case 'mild25':
          return 'mild25';
        case 'painful':
          return 'painful';
        case 'moderate':
          return 'moderate50';
        default:
          return 'severe';
      }
    }

    switch (normalizedKey) {
      case 'fullyrecovered':
        return 'fullyRecovered';
      case 'moderate':
        return 'moderate';
      case 'temporary':
        return 'temporary';
      case 'minimild':
        return 'miniMild';
      case 'progressive':
        return 'progressive';
      case 'relax25':
        return 'relax25';
      case 'none0':
        return 'none0';
      case 'mild50':
      case 'moderate50':
        return 'moderate';
      case 'recovered':
        return 'fullyRecovered';
      case 'relax':
        return 'relax25';
      default:
        return 'fullyRecovered';
    }
  }

  static Future<File?> captureWidget(GlobalKey key) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // ⭐ add this

      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(
        pixelRatio: ui.window.devicePixelRatio,
      );

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) return null;

      final Uint8List bytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/body_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(path);
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      debugPrint("❌ Screenshot error: $e");
      return null;
    }
  }

  static Future<File> rotateForServer(File file) async {
    final bytes = await file.readAsBytes();

    final decoded = img.decodeImage(bytes);
    if (decoded == null) return file;

    // ⭐ server fix → rotate 180 only
    final rotated = img.copyRotate(decoded, angle: 180);

    final newBytes = Uint8List.fromList(img.encodePng(rotated));

    final dir = await getTemporaryDirectory();
    final newPath =
        '${dir.path}/upload_${DateTime.now().millisecondsSinceEpoch}.png';

    final newFile = File(newPath);
    await newFile.writeAsBytes(newBytes);

    return newFile;
  }

  static Future<bool> submitBodyMapData({
    required String therapistId,
    required String patientId,
    required String day,
    required List<BodyPartItem> items,
    required File? feedbackImage,
  }) async {
    try {
      List<Map<String, String>> diagnosisList = [];

      for (final item in items) {
        final String pain = _mapPainForBackend(item.severity, day);

        diagnosisList.add({"bodyPart": item.name.trim(), "pain": pain});
      }
      final diagnosisJson = jsonEncode(diagnosisList);

      _printLongLog("FINAL JSON => $diagnosisJson");

      final formData = FormData.fromMap({
        'therapistId': therapistId, // ✅ send it
        'patientId': patientId,
        'day': day,
        'diagnosis': diagnosisJson,

        if (feedbackImage != null)
          'feedbackImage': await MultipartFile.fromFile(
            feedbackImage.path,
            filename: 'feedback.png',
          ),
      });

      final dio = Dio();

      final response = await dio.post(
        'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php',
        data: formData,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (s) => s != null && s < 500,
        ),
      );
      debugPrint("📤 SENDING DATA TO API");

      for (var field in formData.fields) {
        _printLongLog("FIELD => ${field.key} : ${field.value}");
      }

      for (var file in formData.files) {
        debugPrint("FILE => ${file.key} : ${file.value.filename}");
      }
      // print(response.data);
      final body = response.data.toString();
      debugPrint("📥 RESPONSE STATUS => ${response.statusCode}");
      _printLongLog("📥 RESPONSE DATA => ${response.data}");
      if (response.statusCode == 200) {
        final decoded = jsonDecode(body);
        return decoded['success'] == true;
      }

      return false;
    } catch (e) {
      debugPrint("SUBMIT ERROR => $e");
      return false;
    }
  }
}
