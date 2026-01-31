import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jin_reflex_new/prefs/delivery_type_provider.dart';

/// Reusable country selector widget
/// Automatically updates all screens when country changes
class CountrySelectorWidget extends ConsumerWidget {
  final bool showLabel;
  final bool compact;
  final Function()? onChanged;

  const CountrySelectorWidget({
    super.key,
    this.showLabel = true,
    this.compact = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryType = ref.watch(deliveryTypeProvider);
    final countryCode = deliveryType == "india" ? "in" : "us";

    if (compact) {
      return _buildCompactSelector(context, ref, countryCode);
    }

    return _buildFullSelector(context, ref, countryCode);
  }

  Widget _buildCompactSelector(BuildContext context, WidgetRef ref, String countryCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: DropdownButton<String>(
        value: countryCode,
        underline: const SizedBox(),
        isDense: true,
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.blue[700],
        ),
        items: const [
          DropdownMenuItem(
            value: "in",
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🇮🇳", style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Text("India"),
              ],
            ),
          ),
          DropdownMenuItem(
            value: "us",
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🌍", style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Text("International"),
              ],
            ),
          ),
        ],
        onChanged: (value) async {
          if (value != null && value != countryCode) {
            final deliveryType = value == "in" ? "india" : "outside";
            await ref.read(deliveryTypeProvider.notifier).setDeliveryType(deliveryType);
            
            if (onChanged != null) {
              onChanged!();
            }
            
            // Show feedback
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value == "in" 
                      ? "Switched to India 🇮🇳" 
                      : "Switched to International 🌍",
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildFullSelector(BuildContext context, WidgetRef ref, String countryCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Text(
            "Select Country/Region",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        if (showLabel) const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<String>(
            value: countryCode,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[900],
            ),
            items: const [
              DropdownMenuItem(
                value: "in",
                child: Row(
                  children: [
                    Text("🇮🇳", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "India",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Prices in ₹ (INR)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "us",
                child: Row(
                  children: [
                    Text("🌍", style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "International",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Prices in \$ (USD)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) async {
              if (value != null && value != countryCode) {
                final deliveryType = value == "in" ? "india" : "outside";
                await ref.read(deliveryTypeProvider.notifier).setDeliveryType(deliveryType);
                
                if (onChanged != null) {
                  onChanged!();
                }
                
                // Show feedback
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value == "in" 
                          ? "Switched to India 🇮🇳 - Prices in ₹" 
                          : "Switched to International 🌍 - Prices in \$",
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
