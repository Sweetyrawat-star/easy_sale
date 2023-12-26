class ProductVariant {
  String productId;
  String id;
  String name;
  String code;
  List<String> images;
  num price;
  num preSalePrice;
  Map kv;

  ProductVariant({
    required this.productId,
    required this.id,
    required this.name,
    required this.code,
    required this.images,
    required this.price,
    required this.preSalePrice,
    required this.kv,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> json) {
    return new ProductVariant(
        productId: json["product_id"],
        id: json["id"],
        name: json["v_name"],
        code: json["sku"],
        kv: json["kv"],
        price: json["price"],
        preSalePrice: json["pre_sale_price"],
        images: List.from(json["images"]));
  }
}
