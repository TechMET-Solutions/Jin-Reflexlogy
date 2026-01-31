import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage first-time user data
/// This data persists across app sessions, logins, and logouts
/// Only deleted when app is uninstalled
class FirstTimeUserService {
  // Singleton pattern
  static final FirstTimeUserService _instance = FirstTimeUserService._internal();
  factory FirstTimeUserService() => _instance;
  FirstTimeUserService._internal();

  // SharedPreferences instance
  SharedPreferences? _prefs;

  // Storage keys
  static const String _keyFormSubmitted = 'first_time_form_submitted';
  static const String _keyUserName = 'first_time_user_name';
  static const String _keyUserEmail = 'first_time_user_email';
  static const String _keyUserPhone = 'first_time_user_phone';
  static const String _keyUserDealerId = 'first_time_user_dealer_id';
  static const String _keySubmissionDate = 'first_time_submission_date';

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Check if form has been submitted
  Future<bool> isFormSubmitted() async {
    await _ensureInitialized();
    return _prefs!.getBool(_keyFormSubmitted) ?? false;
  }

  /// Save user data and mark form as submitted
  Future<bool> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String dealerId,
  }) async {
    await _ensureInitialized();

    try {
      await _prefs!.setString(_keyUserName, name);
      await _prefs!.setString(_keyUserEmail, email);
      await _prefs!.setString(_keyUserPhone, phone);
      await _prefs!.setString(_keyUserDealerId, dealerId);
      await _prefs!.setString(
        _keySubmissionDate,
        DateTime.now().toIso8601String(),
      );
      await _prefs!.setBool(_keyFormSubmitted, true);

      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  /// Get saved user name
  Future<String?> getUserName() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserName);
  }

  /// Get saved user email
  Future<String?> getUserEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserEmail);
  }

  /// Get saved user phone
  Future<String?> getUserPhone() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserPhone);
  }

  /// Get saved dealer ID
  Future<String?> getDealerId() async {
    await _ensureInitialized();
    return _prefs!.getString(_keyUserDealerId);
  }

  /// Get submission date
  Future<DateTime?> getSubmissionDate() async {
    await _ensureInitialized();
    final dateString = _prefs!.getString(_keySubmissionDate);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  /// Get all user data as a map
  Future<Map<String, String?>> getAllUserData() async {
    await _ensureInitialized();
    return {
      'name': await getUserName(),
      'email': await getUserEmail(),
      'phone': await getUserPhone(),
      'dealerId': await getDealerId(),
      'submissionDate': (await getSubmissionDate())?.toIso8601String(),
    };
  }

  /// Clear all data (for testing purposes only)
  /// WARNING: This will show the popup again on next app launch
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _prefs!.remove(_keyFormSubmitted);
    await _prefs!.remove(_keyUserName);
    await _prefs!.remove(_keyUserEmail);
    await _prefs!.remove(_keyUserPhone);
    await _prefs!.remove(_keyUserDealerId);
    await _prefs!.remove(_keySubmissionDate);
  }

  /// Ensure SharedPreferences is initialized
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Check if data exists (for debugging)
  Future<bool> hasUserData() async {
    await _ensureInitialized();
    final name = await getUserName();
    return name != null && name.isNotEmpty;
  }
}
