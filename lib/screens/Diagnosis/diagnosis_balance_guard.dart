import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_payment_helper.dart';

Future<bool> ensureDiagnosisBalanceAvailable(BuildContext context) async {
  try {
    final therapistId = AppPreference().getString(PreferencesKey.userId);

    if (therapistId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to verify balance. Please login again."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    Future<int> fetchBalance() async {
      final response = await Dio().post(
        "https://jinreflexology.in/api1/new/getTherapistBalance.php",
        data: FormData.fromMap({"therapistId": therapistId}),
      );

      final data = response.data;
      if (data["success"] != 1) return 0;
      return int.tryParse(
            (data["balance"] ??
                    data["wallet_balance"] ??
                    data["available_balance"] ??
                    0)
                .toString(),
          ) ??
          0;
    }

    int balance = await fetchBalance();

    if (balance <= 0) {
      final bool paid = await showDiagnosisPaymentPopup(context);
      if (!paid) {
        return false;
      }

      for (int attempt = 0; attempt < 4; attempt++) {
        await Future.delayed(Duration(milliseconds: 800 + (attempt * 700)));
        balance = await fetchBalance();
        if (balance > 0) {
          break;
        }
      }

      if (balance <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Payment completed. Balance is updating, please try diagnosis again.",
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return false;
      }
    }

    return true;
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Could not check balance. Please try again."),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }
}
