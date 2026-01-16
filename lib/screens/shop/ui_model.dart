class Product {
  final String id;
  final String title;
  final String image;

  final double unitPrice;
  final double shippingPrice;

  final String description;
  final String details;
  final String additionalInfo;

  // 🔥 REQUIRED FOR CATEGORY FILTER
  final List<String> categories;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.unitPrice,
    required this.shippingPrice,
    required this.description,
    required this.details,
    required this.additionalInfo,
    required this.categories,
  });
}
