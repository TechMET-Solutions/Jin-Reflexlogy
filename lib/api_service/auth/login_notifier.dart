import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jin_reflex_new/api_service/preference/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/preference/app_preference.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/Diagnosis/member_list_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/e_books/ebook_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_jin_Reflexology_patients/finder/point_finder_screen.dart';
import 'package:jin_reflex_new/dashbord_forlder/for_premium/treatment_video/treatment_screen.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  LoginNotifier() : super(const AsyncValue.data(null));

  Future<void> login(
    BuildContext context,
    VoidCallback onTab,
    String text,
    String type,
    id,
    passworld,
  ) async {
    print("🔵 LOGIN STARTED");
    print("➡️ Screen: $text");
    print("➡️ Type: $type");
    print("➡️ ID: $id");

    state = const AsyncValue.loading();

    try {
      final oldType = AppPreference().getString(PreferencesKey.type);
      print("🟡 Old saved type: $oldType");

      if (oldType.isNotEmpty && oldType != type) {
        print("⚠️ TYPE CONFLICT: old=$oldType new=$type");

        state = const AsyncValue.data(null);

        _showTypeConflictDialog(
          context,
          oldType: oldType,
          newType: type,
          onConfirm: () async {
            print("🔴 Clearing shared preferences...");
            await AppPreference().clearSharedPreferences();
            Navigator.pop(context);

            print("🔁 Retrying login...");
            login(context, onTab, text, type, id, passworld);
          },
        );
        return;
      }

      final dio = Dio(
        BaseOptions(
          responseType: ResponseType.plain,
          validateStatus: (status) => true,
        ),
      );

      print("🌐 Sending API request...");
      print("https://jinreflexology.in/api1/new/login.php");
      print("DATA => id: $id | type: $type");

      final response = await dio.post(
        "https://jinreflexology.in/api1/new/login.php",
        data: FormData.fromMap({
          'id': id,
          'password': passworld,
          'type': type,
        }),
      );

      print("📡 Response Status Code: ${response.statusCode}");
      print("📡 Raw Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final jsonData = jsonDecode(response.data.toString());

        print("✅ Parsed JSON: $jsonData");

        if (jsonData['success'] == 1) {
          print("🎉 LOGIN SUCCESS");

          await AppPreference().setString(
            PreferencesKey.token,
            jsonData['token'],
          );
          await AppPreference().setString(
            PreferencesKey.userId,
            jsonData['id'].toString(),
          );
          await AppPreference().setString(
            PreferencesKey.type,
            type,
          );

          print("💾 Token saved");
          print("💾 UserId saved");
          print("💾 Type saved");

          state = const AsyncValue.data(null);

          print("➡️ Navigating to $text");

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
          } else if (text == "Treatment") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Treatment()),
            );
          }
        } else {
          print("❌ LOGIN FAILED: ${jsonData['data']}");
          state = AsyncValue.error(
            "Invalid credentials",
            StackTrace.current,
          );
        }
      } else {
        print("❌ SERVER ERROR: ${response.statusCode}");
        state = AsyncValue.error(
          "Server error ${response.statusCode}",
          StackTrace.current,
        );
      }
    } catch (e, st) {
      print("🔥 EXCEPTION OCCURRED");
      print("ERROR: $e");
      print("STACKTRACE: $st");

      state = AsyncValue.error(e, st);
    }
  }
}

void _showTypeConflictDialog(
  BuildContext context, {
  required String oldType,
  required String newType,
  required VoidCallback onConfirm,
}) {
  print("🟠 Showing type conflict dialog");

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
            onPressed: () {
              print("❎ User cancelled type conflict dialog");
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              print("✅ User confirmed logout & continue");
              onConfirm();
            },
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
