import 'package:boilerplate/models/store/store.dart';

class ReceiveAddress {
  List<String> areaIds;
  String detail;
  String fullAddress;

  ReceiveAddress({
    required this.areaIds,
    required this.detail,
    required this.fullAddress,
  });

  factory ReceiveAddress.fromMap(Map<String, dynamic> json) => ReceiveAddress(
    areaIds: List.from(json["area_ids"]),
    detail: json["detail"],
    fullAddress: json["full_address"],
  );
}

class OrderItem {
  String variantId;
  int quantity;

  OrderItem({
    required this.variantId,
    required this.quantity
  });

  factory OrderItem.fromMap(Map<String, dynamic> json) => OrderItem(
    variantId: json["variant_id"],
    quantity: json["amount"],
  );
}

class Order {
  String id;
  String code;
  double price;
  double shippingFee;
  String status;
  int createdAt;
  ReceiveAddress recvAddress;
  List<OrderItem> items;
  Store shop;


  Order({
    required this.id,
    required this.code,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.shippingFee,
    required this.recvAddress,
    required this.items,
    required this.shop,
  });

  factory Order.fromMap(Map<String, dynamic> json) => Order(
    id: json["id"],
    code: json["code"],
    price: double.parse(json["price"].toString()),
    status: json["status"],
    recvAddress: ReceiveAddress.fromMap(json["recv_address"]),
    // shippingFee: double.parse(json["transport_fee"].toString()),
      shippingFee: double.parse(json["transport_fee"] != null ? json["transport_fee"].toString() : "0"),
      createdAt: json["created_at"] * 1000000,
    items: List.from(json["items"].map((e) => OrderItem.fromMap(e))),
    shop: Store.fromMap(json["shop"])
  );
}
