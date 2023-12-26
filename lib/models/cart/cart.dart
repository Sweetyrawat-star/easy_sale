import 'package:collection/collection.dart';

class CartItem {
  String id;
  String name;
  int qty;
  num price;
  String providerId;
  String providerName;
  String attrs;
  String image;

  CartItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.providerId,
    required this.providerName,
    required this.attrs,
    required this.image,
  });

  factory CartItem.fromMap(Map<String, dynamic> json) {
    return CartItem(
        name: json["variant_name"],
        id: json["variant_id"],
        qty: json["amount"],
        price: double.parse(json["price"].toString()),
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        attrs: json["attr_string"],
        image: json["image"],
    );
  }
}

class Cart {
  List<CartItem> items;

  Cart({
    required this.items
  });

  factory Cart.fromMap(Map<String, dynamic> json) => Cart(
    items: List.from(json["items"].map((elem) => CartItem.fromMap(elem))));

  int getTotal() {
    return items.map((elem) => elem.qty).reduce((value, element) {
      return value + element;
    });
  }

  void addItem(CartItem newItem) {
    var tmp = [...this.items];
    CartItem? item = tmp.firstWhereOrNull((element) => element.id == newItem.id);
    if (item != null) {
      item.qty += newItem.qty;
    } else {
      tmp.add(newItem);
    }

    this.items = tmp;
  }
}
