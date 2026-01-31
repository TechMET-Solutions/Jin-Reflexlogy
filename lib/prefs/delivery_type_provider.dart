import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global provider for delivery type management
/// This ensures all screens stay in sync when delivery type changes
class DeliveryTypeNotifier extends StateNotifier<String> {
  DeliveryTypeNotifier() : super("india") {
    _loadDeliveryType();
  }

  /// Load delivery type from SharedPreferences on init
  Future<void> _loadDeliveryType() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type") ?? "india";
    state = deliveryType;
  }

  /// Update delivery type and persist to SharedPreferences
  Future<void> setDeliveryType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("delivery_type", type);
    state = type;
  }

  /// Get country code (in/us) based on delivery type
  String get countryCode => state == "india" ? "in" : "us";

  /// Check if user is from India
  bool get isIndian => state == "india";

  /// Get currency symbol
  String get currencySymbol => state == "india" ? "₹" : "\$";

  /// Get currency code
  String get currencyCode => state == "india" ? "INR" : "USD";
}

/// Provider instance - use this in your widgets
final deliveryTypeProvider = StateNotifierProvider<DeliveryTypeNotifier, String>((ref) {
  return DeliveryTypeNotifier();
});

/// Convenience providers for common use cases
final countryCodeProvider = Provider<String>((ref) {
  final deliveryType = ref.watch(deliveryTypeProvider);
  return deliveryType == "india" ? "in" : "us";
});

final isIndianUserProvider = Provider<bool>((ref) {
  final deliveryType = ref.watch(deliveryTypeProvider);
  return deliveryType == "india";
});

final currencySymbolProvider = Provider<String>((ref) {
  final deliveryType = ref.watch(deliveryTypeProvider);
  return deliveryType == "india" ? "₹" : "\$";
});

final currencyCodeProvider = Provider<String>((ref) {
  final deliveryType = ref.watch(deliveryTypeProvider);
  return deliveryType == "india" ? "INR" : "USD";
});
