import 'product.dart';

class ProductList {
  final List<Product> products;

  ProductList({
    required this.products,
  });

  factory ProductList.fromJson(List<dynamic> json) {
    List<Product> products = <Product>[];
    products = json.map((store) => Product.fromMap(store)).toList();

    return ProductList(
      products: products,
    );
  }

  add(Product store) {
    this.products.add(store);
  }

  addAll(List<Product> products) {
    this.products.addAll(products);
  }
}
