import 'dart:math';

import 'package:flutter/material.dart';

/// A customizable health meter widget that displays a gauge/speedometer
/// with a rotating needle based on health value (0-100)
class HealthMeterWidget extends StatefulWidget {
  final double healthValue; // 0 to 100
  final String meterBackgroundImage;
  final String needleImage;
  final double width;
  final double height;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showValue;
  final TextStyle? valueTextStyle;

  const HealthMeterWidget({
    Key? key,
    required this.healthValue,
    required this.meterBackgroundImage,
    required this.needleImage,
    this.width = 300,
    this.height = 300,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.showValue = true,
    this.valueTextStyle,
  }) : super(key: key);

  @override
  State<HealthMeterWidget> createState() => _HealthMeterWidgetState();
}

class _HealthMeterWidgetState extends State<HealthMeterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentValue = 0; // Start at actual value

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(begin: 0, end: widget.healthValue).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    )..addListener(() {
        setState(() {
          _currentValue = _animation.value;
        });
      });

    _animationController.forward();
  }

  @override
  void didUpdateWidget(HealthMeterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.healthValue != widget.healthValue) {
      _animation = Tween<double>(
        begin: _currentValue,
        end: widget.healthValue,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: widget.animationCurve,
        ),
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Convert health value (0-100) to rotation angle
  /// Based on semi-circle meter design:
  /// 0% = -90° (POOR - left side)
  /// 50% = 0° (GOOD - straight up/middle) 
  /// 100% = 90° (EXCELLENT - right side)
  /// Convert health value (0-100) to rotation angle
/// Based on semi-circle meter design:
/// 0% = -90° (POOR - left side)
/// 50% = 0° (GOOR - straight up/middle) 
/// 100% = +90° (EXCELLENT - right side)
double _getRotationAngle(double value) {
  final v = value.clamp(0.0, 100.0);

  final degrees = (v / 100.0) * 180.0 - 180.0;

  return degrees * (3.1415926535 / 180);
}



  String _getHealthStatus(double value) {
    if (value >= 75) return 'EXCELLENT';
    if (value >= 50) return 'GOOD';
    if (value >= 25) return 'FAIR';
    return 'POOR';
  }

  Color _getHealthColor(double value) {
    if (value >= 75) return Colors.green;
    if (value >= 50) return Colors.lightGreen;
    if (value >= 25) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make responsive
        final size = constraints.maxWidth < widget.width
            ? constraints.maxWidth
            : widget.width;

        return Container(
          width: size,
          height: size * (widget.height / widget.width),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background meter image
              Positioned.fill(
                child: Image.asset(
                  widget.meterBackgroundImage,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback meter background if image not found
                    return CustomPaint(
                      painter: _MeterBackgroundPainter(),
                    );
                  },
                ),
              ),

              // Rotating needle - positioned from center bottom
// Rotating needle - positioned from center bottom
// ✅ Properly sized & centered needle
// ✅ PERFECT NEEDLE FIX
// ✅ PERFECT ROTATION FROM BOTTOM CENTER
// ✅ STABLE NEEDLE (CENTER BASED POSITION)
// ✅ PERFECT CUSTOM NEEDLE (NO IMAGE)
// ✅ GUARANTEED CENTER NEEDLE
Positioned.fill(
  child: CustomPaint(
    painter: _GaugeNeedlePainter(_currentValue),
  ),
),


              // Center pivot circle
              Positioned(
                bottom: size * 0.2,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Value display (optional)
              if (widget.showValue)
                Positioned(
                  bottom: size * 0.13,
                  child: Column(
                    children: [
                      Text(
                        '${_currentValue.toStringAsFixed(0)}%',
                        style: widget.valueTextStyle ??
                            TextStyle(
                              fontSize: size * 0.08,
                              fontWeight: FontWeight.bold,
                              color: _getHealthColor(_currentValue),
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _getHealthStatus(_currentValue),
                        style: TextStyle(
                          fontSize: size * 0.05,
                          fontWeight: FontWeight.w600,
                          color: _getHealthColor(_currentValue),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugeNeedlePainter extends CustomPainter {
  final double value;

  _GaugeNeedlePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
   final center = Offset(size.width / 2, size.height * 0.75);


    final radius = size.width * 0.40;

    final paint = Paint()
      ..color = const Color(0xFF6B2E2E)
      ..strokeWidth = size.width * 0.015
      ..strokeCap = StrokeCap.round;

    // Map 0–100 → -180° to 0°
    final angle =
        ((value.clamp(0, 100) / 100) * 180 - 180) * 3.1415926535 / 180;

    final end = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    canvas.drawLine(center, end, paint);

    // Pivot circle
    canvas.drawCircle(
      center,
      size.width * 0.025,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugeNeedlePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

/// Custom painter for fallback meter background when image is not available
class _MeterBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.4;
    final strokeWidth = 20.0;

    // Draw colored arcs for meter zones
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Red zone (0-25%) - POOR
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // Start at 180 degrees (left)
      3.14159 / 4, // 45 degrees arc
      false,
      paint,
    );

    // Orange zone (25-50%) - FAIR
    paint.color = Colors.orange;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + 3.14159 / 4,
      3.14159 / 4,
      false,
      paint,
    );

    // Yellow zone (50-75%) - GOOD
    paint.color = Colors.yellow;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + 3.14159 / 2,
      3.14159 / 4,
      false,
      paint,
    );

    // Green zone (75-100%) - EXCELLENT
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 + 3.14159 * 3 / 4,
      3.14159 / 4,
      false,
      paint,
    );

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Helper function to draw text
    void drawText(String text, Offset offset, {double fontSize = 12}) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, offset);
    }

    // Draw percentage labels
    drawText('0%', Offset(10, size.height - 20));
    drawText('25%', Offset(size.width * 0.15, size.height * 0.3));
    drawText('50%', Offset(size.width * 0.45, 10));
    drawText('75%', Offset(size.width * 0.75, size.height * 0.3));
    drawText('100%', Offset(size.width - 50, size.height - 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B2E2E)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();

    // Bottom (pivot)
    path.moveTo(size.width / 2, size.height);

    // Left edge
    path.lineTo(0, size.height * 0.1);

    // Tip
    path.lineTo(size.width / 2, 0);

    // Right edge
    path.lineTo(size.width, size.height * 0.1);

    path.close();

    canvas.drawPath(path, paint);

    // Center circle (pivot point)
    canvas.drawCircle(
      Offset(size.width / 2, size.height),
      size.width * 0.35,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
