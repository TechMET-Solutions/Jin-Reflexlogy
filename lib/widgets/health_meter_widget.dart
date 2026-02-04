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
          // Fixed Health Meter (वरचा भाग)
          Container(
            //height: 200,
            color: Colors.white,
            child: Center(
              child: HealthMeterWidget(
                healthValue: healthValue,
                meterBackgroundImage: 'assets/health_meter.png',
                needleImage: 'assets/needle.png',
                width: 200,
                height: 200,
                animationDuration: const Duration(milliseconds: 2000),
              ),
            ),
          ),
          
          // Slider for Health Value
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adjust Health Value:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Slider(
                  value: healthValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '${healthValue.round()}%',
                  onChanged: (value) {
                    setState(() {
                      healthValue = value;
                    });
                  },
                  activeColor: _getHealthColor(healthValue),
                  inactiveColor: Colors.grey[300],
                ),
              ],
            ),
          ),
          
          // Scrollable Content (खालचा भाग)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gender Section
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderOption('Male', isMale, () {
                          setState(() {
                            isMale = true;
                            isFemale = false;
                          });
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildGenderOption('Female', isFemale, () {
                          setState(() {
                            isMale = false;
                            isFemale = true;
                          });
                        }),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Age Section
                  const Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your age',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.blueGrey[400],
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Working Position Section
                  const Text(
                    'Working Position',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      _buildWorkPositionOption('Sit'),
                      _buildWorkPositionOption('Standing'),
                      _buildWorkPositionOption('Field work'),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Daily Lifestyle Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          'Your Daily Lifestyle',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Answer the following questions about your daily habits:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildLifestyleQuestion(
                          '1. Early Wake Up (Between 4 to 6 am)',
                          0,
                        ),
                        _buildLifestyleQuestion(
                          '2. Regular Exercise (30 mins daily)',
                          1,
                        ),
                        _buildLifestyleQuestion(
                          '3. Balanced Diet',
                          2,
                        ),
                        _buildLifestyleQuestion(
                          '4. Adequate Water Intake (8+ glasses)',
                          3,
                        ),
                        _buildLifestyleQuestion(
                          '5. Stress Management',
                          4,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _calculateHealthScore();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'Calculate Health Score',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40), // Bottom spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              gender == 'Male' ? Icons.male : Icons.female,
              color: isSelected ? Colors.blue[700] : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue[700] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkPositionOption(String position) {
    bool isSelected = selectedWorkPosition == position;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedWorkPosition = position;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[50] : Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  position,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.green[800] : Colors.grey[700],
                  ),
                ),
              ),
              Icon(
                position == 'Sit' ? Icons.chair
                  : position == 'Standing' ? Icons.directions_walk
                  : Icons.agriculture,
                color: isSelected ? Colors.green : Colors.grey[600],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLifestyleQuestion(String question, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              _buildAnswerOption('Yes', index, true),
              const SizedBox(width: 8),
              _buildAnswerOption('No', index, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(String text, int index, bool value) {
    bool isSelected = dailyLifeStyleAnswers[index] == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          dailyLifeStyleAnswers[index] = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.blue[700] : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Color _getHealthColor(double value) {
    if (value >= 75) return Colors.green;
    if (value >= 50) return Colors.lightGreen;
    if (value >= 25) return Colors.yellow;
    return Colors.red;
  }

  void _calculateHealthScore() {
    // Simple calculation logic
    double score = 50; // Base score
    
    // Add points for positive answers
    for (bool answer in dailyLifeStyleAnswers) {
      if (answer) score += 10;
    }
    
    // Adjust based on work position
    if (selectedWorkPosition == 'Field work') {
      score += 15;
    } else if (selectedWorkPosition == 'Standing') {
      score += 5;
    }
    
    // Adjust based on age
    if (age.isNotEmpty) {
      int ageNum = int.tryParse(age) ?? 30;
      if (ageNum >= 18 && ageNum <= 40) {
        score += 10;
      }
    }
    
    // Show result
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Score'),
        content: Text('Your calculated health score is: ${score.round()}%'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                healthValue = score.clamp(0.0, 100.0);
              });
            },
            child: const Text('Update Meter'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

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
        final size = constraints.maxWidth < widget.width
            ? constraints.maxWidth
            : widget.width;

        return Container(
          width: size,
  height: size * 0.7, // 👈 less vertical space

          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background meter image
             Positioned.fill(
  child: Transform.scale(
    scale: 1.5, // 👈 1.0 = normal, 1.3 = bigger, 1.5 = more bigger
    child: Image.asset(
      widget.meterBackgroundImage,
      fit: BoxFit.contain,
    ),
  ),
),


              // Rotating needle
              Positioned.fill(
                child: CustomPaint(
                  painter: _GaugeNeedlePainter(_currentValue),
                ),
              ),

              // Center pivot circle
              Positioned(
                top: size * 0.60,
                //bottom: size * 0.3,
                child: Column(
                  children: [
                    // const SizedBox(height: 20),
                    Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        boxShadow: const [
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

              // Value display
              if (widget.showValue)
                Positioned(
                  top: size * 0.40,
                 // bottom: size * 0.10,
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
                      const SizedBox(height: 4),
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
    final center = Offset(size.width / 2, size.height * 0.90);
    final radius = size.width * 0.40;

    final paint = Paint()
      ..color = const Color(0xFF6B2E2E)
      ..strokeWidth = size.width * 0.015
      ..strokeCap = StrokeCap.round;

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

/// Custom painter for fallback meter background
class _MeterBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.4;
    const strokeWidth = 20.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Red zone (0-25%) - POOR
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      3.14159 / 4,
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

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

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

    drawText('0%', const Offset(10, 10));
    drawText('25%', Offset(size.width * 0.15, size.height * 0.3));
    drawText('50%', Offset(size.width * 0.45, 10));
    drawText('75%', Offset(size.width * 0.75, size.height * 0.3));
    drawText('100%', Offset(size.width - 50, 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}