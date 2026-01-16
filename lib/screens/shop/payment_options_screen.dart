import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String selectedUPI = "gpay";
  bool upiExpanded = true;
  bool cardExpanded = false;
  bool codExpanded = false;
  bool netbankExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Payment Options"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Options",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            // 🔵 UPI OPTION CARD
            _buildTile(
              title: "UPI",
              icon: Icons.account_balance_wallet_outlined,
              expanded: upiExpanded,
              onTap: () {
                setState(() {
                  upiExpanded = !upiExpanded;
                  cardExpanded = false;
                  codExpanded = false;
                  netbankExpanded = false;
                });
              },
              child: Column(
                children: [
                  _upiOption("Google Pay", "gpay", "assets/images/gpay.png"),
                  _upiOption(
                    "PhonePe",
                    "phonepe",
                    "assets/images/phonepay.png",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Card
            _buildTile(
              title: "Credit/Debit Card",
              icon: Icons.credit_card,
              expanded: cardExpanded,
              onTap: () {
                setState(() {
                  cardExpanded = !cardExpanded;
                  upiExpanded = false;
                  codExpanded = false;
                  netbankExpanded = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Enter your card details here..."),
              ),
            ),

            const SizedBox(height: 10),

            // COD
            _buildTile(
              title: "Cash on Delivery",
              icon: Icons.delivery_dining,
              expanded: codExpanded,
              onTap: () {
                setState(() {
                  codExpanded = !codExpanded;
                  upiExpanded = false;
                  cardExpanded = false;
                  netbankExpanded = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Pay when your order arrives."),
              ),
            ),

            const SizedBox(height: 10),

            // Netbanking
            _buildTile(
              title: "Net Banking",
              icon: Icons.account_balance_outlined,
              expanded: netbankExpanded,
              onTap: () {
                setState(() {
                  netbankExpanded = !netbankExpanded;
                  upiExpanded = false;
                  cardExpanded = false;
                  codExpanded = false;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Select your preferred bank."),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      // FIXED BOTTOM BUTTON
      bottomSheet: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
        child: Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF130442),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            child: const Text(
              "Proceed to Payment",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================
  // 🔷 PAYMENT OPTION TILE UI
  // ==========================

  Widget _buildTile({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: Icon(icon, color: Colors.black),
            trailing: Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onTap: onTap,
          ),

          if (expanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: child,
            ),
        ],
      ),
    );
  }

  // ==========================
  // 🔷 EACH UPI OPTION
  // ==========================

  Widget _upiOption(String label, String key, String iconPath) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(iconPath, height: 25),
      title: Text(label),
      trailing: Radio(
        value: key,
        groupValue: selectedUPI,
        onChanged: (value) {
          setState(() => selectedUPI = value.toString());
        },
      ),
    );
  }
}
