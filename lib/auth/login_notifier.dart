import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
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

  Future<void> login(
    BuildContext context,
    VoidCallback onTab,
    String text,
    String type,
    id,
    passworld, {
    DeliveryType,
  }) async {
    print("object");
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
        "https://jinreflexology.in/api1/new/login.php",
        data: FormData.fromMap({'id': id, 'password': passworld, 'type': type}),
      );
      print(type);
      if (response.statusCode == 200 && response.data != null) {
        final jsonData = jsonDecode(response.data.toString());

        if (jsonData['success'] == 1) {
          if (type == "therapist") {
            print("ssssssssssssssssssssssssssssssssssssssssssss");
            await AppPreference().setString(
              PreferencesKey.token,
              jsonData['user_data']['token'],
            );
            await AppPreference().setString(
              PreferencesKey.contactNumber,
              jsonData['user_data']['t_mobile'],
            );
            await AppPreference().setString(
              PreferencesKey.name,
              jsonData['user_data']['t_name'],
            );
            await AppPreference().setString(
              PreferencesKey.userId,
              jsonData['user_data']['id'].toString(),
            );
            await AppPreference().setString(
              PreferencesKey.email,
              jsonData['user_data']['t_email'].toString(),
            );
          } else {
            await AppPreference().setString(
              PreferencesKey.token,
              jsonData['token'],
            );
            await AppPreference().setString(
              PreferencesKey.contactNumber,
              jsonData['user_data']['p_mobile'],
            );
            await AppPreference().setString(
              PreferencesKey.name,
              jsonData['user_data']['name'],
            );
            await AppPreference().setString(
              PreferencesKey.userId,
              jsonData['user_data']['id'].toString(),
            );
            await AppPreference().setString(
              PreferencesKey.email,
              jsonData['user_data']['p_email'].toString(),
            );
          }

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
          } else if (text == "CourseScreen") {
            print("sssssssssssssssssssss${DeliveryType}aaaaaa");

            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CourseScreen(deliveryType: DeliveryType),
              ),
            );
            
          } else if (text == "Treatment") {
          } else if (text == "ShopScreen") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ShopScreen(deliveryType: DeliveryType),
              ),
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



class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  final String _baseUrl = "https://jinreflexology.in/api1/new/";

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": 0,
          "message": "Server Error ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": 0,
        "message": e.toString(),
      };
    }
  }
}
