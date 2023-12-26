import 'brand.dart';

class BrandList {
  final List<Brand>? brands;

  BrandList({
    this.brands,
  });

  factory BrandList.fromJson(List<dynamic> json) {
    List<Brand> brands = <Brand>[];
    brands = json.map((brand) => Brand.fromMap(brand)).toList();

    return BrandList(
      brands: brands,
    );
  }
}
