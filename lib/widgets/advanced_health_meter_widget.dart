import 'package:flutter/material.dart';

/// Advanced Health Meter with full customization
/// Supports different angle ranges and needle pivot points
class AdvancedHealthMeterWidget extends StatefulWidget {
  final double healthValue; // 0 to 100
  final String meterBackgroundImage;
  final String needleImage;
  final double width;
  final double height;
  final Duration animationDuration;
  final Curve animationCurve;
  
  // Angle configuration
  final double startAngle; // in degrees (default: -90 for left)
  final double endAngle; // in degrees (default: 90 for right)
  
  // Needle configuration
  final double needleWidth; // Relative to meter width
  final double needleHeight; // Relative to meter height
  final Alignment needlePivot; // Pivot point for rotation
  
  // Display options
  final bool showValue;
  final bool showStatus;
  final TextStyle? valueTextStyle;
  final TextStyle? statusTextStyle;
  final Widget? centerWidget;
  
  // Callbacks
  final ValueChanged<double>? onValueChanged;

  const AdvancedHealthMeterWidget({
    Key? key,
    required this.healthValue,
    required this.meterBackgroundImage,
    required this.needleImage,
    this.width = 300,
    this.height = 300,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.animationCurve = Curves.easeInOut,
    this.startAngle = -90,
    this.endAngle = 90,
    this.needleWidth = 1.0,
    this.needleHeight = 1.0,
    this.needlePivot = Alignment.center,
    this.showValue = true,
    this.showStatus = true,
    this.valueTextStyle,
    this.statusTextStyle,
    this.centerWidget,
    this.onValueChanged,
  }) : super(key: key);

  @override
  State<AdvancedHealthMeterWidget> createState() =>
      _AdvancedHealthMeterWidgetState();
}

class _AdvancedHealthMeterWidgetState extends State<AdvancedHealthMeterWidget>
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

    _setupAnimation(0, widget.healthValue);
    _animationController.forward();
  }

  void _setupAnimation(double begin, double end) {
    _animation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    )..addListener(() {
        setState(() {
          _currentValue = _animation.value;
        });
        widget.onValueChanged?.call(_currentValue);
      });
  }

  @override
  void didUpdateWidget(AdvancedHealthMeterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.healthValue != widget.healthValue) {
      _setupAnimation(_currentValue, widget.healthValue);
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
    final clampedValue = value.clamp(0.0, 100.0);
    final startRad = widget.startAngle * 3.14159 / 180;
    final endRad = widget.endAngle * 3.14159 / 180;
    final range = endRad - startRad;
    return startRad + (clampedValue / 100.0) * range;
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
    if (value >= 25) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < widget.width
            ? constraints.maxWidth
            : widget.width;
        final heightRatio = widget.height / widget.width;

        return SizedBox(
          width: size,
          height: size * heightRatio,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Background meter
              Positioned.fill(
                child: Image.asset(
                  widget.meterBackgroundImage,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(size / 2),
                      ),
                      child: Center(
                        child: Text(
                          'Meter BG',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Rotating needle
              Positioned.fill(
                child: Align(
                  alignment: widget.needlePivot,
                  child: Transform.rotate(
                    angle: _getRotationAngle(_currentValue),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size * widget.needleWidth,
                      height: size * heightRatio * widget.needleHeight,
                      child: Image.asset(
                        widget.needleImage,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 4,
                            height: size * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Center widget or value display
              if (widget.centerWidget != null)
                Positioned.fill(
                  child: widget.centerWidget!,
                )
              else if (widget.showValue || widget.showStatus)
                Positioned(
                  bottom: size * 0.15,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showValue)
                        Text(
                          '${_currentValue.toStringAsFixed(0)}%',
                          style: widget.valueTextStyle ??
                              TextStyle(
                                fontSize: size * 0.08,
                                fontWeight: FontWeight.bold,
                                color: _getHealthColor(_currentValue),
                              ),
                        ),
                      if (widget.showValue && widget.showStatus)
                        SizedBox(height: 4),
                      if (widget.showStatus)
                        Text(
                          _getHealthStatus(_currentValue),
                          style: widget.statusTextStyle ??
                              TextStyle(
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
