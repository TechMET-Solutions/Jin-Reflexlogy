import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePayScreen extends StatefulWidget {
  const PhonePayScreen({super.key});

  @override
  State<PhonePayScreen> createState() => _PhonePayScreenState();
}

class _PhonePayScreenState extends State<PhonePayScreen> {
  String environment = "SANDBOX";
  String merchantId = "M1MMOQL7SDJD_25122407382";
  String flowId = ""; // MUST be empty
  bool enableLogs = true;

  String appSchema = "com.jin_Relexlogy"; // ✅ package name

  final Map<String, dynamic> payload = {
    "orderId": "OMO2601051056300341057328",
    "merchantId": "M1MMOQL7SDJD_25122407382",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzT24iOjE3Njc1OTQxODMxNzYsIm1lcmNoYW50SWQiOiJNMU1NT1FMN1NESkQifQ.m28Y8CN1UN7QWxXX5Ie0E-Z9JtwYRX245q4DYXnmUp4",
    "paymentMode": {"type": "PAY_PAGE"},
  };

  late final String request = jsonEncode(payload);

  @override
  void initState() {
    super.initState();
    initSdk();
  }

  void initSdk() {
    PhonePePaymentSdk.init(
      environment,
      merchantId,
      flowId,
      enableLogs,
    ).then((value) {
      print("✅ PhonePe SDK Initialized");
    }).catchError((e) {
      print("❌ SDK Init Error: $e");
    });
  }

void startTransaction() {
  PhonePePaymentSdk.startTransaction(
    request,     // order token JSON string
    appSchema,   // package name / scheme
  ).then((value) {
    print("📦 Response: $value");
  }).catchError((e) {
    print("❌ Transaction Error: $e");
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PhonePe Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: startTransaction,
          child: const Text("Pay with PhonePe"),
        ),
      ),
    );
  }
}
