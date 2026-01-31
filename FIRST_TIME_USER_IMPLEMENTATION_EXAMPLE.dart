// ============================================================================
// EXAMPLE: How to integrate First-Time User Dialog in your main.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:jin_reflex_new/services/first_time_user_service.dart';
import 'package:jin_reflex_new/widgets/first_time_user_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the first-time user service
  await FirstTimeUserService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First Time User Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Wrap your home screen with FirstTimeUserChecker
      home: FirstTimeUserChecker(
        onDialogShown: () {
          debugPrint('✅ First-time user dialog shown');
        },
        onDialogSubmitted: () {
          debugPrint('✅ First-time user data submitted');
        },
        child: const HomeScreen(),
      ),
    );
  }
}

// ============================================================================
// Your Home Screen
// ============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showUserInfo(context),
            tooltip: 'View Saved Info',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your information has been saved.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showUserInfo(context),
              icon: const Icon(Icons.person),
              label: const Text('View Saved Information'),
            ),
            const SizedBox(height: 16),
            // FOR TESTING ONLY - Remove in production
            OutlinedButton.icon(
              onPressed: () => _clearDataForTesting(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear Data (Testing Only)'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  /// Show saved user information
  Future<void> _showUserInfo(BuildContext context) async {
    final service = FirstTimeUserService();
    final userData = await service.getAllUserData();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Saved Information'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow('Name', userData['name']),
                  _buildInfoRow('Email', userData['email']),
                  _buildInfoRow('Phone', userData['phone']),
                  _buildInfoRow('Dealer ID', userData['dealerId']),
                  _buildInfoRow('Saved On', userData['submissionDate']),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value ?? 'Not available', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// Clear data for testing (REMOVE IN PRODUCTION)
  Future<void> _clearDataForTesting(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Data?'),
            content: const Text(
              'This will clear all saved data and show the popup again on next app launch.\n\n'
              'This is for TESTING ONLY.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Clear Data'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final service = FirstTimeUserService();
      await service.clearAllData();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data cleared! Restart app to see popup again.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

// ============================================================================
// ALTERNATIVE: Integration with existing app structure
// ============================================================================

/*
If you already have a splash screen or login flow, you can check manually:

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    // Initialize service
    final service = FirstTimeUserService();
    await service.init();

    // Check if form submitted
    final isFormSubmitted = await service.isFormSubmitted();

    if (!isFormSubmitted) {
      // Show dialog
      await FirstTimeUserDialog.show(context);
    }

    // Navigate to home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
*/

// ============================================================================
// USAGE WITH LOGIN FLOW
// ============================================================================

/*
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // After successful login
            final service = FirstTimeUserService();
            final isFormSubmitted = await service.isFormSubmitted();

            if (!isFormSubmitted) {
              // Show dialog before navigating to home
              await FirstTimeUserDialog.show(context);
            }

            // Navigate to home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
*/
