import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:get/get.dart' hide FormData;

import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbord_forlder/CourseDetailScreen.dart';
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

  bool _isLoggingIn = false;

  Future<void> login(
    BuildContext context,
    VoidCallback onTab,
    String text,
    String type,
    dynamic id,
    dynamic password, {
    dynamic DeliveryType,
  }) async {
    // ✅ Prevent multiple clicks
    if (_isLoggingIn) return;
    _isLoggingIn = true;

    state = const AsyncValue.loading();

    try {
      // ================= TYPE CHECK =================
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

            _isLoggingIn = false;

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

      // ================= API CALL =================
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

      final raw = response.data.toString().trim();
      var data = FormData.fromMap({
        "id": id,
        "password": password,
        "type": type,
      });

      debugPrint(data.fields.toString());
      debugPrint("===== LOGIN RAW RESPONSE =====");
      debugPrint(raw);
      debugPrint("=============================");


      if (!raw.startsWith("{")) {
        throw "Invalid server response";
      }
      // 🔥 Extract only JSON part
      final int jsonStart = raw.indexOf('{');

      if (jsonStart == -1) {
        throw "Invalid server response";
      }

      final cleanJson = raw.substring(jsonStart);

      final Map<String, dynamic> jsonData = jsonDecode(cleanJson);

      final String message = jsonData["message"] ?? "Login failed";

      // ================= SHOW MESSAGE =================

      Get.rawSnackbar(
        message: message,
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      );

      // ================= FAIL CASE =================

      if (jsonData["success"] != 1) {
        state = AsyncValue.error("Login failed", StackTrace.current);
        return;
      }

      // ================= SUCCESS =================

      final Map<String, dynamic>? userData =
          jsonData['user_data'] is Map ? jsonData['user_data'] : null;

      final userId = userData?['id'] ?? jsonData['id'];
      final token = userData?['token'] ?? jsonData['token'] ?? "";
      final name = userData?['t_name'] ?? userData?['name'] ?? "";
      final email = userData?['t_email'] ?? userData?['email'] ?? "";
      final mobile = userData?['t_mobile'] ?? userData?['p_number'] ?? "";

      if (userId == null || userId.toString().isEmpty) {
        throw "User ID missing";
      }

      // ================= TYPE FIX =================

      String finalType =
          type.trim().isNotEmpty ? type : (jsonData['type'] ?? "").toString();

      if (finalType.isEmpty && text == "BodyPartScreen") {
        finalType = "patient";
      }

      // ================= SAVE PREFS =================
      await AppPreference().initialAppPreference();

      await AppPreference().setString(PreferencesKey.userId, userId.toString());

      await AppPreference().setString(PreferencesKey.token, token.toString());

      await AppPreference().setString(PreferencesKey.name, name.toString());

      await AppPreference().setString(PreferencesKey.email, email.toString());

      await AppPreference().setString(
        PreferencesKey.contactNumber,
        mobile.toString(),
      );

      await AppPreference().setString(PreferencesKey.type, finalType);

      state = const AsyncValue.data(null);

      debugPrint("===== LOGIN SUCCESS =====");

      // ================= NAVIGATION =================

      _navigate(context, text, DeliveryType);
    } catch (e, st) {
      debugPrint("LOGIN ERROR => $e");
      debugPrint("$st");

      Get.rawSnackbar(
        message: "Server Error. Try again",
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );

      state = AsyncValue.error(e, st);
    } finally {
      _isLoggingIn = false; // ✅ unlock
    }
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

void _navigate(BuildContext context, String text, dynamic DeliveryType) {
  switch (text) {
    case "MemberListScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MemberListScreen()),
      );
      break;

    case "LifestyleScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LifestyleScreen()),
      );
      break;

    case "EbookScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EbookScreen()),
      );
      break;

    case "PointFinderScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PointFinderScreen()),
      );
      break;
    case "CourseDetailScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => CourseDetailScreen(course: {}, deliveryType: DeliveryType),
        ),
      );
      break;

    case "CourseScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CourseScreen(deliveryType: DeliveryType),
        ),
      );
      break;

    case "Treatment":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Treatment()),
      );
      break;

    case "BodyPartScreen":
      final uid = AppPreference().getString(PreferencesKey.userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => BodyPartScreen(
                pId: uid,
                dId: null,
                day: "last",
                isShow: false,
              ),
        ),
      );
      break;

    case "ShopScreen":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ShopScreen(deliveryType: DeliveryType),
        ),
      );
      break;
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
