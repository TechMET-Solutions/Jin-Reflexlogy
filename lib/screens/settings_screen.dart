import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

const String diagnosisImageFlipPrefKey = "diagnosisImageFlip";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _flipDiagnosisImages;

  @override
  void initState() {
    super.initState();
    _flipDiagnosisImages = AppPreference().getBool(
      diagnosisImageFlipPrefKey,
      defValue: true,
    );
  }

  Future<void> _updateFlipSetting(bool value) async {
    await AppPreference().setBool(diagnosisImageFlipPrefKey, value);
    if (!mounted) return;
    setState(() {
      _flipDiagnosisImages = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3EB),
      appBar: CommonAppBar(title: "Settings"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Flip Diagnosis Images",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Turn ON if diagnosis images look upside down.",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _flipDiagnosisImages,
                  onChanged: _updateFlipSetting,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
