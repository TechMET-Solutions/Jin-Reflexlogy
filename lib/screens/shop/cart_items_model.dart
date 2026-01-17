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
    return CartItem(
      id: json['id'] ?? 0, // Cart item ID
      productId: json['product_id'] ?? 0, // Extract from cart response
      name: json['product']['title'] ?? '',
      price: (json['product']['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      image: (json['product']['images'] as List?)?.first ?? '',
    );
  }
}

