import 'variant.dart';

class ProductVariantList {
  final List<ProductVariant> productVariants;

  ProductVariantList({
    required this.productVariants,
  });

  factory ProductVariantList.fromJson(List<dynamic> json) {
    List<ProductVariant> variants = <ProductVariant>[];
    variants = json.map((data) => ProductVariant.fromMap(data)).toList();

    return ProductVariantList(
      productVariants: variants,
    );
  }
}
