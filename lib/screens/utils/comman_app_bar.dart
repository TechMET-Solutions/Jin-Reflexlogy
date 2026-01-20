import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/prefs/app_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/prefs/app_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/prefs/app_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showBalance;
  final String? userId;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.showBalance = false,
    this.userId,
  });

  @override
  State<CommonAppBar> createState() => _CommonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  Future<int>? _balanceFuture;
  String _currencySymbol = "₹";

  @override
  void initState() {
    super.initState();
    if (widget.showBalance) {
      _balanceFuture = fetchBalance();

      _loadCurrencySymbol();
    }
  }

  /// 🔹 FETCH BALANCE (FORM-DATA API)
  Future<int> fetchBalance() async {
    // if (therapistId == null || therapistId.isEmpty) {
    //   throw Exception("Invalid therapistId");
    // }
    print(
      "ddddddddddddddddddddddddddddddddddddd${AppPreference().getString(PreferencesKey.userId)}",
    );
    final dio = Dio();
    final response = await dio.post(
      "https://jinreflexology.in/api1/new/getTherapistBalance.php",
      data: FormData.fromMap({"therapistId": "${widget.userId}"}),
    );

    final json = response.data;
    debugPrint("BALANCE RESPONSE => $json");

    if (json["success"] == 1) {
      return int.parse(json["balance"].toString());
    } else {
      throw Exception(json["message"] ?? "No balance");
    }
  }

  /// 🔹 LOAD ₹ / $
  Future<void> _loadCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currencySymbol =
          prefs.getString("delivery_type") == "india" ? "₹" : "\$";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      automaticallyImplyLeading: false,
      centerTitle: false,

      leading:
          widget.showBack
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed:
                    widget.onBack ?? () => Navigator.of(context).maybePop(),
              )
              : null,

      title: Text(
        widget.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      actions: [
        if (widget.showBalance)
          FutureBuilder<int>(
            future: _balanceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const SizedBox(); // error ignore
              }

              final balance = snapshot.data ?? 0;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$_currencySymbol $balance",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

        ...?widget.actions,
      ],
    );
  }
}

class ApiServices {
  static const baseUrl = 'https://jinreflexology.in/api1/new/';

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, String> body,
  ) async {
    final response = await http.post(Uri.parse(baseUrl + endpoint), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API failed');
    }
  }
}

final therapistBalanceProvider = FutureProvider.family<int, String>((
  ref,
  therapistId,
) async {
  final res = await ApiServices.post('getTherapistBalance.php', {
    'therapistId': therapistId,
  });

  if (res['success'] == 1) {
    return res['balance'];
  } else {
    throw Exception('No balance');
  }
});
