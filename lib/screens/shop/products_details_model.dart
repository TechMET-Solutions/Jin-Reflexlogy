class ProductDetailModel {
  final String? id;
  final String? name;
  final String? info;
  final double? price;
  final double? shipping;
  final double? total;
  final String? imageUrl; // ✅ added

  ProductDetailModel({
    this.id,
    this.name,
    this.info,
    this.price,
    this.shipping,
    this.total,
    this.imageUrl,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    String imgUrl = "";

    if (json['images'] != null && json['images'] is List) {
      final imgList = json['images'] as List;

      if (imgList.isNotEmpty) {
        final primary = imgList.firstWhere(
          (e) => e['is_primary'] == 1,
          orElse: () => imgList.first,
        );

        imgUrl = primary['image_url']?.toString() ?? "";
      }
    }

    return ProductDetailModel(
      id: json["id"],
      name: json["name"],
      info: json["info"],
      price:
          json["price"] != null
              ? double.tryParse(json["price"].toString())
              : null,
      shipping:
          json["shipping"] != null
              ? double.tryParse(json["shipping"].toString())
              : null,
      total:
          json["total"] != null
              ? double.tryParse(json["total"].toString())
              : null,
      imageUrl: imgUrl.isNotEmpty ? imgUrl : null,
    );
  }
}
