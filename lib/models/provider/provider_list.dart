import 'provider.dart';

class ProviderList {
  final List<Provider>? brands;

  ProviderList({
    this.brands,
  });

  factory ProviderList.fromJson(List<dynamic> json) {
    List<Provider> brands = <Provider>[];
    brands = json.map((brand) => Provider.fromMap(brand)).toList();

    return ProviderList(
      brands: brands,
    );
  }
}
