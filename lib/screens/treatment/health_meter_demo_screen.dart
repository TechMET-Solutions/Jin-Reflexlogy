import 'package:flutter/material.dart';
import '../../widgets/health_meter_widget.dart';
import '../../widgets/advanced_health_meter_widget.dart';

/// Comprehensive demo showing different health meter configurations
class HealthMeterDemoScreen extends StatefulWidget {
  const HealthMeterDemoScreen({Key? key}) : super(key: key);

  @override
  State<HealthMeterDemoScreen> createState() => _HealthMeterDemoScreenState();
}

class _HealthMeterDemoScreenState extends State<HealthMeterDemoScreen> {
  double _healthValue = 65.0;
  double _heartRate = 72.0;
  double _bloodPressure = 80.0;
  double _oxygenLevel = 98.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Meter Demo'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Health Meter
            _buildSection(
              'Overall Health Score',
              HealthMeterWidget(
                healthValue: _healthValue,
                meterBackgroundImage: 'assets/meter_bg.png',
                needleImage: 'assets/needle.png',
                width: 280,
                height: 280,
              ),
              _healthValue,
              (value) => setState(() => _healthValue = value),
            ),

            const SizedBox(height: 30),

            // Multiple meters in grid
            Text(
              'Vital Signs',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMiniMeter(
                  'Heart Rate',
                  _heartRate,
                  'BPM',
                  Colors.red,
                  (value) => setState(() => _heartRate = value),
                ),
                _buildMiniMeter(
                  'Blood Pressure',
                  _bloodPressure,
                  'mmHg',
                  Colors.blue,
                  (value) => setState(() => _bloodPressure = value),
                ),
                _buildMiniMeter(
                  'Oxygen Level',
                  _oxygenLevel,
                  'SpO2',
                  Colors.green,
                  (value) => setState(() => _oxygenLevel = value),
                ),
                _buildMiniMeter(
                  'Stress Level',
                  100 - _healthValue,
                  'Index',
                  Colors.orange,
                  (value) => setState(() => _healthValue = 100 - value),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Advanced meter with custom angles
            _buildSection(
              'Advanced Meter (Full Circle)',
              AdvancedHealthMeterWidget(
                healthValue: _healthValue,
                meterBackgroundImage: 'assets/meter_bg.png',
                needleImage: 'assets/needle.png',
                width: 250,
                height: 250,
                startAngle: -135,
                endAngle: 135,
                animationDuration: const Duration(milliseconds: 2000),
                animationCurve: Curves.elasticOut,
              ),
              _healthValue,
              (value) => setState(() => _healthValue = value),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    Widget meter,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            meter,
            const SizedBox(height: 20),
            Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 100,
              label: value.toStringAsFixed(0),
              onChanged: onChanged,
              activeColor: _getHealthColor(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMeter(
    String label,
    double value,
    String unit,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: HealthMeterWidget(
                healthValue: value,
                meterBackgroundImage: 'assets/meter_bg.png',
                needleImage: 'assets/needle.png',
                width: 120,
                height: 120,
                showValue: false,
                animationDuration: const Duration(milliseconds: 1000),
              ),
            ),
            Text(
              '${value.toStringAsFixed(0)} $unit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Slider(
              value: value,
              min: 0,
              max: 100,
              onChanged: onChanged,
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Color _getHealthColor(double value) {
    if (value >= 75) return Colors.green;
    if (value >= 50) return Colors.lightGreen;
    if (value >= 25) return Colors.orange;
    return Colors.red;
  }
}
