import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';

/// Authentication Service
/// Handles all login state checks and user session management
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Check if user is logged in (any type)
  bool isLoggedIn() {
    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);
    
    return token.isNotEmpty && userId.isNotEmpty;
  }

  /// Check if user is logged in as patient
  bool isPatientLoggedIn() {
    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);
    final type = AppPreference().getString(PreferencesKey.type);
    
    return token.isNotEmpty && userId.isNotEmpty && type == "patient";
  }

  /// Check if user is logged in as therapist
  bool isTherapistLoggedIn() {
    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);
    final type = AppPreference().getString(PreferencesKey.type);
    
    return token.isNotEmpty && userId.isNotEmpty && type == "therapist";
  }

  /// Check if user is logged in as prouser
  bool isProuserLoggedIn() {
    final token = AppPreference().getString(PreferencesKey.token);
    final userId = AppPreference().getString(PreferencesKey.userId);
    final type = AppPreference().getString(PreferencesKey.type);
    
    return token.isNotEmpty && userId.isNotEmpty && type == "prouser";
  }

  /// Get current user type
  String getUserType() {
    return AppPreference().getString(PreferencesKey.type);
  }

  /// Get current user ID
  String getUserId() {
    return AppPreference().getString(PreferencesKey.userId);
  }

  /// Get current token
  String getToken() {
    return AppPreference().getString(PreferencesKey.token);
  }

  /// Get user name
  String getUserName() {
    return AppPreference().getString(PreferencesKey.name);
  }

  /// Get user email
  String getUserEmail() {
    return AppPreference().getString(PreferencesKey.email);
  }

  /// Get user contact number
  String getUserContact() {
    return AppPreference().getString(PreferencesKey.contactNumber);
  }

  /// Print current auth status (for debugging)
  void printAuthStatus() {
    debugPrint("===== AUTH STATUS =====");
    debugPrint("User ID: ${getUserId()}");
    debugPrint("User Type: ${getUserType()}");
    debugPrint("Token: ${getToken().isNotEmpty ? 'EXISTS' : 'EMPTY'}");
    debugPrint("Name: ${getUserName()}");
    debugPrint("Email: ${getUserEmail()}");
    debugPrint("Contact: ${getUserContact()}");
    debugPrint("Is Logged In: ${isLoggedIn()}");
    debugPrint("Is Patient: ${isPatientLoggedIn()}");
    debugPrint("Is Therapist: ${isTherapistLoggedIn()}");
    debugPrint("Is Prouser: ${isProuserLoggedIn()}");
    debugPrint("======================");
  }

  /// Logout user
  Future<void> logout() async {
    await AppPreference().clearSharedPreferences();
    debugPrint("✅ User logged out successfully (welcome dialog data preserved)");
  }
}
