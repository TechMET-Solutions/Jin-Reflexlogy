class ProductByCountryResponse {
  final bool success;
  final String message;
  final int total;
  final List<CountryProduct> data;

  ProductByCountryResponse({
    required this.success,
    required this.message,
    required this.total,
    required this.data,
  });

  factory ProductByCountryResponse.fromJson(Map<String, dynamic> json) {
    final List list = json['data'] ?? [];

    return ProductByCountryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      total: list.length,
      data: list.map((e) => CountryProduct.fromJson(e)).toList(),
    );
  }
}

class CountryProduct {
  final int id;
  final String title;
  final String description;
  final String? longDesc;

  final List<String> images;
  final List<String> categories;

  final double unitPrice;
  final double shippingCharges;
  final double totalPrice;

  final String productCountry;

  CountryProduct({
    required this.id,
    required this.title,
    required this.description,
    this.longDesc,
    required this.images,
    required this.categories,
    required this.unitPrice,
    required this.shippingCharges,
    required this.totalPrice,
    required this.productCountry,
  });

  factory CountryProduct.fromJson(Map<String, dynamic> json) {
    /// 🔐 SAFE LISTS
    final List categoryList = json['categories'] ?? [];
    final List pricingList = json['pricing'] ?? [];

    /// 🔐 SAFE PRICING OBJECT
    final Map<String, dynamic>? pricing =
        pricingList.isNotEmpty ? pricingList.first : null;

    return CountryProduct(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      longDesc: json['longDesc'],

      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],

      categories:
          categoryList.isNotEmpty
              ? categoryList
                  .map<String>((c) => c['name']?.toString() ?? "")
                  .where((e) => e.isNotEmpty)
                  .toList()
              : [],

      unitPrice:
          pricing != null
              ? double.tryParse(pricing['unit_price']?.toString() ?? "0") ?? 0
              : 0,

      shippingCharges:
          pricing != null
              ? double.tryParse(pricing['shipping_price']?.toString() ?? "0") ??
                  0
              : 0,

      totalPrice:
          pricing != null
              ? double.tryParse(pricing['total_price']?.toString() ?? "0") ?? 0
              : 0,

      productCountry: pricing?['country']?.toString() ?? "",
    );
  }
}
