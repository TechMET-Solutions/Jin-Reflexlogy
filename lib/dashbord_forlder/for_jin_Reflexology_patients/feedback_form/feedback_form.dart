// main.dart
import 'package:flutter/material.dart';



class ReviewOfSystemScreen extends StatefulWidget {
  const ReviewOfSystemScreen({super.key});

  @override
  State<ReviewOfSystemScreen> createState() => _ReviewOfSystemScreenState();
}

class _ReviewOfSystemScreenState extends State<ReviewOfSystemScreen> {
  /// key = symptom name
  /// value = 'FD' | 'LD' | null
  final Map<String, String?> _answers = {};

  void _onSelect(String key, String value) {
    setState(() {
      _answers[key] = value; // FD & LD are mutually exclusive
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _symptomRow(String label) {
    final value = _answers[label];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Checkbox(
            value: value == 'FD',
            onChanged: (_) => _onSelect(label, 'FD'),
          ),
          const Text('FD'),
          const SizedBox(width: 6),
          Checkbox(
            value: value == 'LD',
            onChanged: (_) => _onSelect(label, 'LD'),
          ),
          const Text('LD'),
        ],
      ),
    );
  }

  void _submit() {
    debugPrint('Selected Symptoms:');
    _answers.forEach((key, value) {
      if (value != null) {
        debugPrint('$key : $value');
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review of Systems')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('HEAD'),
            _symptomRow('Frequent Headaches'),
            _symptomRow('Severe Headaches'),
            _symptomRow('Dizziness'),
            _symptomRow('Loss of consciousness'),
            _symptomRow('Congestion'),

            _sectionTitle('EYES'),
            _symptomRow('Glasses'),
            _symptomRow('Contacts'),
            _symptomRow('Pain'),
            _symptomRow('Dry Eyes'),
            _symptomRow('Tearing'),

            _sectionTitle('EARS'),
            _symptomRow('Ear Pain'),
            _symptomRow('Ringing'),
            _symptomRow('Hearing Problems'),

            _sectionTitle('NOSE'),
            _symptomRow('Sinus Problems'),
            _symptomRow('Nose Bleeds'),
            _symptomRow('Sneezing'),

            _sectionTitle('MOUTH'),
            _symptomRow('Dry Mouth'),
            _symptomRow('Ulcers / Cold sores'),
            _symptomRow('Dental problems'),

            _sectionTitle('RESPIRATORY'),
            _symptomRow('Chest Pain or Tightness'),
            _symptomRow('Shortness of Breath'),
            _symptomRow('Coughing'),
            _symptomRow('Wheezing'),

            _sectionTitle('CARDIOVASCULAR'),
            _symptomRow('Chest Tightness'),
            _symptomRow('Palpitations'),
            _symptomRow('Swollen Feet or Ankles'),

            _sectionTitle('GASTROINTESTINAL'),
            _symptomRow('Poor Appetite'),
            _symptomRow('Nausea'),
            _symptomRow('Vomiting'),
            _symptomRow('Abdominal Pain'),
            _symptomRow('Constipation'),

            _sectionTitle('MUSCULOSKELETAL'),
            _symptomRow('Back Pain'),
            _symptomRow('Joint Pain'),
            _symptomRow('Muscle Pain'),

            _sectionTitle('SKIN'),
            _symptomRow('Rash'),
            _symptomRow('Itch'),
            _symptomRow('Dryness'),

            _sectionTitle('NEUROLOGICAL'),
            _symptomRow('Headaches'),
            _symptomRow('Weakness'),
            _symptomRow('Numbness'),

            _sectionTitle('GENITOURINARY'),
            _symptomRow('Pain with Urination'),
            _symptomRow('Frequent Urination'),
            _symptomRow('Blood in Urine'),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




