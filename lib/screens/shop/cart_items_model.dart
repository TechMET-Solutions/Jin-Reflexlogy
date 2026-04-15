class CartItem {
  final int id; // Cart item ID (from cart table)
  final int productId; // Add this - actual product ID
  final String name;
  final double price;
  final int quantity;
  final String image;
  
  CartItem({
    required this.id,
    required this.productId, // Add this
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = (json['product'] as Map?)?.cast<String, dynamic>() ?? {};
    final images = (product['images'] as List?) ?? const [];

    return CartItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      name: product['title']?.toString() ?? '',
      price: double.tryParse(product['price']?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      image: images.isNotEmpty ? images.first.toString() : '',
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    String? name,
    double? price,
    int? quantity,
    String? image,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}

