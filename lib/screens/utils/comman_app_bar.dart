import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/prefs/app_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showBalance;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.showBalance = false,
  });

  Future<bool> isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type");
    return deliveryType == "india";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(
      therapistBalanceProvider(
        AppPreference()
            .getString(PreferencesKey.userId)
            .toString(),
      ),
    );

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      automaticallyImplyLeading: false,

      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white),
              onPressed:
                  onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,

      actions: [
        if (showBalance)
          balanceAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
            error: (_, __) => const SizedBox(),

            data: (balance) => FutureBuilder<bool>(
              future: isIndianUser(),
              builder: (context, snapshot) {
                final isIndia = snapshot.data ?? true;
                final symbol = isIndia ? "₹" : "\$";  

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$symbol $balance",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}

class ApiServices {
  static const baseUrl =
      'https://jinreflexology.in/api1/new/';

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, String> body,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API failed');
    }
  }
}




final therapistBalanceProvider =
    FutureProvider.family<int, String>((ref, therapistId) async {
  final res = await ApiServices.post(
    'getTherapistBalance.php',
    {'therapistId': therapistId},
  );

  if (res['success'] == 1) {
    return res['balance']; 
  } else {
    throw Exception('No balance');
  }
});
