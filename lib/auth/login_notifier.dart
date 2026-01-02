import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/ebook_screen.dart';
import 'package:jin_reflex_new/screens/life_style/life_style_screen.dart';
import 'package:jin_reflex_new/screens/point_finder_screen.dart';
import 'package:jin_reflex_new/screens/treatment/triment_screen.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>((
  ref,
) {
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
    state = const AsyncValue.loading();

    try {
      final oldType = AppPreference().getString(PreferencesKey.type);
      if (oldType.isNotEmpty && oldType != type) {
        state = const AsyncValue.data(null);

        _showTypeConflictDialog(
          context,
          oldType: oldType,
          newType: type,
          onConfirm: () async {
            await AppPreference().clearSharedPreferences();
            Navigator.pop(context); // close dialog

            // 🔁 retry login
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

      final response = await dio.post(
        "https://jinreflexology.in/api/login.php",
        data: FormData.fromMap({'id': id, 'password': passworld, 'type': type}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final jsonData = jsonDecode(response.data.toString());

        if (jsonData['success'] == 1) {
          await AppPreference().setString(
            PreferencesKey.token,
            jsonData['token'],
          );
          await AppPreference().setString(
            PreferencesKey.userId,
            jsonData['id'].toString(),
          );
          await AppPreference().setString(PreferencesKey.type, type);

          state = const AsyncValue.data(null);

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
          }else if (text == "Treatment") {
            Navigator.pushReplacement(  
              context,
              MaterialPageRoute(builder: (_) => Treatment()),
            );
          }
        } else {
          state = AsyncValue.error("Invalid credentials", StackTrace.current);
        }
      } else {
        state = AsyncValue.error(
          "Server error ${response.statusCode}",
          StackTrace.current,
        );
      }
    } catch (e, st) {
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
