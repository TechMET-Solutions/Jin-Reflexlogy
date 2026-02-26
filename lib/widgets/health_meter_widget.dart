import 'dart:math';
import 'package:flutter/material.dart';

class HealthMeterScreen extends StatefulWidget {
  const HealthMeterScreen({super.key});

  @override
  State<HealthMeterScreen> createState() => _HealthMeterScreenState();
}

class _HealthMeterScreenState extends State<HealthMeterScreen> {
  double healthValue = 75;
  bool isMale = true;
  bool isFemale = false;
  String age = '';
  String? selectedWorkPosition;
  List<bool> dailyLifeStyleAnswers = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Meter',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Fixed Health Meter
          Container(
            height: 250,
            color: Colors.white,
            child: Center(
              child: HealthMeterWidget(
                healthValue: healthValue,
                meterBackgroundImage: 'assets/health_meter.png',
                needleImage: 'assets/needle.png',
                width: 250,
                height: 250,
                animationDuration: const Duration(milliseconds: 2000),
              ),
            ),
          ),

          // Rest of your existing code remains same...
          // Slider and other UI components
        ],
      ),
    );
  }
}

/// Fixed HealthMeterWidget with proper needle rendering
class HealthMeterWidget extends StatefulWidget {
  final double healthValue;
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
  double _currentValue = 0;

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

  double _getRotationAngle(double value) {
    final v = value.clamp(0.0, 100.0);

    // half circle → -90° to +90°
    final degrees = (v / 100) * 180 - 90;

    return degrees * pi / 180;
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
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
       Positioned.fill(
  child: Image.asset(
    widget.meterBackgroundImage,
    fit: BoxFit.fill,   // 🔥 FULL FILL
  ),
),
          // Needle with rotation
          
          Positioned.fill(
            child: Align(
               alignment: Alignment(0, 0.70),
              child: Transform.rotate(
                angle: _getRotationAngle(_currentValue),
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// NEEDLE LINE
                    Container(
                      width: 5,
                      height: widget.height * 0.38, // ⭐ needle मोठी
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B0000),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    /// PIVOT GAP
                    const SizedBox(height: 2),

                    /// CENTER DOT
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Center(
            child: CircleAvatar(radius: 8, backgroundColor: Colors.white),
          ),

          // Value and status display
          Positioned(
            top: widget.height * 0.38,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_currentValue.round()}%',
                  style:
                      widget.valueTextStyle ??
                      TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _getHealthColor(_currentValue),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getHealthStatus(_currentValue),
                  style: TextStyle(
                    fontSize: 18,
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
  }
}
