import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalDemoScreen extends StatelessWidget {
  const PayPalDemoScreen({super.key});

  Future<void> clearPaypalSession() async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(title: const Text('PayPal Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            //  await clearPaypalSession(); // important
            _startPayPalPayment(context);
          },
          child: const Text('Pay with PayPal'),
        ),
      ),
    );
  }

  void _startPayPalPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: true,

              clientId:
                  "Aa-t5qPKfuLGWj-ZRbOfUFECWrlgkwCYJpMXAe_fGI6i0LH3wdoW-bWWxa2WRDY-eDKaij4-6smAqsTu",
              secretKey:
                  "EG-0tCL62enXJ2DolLLQ_dJCiO4yyJY1z-ptjp1_06oHGnXfLul7yHWyIwAd1sqmtRoS0wqutCwwEikd",

              /// ✅ ONLY AMOUNT – NO PRODUCT
              transactions: const [
                {
                  "amount": {
                    "total": "6", // example: $0.60
                    "currency": "USD",
                  },
                  "description": "Wallet / Service Payment",
                },
              ],

              note: "Demo PayPal payment",

              onSuccess: (Map params) async {
                debugPrint("✅ PayPal Success: $params");
                Navigator.pop(context);
              },

              onError: (error) {
                debugPrint("❌ PayPal Error: $error");
                Navigator.pop(context);
              },

              onCancel: () {
                debugPrint("⚠️ PayPal Cancelled");
                Navigator.pop(context);
              },
            ),
      ),
    );
  }
}
