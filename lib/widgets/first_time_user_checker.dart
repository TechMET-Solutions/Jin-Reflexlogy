import 'package:flutter/material.dart';
import '../services/first_time_user_service.dart';
import 'first_time_user_dialog.dart';

/// Widget that checks if first-time user dialog should be shown
/// Place this in your main app or home screen
class FirstTimeUserChecker extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDialogShown;
  final VoidCallback? onDialogSubmitted;

  const FirstTimeUserChecker({
    Key? key,
    required this.child,
    this.onDialogShown,
    this.onDialogSubmitted,
  }) : super(key: key);

  @override
  State<FirstTimeUserChecker> createState() => _FirstTimeUserCheckerState();
}

class _FirstTimeUserCheckerState extends State<FirstTimeUserChecker> {
  bool _isChecking = true;
  bool _shouldShowDialog = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  /// Check if user is opening app for first time
  Future<void> _checkFirstTimeUser() async {
    try {
      final service = FirstTimeUserService();
      await service.init();

      final isFormSubmitted = await service.isFormSubmitted();

      setState(() {
        _shouldShowDialog = !isFormSubmitted;
        _isChecking = false;
      });

      // Show dialog after build is complete
      if (_shouldShowDialog && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showDialog();
        });
      }
    } catch (e) {
      debugPrint('Error checking first-time user: $e');
      setState(() {
        _isChecking = false;
      });
    }
  }

  /// Show the first-time user dialog
  void _showDialog() {
    if (!mounted) return;

    widget.onDialogShown?.call();

    FirstTimeUserDialog.show(
      context,
      onSubmitSuccess: () {
        widget.onDialogSubmitted?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      // Show loading indicator while checking
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return widget.child;
  }
}
