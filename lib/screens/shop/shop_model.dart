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
    return ProductByCountryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      total: json['total'] ?? 0,
      data: (json['data'] as List)
          .map((e) => CountryProduct.fromJson(e))
          .toList(),
    );
  }
}

class CountryProduct {
  final int id;
  final String title;
  final String description;
  final String? longDesc;
  final List<String> images;
  final double price;
  final double shippingCharges;
  final double totalPrice;
  final String productCountry;

  CountryProduct({
    required this.id,
    required this.title,
    required this.description,
    this.longDesc,
    required this.images,
    required this.price,
    required this.shippingCharges,
    required this.totalPrice,
    required this.productCountry,
  });

  factory CountryProduct.fromJson(Map<String, dynamic> json) {
    return CountryProduct(
      id: json['id'],
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      longDesc: json['longDesc'],
      images: (json['images'] as List?)?.cast<String>() ?? [],
      price: double.tryParse(json['price'].toString()) ?? 0,
      shippingCharges:
          double.tryParse(json['shipping_charges'].toString()) ?? 0,
      totalPrice:
          double.tryParse(json['total_price'].toString()) ?? 0,
      productCountry: json['productCountry'] ?? "",
    );
  }
}
