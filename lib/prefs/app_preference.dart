import 'package:flutter/foundation.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static final AppPreference _appPreference = AppPreference._internal();

  factory AppPreference() {
    return _appPreference;
  }

  AppPreference._internal();

  SharedPreferences? _preferences;

  Future<void> initialAppPreference() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.setString(key, value);
  }

  String getString(String key, {String defValue = ''}) {
    return _preferences?.getString(key) ?? defValue;
  }

  Future<void> setInt(String key, int value) async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.setInt(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    return _preferences?.getInt(key) ?? defValue;
  }

  Future<void> setBool(String key, bool value) async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.setBool(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    return _preferences?.getBool(key) ?? defValue;
  }

  Future<void> clearSharedPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();

    final authKeys = <String>{
      PreferencesKey.token,
      PreferencesKey.userId,
      PreferencesKey.name,
      PreferencesKey.email,
      PreferencesKey.contactNumber,
      PreferencesKey.type,
    };

    for (final key in authKeys) {
      await _preferences!.remove(key);
    }

    debugPrint('Logout: removed auth/session data only');
  }

  String get uName => getString(PreferencesKey.token);
}
