import 'package:jin_reflex_new/screens/shop/products_details_model.dart';
import 'package:jin_reflex_new/screens/shop/ui_model.dart';
import 'package:jin_reflex_new/shop/products_details_model.dart' hide ProductPricing;

class ProductByCountryResponse {
  final bool success;
  final String message;
  final List<ProductByCountry> data;

  ProductByCountryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductByCountryResponse.fromJson(Map<String, dynamic> json) {
    return ProductByCountryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => ProductByCountry.fromJson(e))
              .toList(),
    );
  }
}

class ProductByCountry {
  final int id;
  final String title;
  final String description;
  final String? longDesc;
  final List<String> images;
  final List<ProductPricing> pricing;

  ProductByCountry({
    required this.id,
    required this.title,
    required this.description,
    this.longDesc,
    required this.images,
    required this.pricing,
  });

  factory ProductByCountry.fromJson(Map<String, dynamic> json) {
    return ProductByCountry(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      longDesc: json['longDesc'],
      images:
          (json['images'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      pricing:
          (json['pricing'] as List<dynamic>? ?? [])
              .map((e) => ProductPricing.fromJson(e))
              .toList(),
    );
  }

  /// 🔥 Helper: get pricing for selected country
  ProductPricing? priceForCountry(String countryCode) {
    try {
      return pricing.firstWhere((p) => p.country == countryCode);
    } catch (_) {
      return null;
    }
  }
}
