import 'package:shared_preferences/shared_preferences.dart';

class WelcomeDialogPrefs {
  static const String keyName = 'welcome_name';
  static const String keyMobile = 'welcome_mobile';
  static const String keyEmail = 'welcome_email';
  static const String keyDealerId = 'welcome_dealer_id';
  static const String keyDealerCompleted = 'dealer_completed';
  static const String keyWelcomeSubmitted = 'welcome_submitted';

  static Future<bool> shouldShowDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadySubmitted = prefs.getBool(keyWelcomeSubmitted) ?? false;
    if (alreadySubmitted) return false;

    // If dealerId already exists, treat welcome flow as completed and do not show popup.
    final dealerId = (prefs.getString(keyDealerId) ?? '').trim();
    if (dealerId.isNotEmpty) {
      await prefs.setBool(keyDealerCompleted, true);
      await prefs.setBool(keyWelcomeSubmitted, true);
      return false;
    }

    return true;
  }

  static Future<void> saveSubmission({
    required String name,
    required String mobile,
    required String email,
    required String dealerId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final normalizedDealerId = dealerId.trim();

    await prefs.setString(keyName, name.trim());
    await prefs.setString(keyMobile, mobile.trim());
    await prefs.setString(keyEmail, email.trim());
    await prefs.setString(keyDealerId, normalizedDealerId);
    await prefs.setBool(keyDealerCompleted, normalizedDealerId.isNotEmpty);
    await prefs.setBool(keyWelcomeSubmitted, true);
  }

  static Future<Map<String, String>> getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      keyName: prefs.getString(keyName) ?? '',
      keyMobile: prefs.getString(keyMobile) ?? '',
      keyEmail: prefs.getString(keyEmail) ?? '',
      keyDealerId: prefs.getString(keyDealerId) ?? '',
    };
  }
}
