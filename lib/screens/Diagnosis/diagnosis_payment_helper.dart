import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> showDiagnosisPaymentPopup(BuildContext context) async {
  final amountController = TextEditingController();
  final razorpay = Razorpay();
  final completer = Completer<bool>();
  bool showValidation = false;
  bool isDisposed = false;

  Future<bool> isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("delivery_type") == "india";
  }

  Future<void> sendPaymentToBackend({
    required String status,
    String? paymentId,
    String? orderId,
    String? reason,
    required int amount,
  }) async {
    try {
      await Dio().post(
        "https://admin.jinreflexology.in/api/payment_callback",
        data: {
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "payment_id": paymentId,
          "orderid": orderId,
          "amount": amount.toString(),
          "status": status,
          "reason": reason,
          "email": AppPreference().getString(PreferencesKey.email),
          "name": AppPreference().getString(PreferencesKey.name),
          "contact": AppPreference().getString(PreferencesKey.contactNumber),
        },
      );
    } catch (e) {
      debugPrint("Diagnosis payment backend error: $e");
    }
  }

  void finish(bool value) {
    if (isDisposed) return;
    isDisposed = true;
    razorpay.clear();
    amountController.dispose();
    if (!completer.isCompleted) {
      completer.complete(value);
    }
  }

  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
    PaymentSuccessResponse response,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Success\nPayment ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );

    await sendPaymentToBackend(
      status: "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
      amount: int.tryParse(amountController.text) ?? 0,
    );

    finish(true);
  });

  razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (
    PaymentFailureResponse response,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );

    await sendPaymentToBackend(
      status: "failed",
      reason: response.message,
      amount: int.tryParse(amountController.text) ?? 0,
    );

    finish(false);
  });

  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (
    ExternalWalletResponse response,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return FutureBuilder<bool>(
        future: isIndianUser(),
        builder: (context, snapshot) {
          final bool isIndia = snapshot.data ?? true;

          return StatefulBuilder(
            builder: (context, setPopupState) {
              Future<void> startPaypalPayment() async {
                final String amount = amountController.text.trim();

                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PaypalCheckoutView(
                      sandboxMode: isSandboxMode,
                      clientId: paypalClientId,
                      secretKey: paypalSecret,
                      transactions: [
                        {
                          "amount": {"total": amount, "currency": "USD"},
                          "description": "Diagnosis Wallet Payment",
                        },
                      ],
                      note: "Diagnosis payment",
                      onSuccess: (Map params) async {
                        final paypalPaymentId = params["data"]?["id"];

                        await sendPaymentToBackend(
                          status: "success",
                          paymentId: paypalPaymentId,
                          orderId: null,
                          amount: int.tryParse(amountController.text) ?? 0,
                        );

                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        finish(true);
                      },
                      onError: (error) async {
                        await sendPaymentToBackend(
                          status: "failed",
                          reason: error.toString(),
                          amount: int.tryParse(amountController.text) ?? 0,
                        );

                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        finish(false);
                      },
                      onCancel: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        finish(false);
                      },
                    ),
                  ),
                );
              }

              return AlertDialog(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Insufficient Balance',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Please add amount to continue diagnosis',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Amount ${isIndia ? "(Rs)" : "(\$)"}',
                        border: const OutlineInputBorder(),
                        errorText:
                            showValidation ? 'Minimum 50 required' : null,
                      ),
                      onChanged: (_) {
                        if (showValidation) {
                          setPopupState(() => showValidation = false);
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      finish(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final amountText = amountController.text.trim();

                      if (amountText.isEmpty ||
                          int.tryParse(amountText) == null ||
                          int.parse(amountText) < 50) {
                        setPopupState(() => showValidation = true);
                        return;
                      }

                      final enteredAmount = int.parse(amountText);
                      Navigator.pop(dialogContext);

                      if (isIndia) {
                        razorpay.open({
                          'key': razorpayKey,
                          'amount': enteredAmount * 100,
                          'name': AppPreference().getString(PreferencesKey.name),
                          'description': 'Diagnosis Wallet Payment',
                          'prefill': {
                            'contact': AppPreference().getString(
                              PreferencesKey.contactNumber,
                            ),
                            'email': AppPreference().getString(
                              PreferencesKey.email,
                            ),
                          },
                        });
                      } else {
                        await startPaypalPayment();
                      }
                    },
                    child: const Text('Pay'),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );

  return completer.future;
}
