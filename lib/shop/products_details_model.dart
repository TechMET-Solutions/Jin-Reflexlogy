class ProductPricing {
  final String country;
  final double unitPrice;
  final double shippingPrice;
  final double totalPrice;

  ProductPricing({
    required this.country,
    required this.unitPrice,
    required this.shippingPrice,
    required this.totalPrice,
  });

  factory ProductPricing.fromJson(Map<String, dynamic> json) {
    return ProductPricing(
      country: json['country'] ?? '',
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      shippingPrice:
          double.tryParse(json['shipping_price']?.toString() ?? '0') ?? 0.0,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
    );
  }
}
