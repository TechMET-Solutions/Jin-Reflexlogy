import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Service to manage first-time user experience
class FirstTimeService {
  static const String _keyFirstTime = 'is_first_time_user';
  static const String _keyWelcomeShown = 'welcome_dialog_shown';
  static const String _keyAppVersion = 'app_version';

  /// Check if this is the first time the app is opened
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_keyFirstTime) ?? true;
    debugPrint("🔍 FirstTimeService: isFirstTime() = $value");
    return value;
  }

  /// Mark that the app has been opened (no longer first time)
  static Future<void> setNotFirstTime() async {
    debugPrint("📝 FirstTimeService: Setting not first time");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTime, false);
    await prefs.setInt('first_open_timestamp', DateTime.now().millisecondsSinceEpoch);
    debugPrint("✅ FirstTimeService: Not first time saved");
  }

  /// Check if welcome dialog has been shown
  static Future<bool> hasWelcomeBeenShown() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_keyWelcomeShown) ?? false;
    debugPrint("🔍 FirstTimeService: hasWelcomeBeenShown() = $value");
    return value;
  }

  /// Mark welcome dialog as shown
  static Future<void> setWelcomeShown() async {
    debugPrint("📝 FirstTimeService: Setting welcome shown");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWelcomeShown, true);
    debugPrint("✅ FirstTimeService: Welcome shown saved");
  }

  /// Reset first-time status (for testing)
  static Future<void> resetFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFirstTime);
    await prefs.remove(_keyWelcomeShown);
    await prefs.remove('first_open_timestamp');
  }

  /// Get app version
  static Future<String?> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppVersion);
  }

  /// Set app version
  static Future<void> setAppVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppVersion, version);
  }

  /// Check if app was updated (version changed)
  static Future<bool> isAppUpdated(String currentVersion) async {
    final savedVersion = await getAppVersion();
    if (savedVersion == null) {
      await setAppVersion(currentVersion);
      return false;
    }
    return savedVersion != currentVersion;
  }
}
