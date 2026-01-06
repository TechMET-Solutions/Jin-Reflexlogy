import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';

class PhonePePaymentScreen extends StatelessWidget {
  final Product product;

  const PhonePePaymentScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PhonePe Payment"),
        backgroundColor: Color.fromARGB(255, 19, 4, 66),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Product: ${product.title}"),
            const SizedBox(height: 20),
            const Text("PhonePe Payment Integration"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}