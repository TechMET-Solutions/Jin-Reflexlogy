import 'package:flutter/material.dart';
import '../../widgets/health_meter_widget.dart';

/// Example screen demonstrating the Health Meter Widget
class HealthMeterExampleScreen extends StatefulWidget {
  const HealthMeterExampleScreen({Key? key}) : super(key: key);

  @override
  State<HealthMeterExampleScreen> createState() =>
      _HealthMeterExampleScreenState();
}

class _HealthMeterExampleScreenState extends State<HealthMeterExampleScreen> {
  double _healthValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Meter'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Health Meter Widget
              HealthMeterWidget(
                healthValue: _healthValue,
                meterBackgroundImage: 'assets/meter_bg.png',
                needleImage: 'assets/needle.png',
                width: 300,
                height: 300,
                animationDuration: const Duration(milliseconds: 1500),
                animationCurve: Curves.easeInOut,
                showValue: true,
              ),

              const SizedBox(height: 40),

              // Slider to control health value
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Adjust Health Value',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Slider(
                        value: _healthValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: _healthValue.toStringAsFixed(0),
                        onChanged: (value) {
                          setState(() {
                            _healthValue = value;
                          });
                        },
                        activeColor: _getHealthColor(_healthValue),
                      ),
                      Text(
                        'Current Value: ${_healthValue.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: _getHealthColor(_healthValue),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quick action buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildQuickButton('Poor (0%)', 0),
                  _buildQuickButton('Fair (25%)', 25),
                  _buildQuickButton('Good (50%)', 50),
                  _buildQuickButton('Very Good (75%)', 75),
                  _buildQuickButton('Excellent (100%)', 100),
                ],
              ),

              const SizedBox(height: 30),

              // Health status info
              _buildHealthInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, double value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _healthValue = value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _getHealthColor(value),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(label),
    );
  }

  Widget _buildHealthInfo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Status Guide',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusRow('EXCELLENT', '75-100%', Colors.green),
            _buildStatusRow('GOOD', '50-74%', Colors.lightGreen),
            _buildStatusRow('FAIR', '25-49%', Colors.yellow),
            _buildStatusRow('POOR', '0-24%', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$status: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double value) {
    if (value >= 75) return Colors.green;
    if (value >= 50) return Colors.lightGreen;
    if (value >= 25) return Colors.yellow;
    return Colors.red;
  }
}
