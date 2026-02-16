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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
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
    // Convert 0-100 to -180 to 0 degrees (half circle)
    final degrees = (v / 100.0) * 180.0 - 180.0;
    return degrees * (pi / 180); // Convert to radians
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
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background meter image
          Container(
            width: widget.width * 0.9,
            height: widget.height * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.meterBackgroundImage),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Needle with rotation
          Positioned(
            top: widget.height * 0.1,
            child: Transform.rotate(
              angle: _getRotationAngle(_currentValue),
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 4,
                height: widget.height * 0.35,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center pivot circle
          Positioned(
            top: widget.height * 0.45,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey[800]!, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Value and status display
          Positioned(
            top: widget.height * 0.65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_currentValue.round()}%',
                  style: widget.valueTextStyle ??
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