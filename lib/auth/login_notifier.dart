import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbord_forlder/freddback_list.dart';
import 'package:jin_reflex_new/dashbord_forlder/training_coureses.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/ebook_screen.dart';
import 'package:jin_reflex_new/screens/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/screens/point_finder_screen.dart';
import 'package:jin_reflex_new/screens/treatment/triment_screen.dart';

import '../screens/shop/shop_screen.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>((
  ref,
) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  LoginNotifier() : super(const AsyncValue.data(null));
  String safe(dynamic value) {
    return value == null ? "" : value.toString();
  }

  Future<void> login(
    BuildContext context,
    VoidCallback onTab,
    String text,
    String type, // "therapist" | "prouser" | ""
    dynamic id,
    dynamic password, {
    dynamic DeliveryType,
  }) async {
    state = const AsyncValue.loading();

    try {
      // ===============================
      // 🔁 TYPE CONFLICT CHECK
      // (फक्त UI type non-empty असेल तेव्हाच)
      // ===============================
      final oldType = AppPreference().getString(PreferencesKey.type);
      if (type.trim().isNotEmpty && oldType.isNotEmpty && oldType != type) {
        state = const AsyncValue.data(null);

        _showTypeConflictDialog(
          context,
          oldType: oldType,
          newType: type,
          onConfirm: () async {
            await AppPreference().clearSharedPreferences();
            Navigator.pop(context);
            login(
              context,
              onTab,
              text,
              type,
              id,
              password,
              DeliveryType: DeliveryType,
            );
          },
        );
        return;
      }

      // ===============================
      // 🌐 API CALL
      // ===============================
      final dio = Dio(
        BaseOptions(
          responseType: ResponseType.plain,
          validateStatus: (_) => true,
        ),
      );

      final response = await dio.post(
        "https://jinreflexology.in/api1/new/login.php",
        data: FormData.fromMap({"id": id, "password": password, "type": type}),
      );

      debugPrint("===== LOGIN DEBUG START =====");
      debugPrint("TYPE FROM UI: $type");
      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("RAW RESPONSE: ${response.data}");
      debugPrint("===== LOGIN DEBUG END =====");

      if (response.statusCode != 200 || response.data == null) {
        state = AsyncValue.error(
          "Server error ${response.statusCode}",
          StackTrace.current,
        );
        return;
      }

      final Map<String, dynamic> jsonData = jsonDecode(
        response.data.toString(),
      );

      if (jsonData['success'] != 1) {
        state = AsyncValue.error("Invalid credentials", StackTrace.current);
        return;
      }

      // ===============================
      // 🧠 HANDLE BOTH RESPONSE TYPES
      // ===============================
      final Map<String, dynamic>? userData =
          jsonData['user_data'] is Map ? jsonData['user_data'] : null;

      final userId = userData?['id'] ?? jsonData['id'];
      final token = userData?['token'] ?? jsonData['token'] ?? "";
      final name = userData?['t_name'] ?? userData?['name'] ?? "";
      final email = userData?['t_email'] ?? userData?['email'] ?? "";
      final mobile = userData?['t_mobile'] ?? userData?['p_number'] ?? "";

      if (userId == null || userId.toString().isEmpty) {
        state = AsyncValue.error("User ID missing", StackTrace.current);
        return;
      }

      // ===============================
      // 🔥 FINAL TYPE DECISION
      // ===============================
      String finalType = type.trim().isNotEmpty 
          ? type 
          : (jsonData['type']?.toString() ?? "");
      
      // If still empty, use "patient" as default for BodyPartScreen
      if (finalType.isEmpty && text == "BodyPartScreen") {
        finalType = "patient";
        debugPrint("⚠️ Type was empty, setting default: patient");
      }

      // ===============================
      // 💾 SAVE TO SHARED PREFS
      // ===============================
      await AppPreference().setString(PreferencesKey.userId, userId.toString());
      await AppPreference().setString(PreferencesKey.token, token.toString());
      await AppPreference().setString(PreferencesKey.name, name.toString());
      await AppPreference().setString(PreferencesKey.email, email.toString());
      await AppPreference().setString(
        PreferencesKey.contactNumber,
        mobile.toString(),
      );
      await AppPreference().setString(PreferencesKey.type, finalType);

      // ===============================
      // 🧪 VERIFY STORED DATA
      // ===============================
      debugPrint("===== STORED PREFS =====");
      debugPrint(
        "USER ID: ${AppPreference().getString(PreferencesKey.userId)}",
      );
      debugPrint("TYPE: ${AppPreference().getString(PreferencesKey.type)}");
      debugPrint("TOKEN: ${AppPreference().getString(PreferencesKey.token)}");
      debugPrint("========================");

      AppPreference().initialAppPreference();
      state = const AsyncValue.data(null);

      // ===============================
      // 🚀 NAVIGATION
      // ===============================
      if (text == "MemberListScreen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MemberListScreen()),
        );
      } else if (text == "LifestyleScreen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LifestyleScreen()),
        );
      } else if (text == "EbookScreen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => EbookScreen()),
        );
      } else if (text == "PointFinderScreen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PointFinderScreen()),
        );
      } else if (text == "CourseScreen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CourseScreen(deliveryType: DeliveryType),
          ),
        );
      } else if (text == "Treatment") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Treatment()),
        );
      } else if (text == "BodyPartScreen") {
        // Force reload preferences to ensure latest data is available
        await AppPreference().initialAppPreference();
        
        final savedUserId = AppPreference().getString(PreferencesKey.userId);
        final savedType = AppPreference().getString(PreferencesKey.type);
        final savedToken = AppPreference().getString(PreferencesKey.token);
        
        debugPrint("===== NAVIGATION TO BODYPARTSCREEN =====");
        debugPrint("Saved User ID: $savedUserId");
        debugPrint("Saved Type: $savedType");
        debugPrint("Saved Token: $savedToken");
        debugPrint("========================================");
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => BodyPartScreen(
                  pId: savedUserId,
                  dId: null,
                  day: "last",
                  isShow: false, // ✅ Set to false to skip login check
                ),
          ),
        );
      } else if (text == "ShopScreen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ShopScreen(deliveryType: DeliveryType),
          ),
        );
      }
    } catch (e, st) {
      debugPrint("LOGIN ERROR: $e");
      state = AsyncValue.error(e, st);
    }
  }

  void _showTypeConflictDialog(
    BuildContext context, {
    required String oldType,
    required String newType,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Already Logged In"),
          content: Text(
            "You are already logged in as $oldType.\n\n"
            "Do you want to logout $oldType and login as $newType?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text(
                "Logout & Continue",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  final String _baseUrl = "https://jinreflexology.in/api1/new/";

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": 0, "message": "Server Error ${response.statusCode}"};
      }
    } catch (e) {
      return {"success": 0, "message": e.toString()};
    }
  }
}
