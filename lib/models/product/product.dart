import 'package:boilerplate/models/variant/variant_list.dart';

import '../brand/brand.dart';
import '../provider/provider.dart';

class Attribute {
  List<AttributeValue> values;
  String id;
  String name;
  Attribute({
    required this.values,
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "values": values,
      };

  factory Attribute.fromMap(Map<String, dynamic> json) {
    return new Attribute(
        values: List.from(
            json["values"].map((elem) => AttributeValue.fromMap(elem))),
        id: json["id"],
        name: json["name"]);
  }
}

class AttributeValue {
  String id;
  String value;

  AttributeValue({
    required this.id,
    required this.value,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "value": value,
      };

  factory AttributeValue.fromMap(Map<String, dynamic> json) {
    return new AttributeValue(id: json["id"], value: json["value"]);
  }
}

class Product {
  String id;
  String name;
  String code;
  String desc;
  String brandId;
  String providerId;
  String cateId;
  List<Attribute> attributes;
  ProductVariantList? variants;
  Brand? brand;
  Provider? provider;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.desc,
    required this.brandId,
    required this.providerId,
    required this.cateId,
    required this.attributes,
  });

  factory Product.fromMap(Map<String, dynamic> json) {
    return new Product(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        desc: json["desc"],
        brandId: json["brand_id"],
        providerId: json["provider_id"][0],
        cateId: json["category_id"],
        attributes: List.from(
            json["attributes"].map((elem) => Attribute.fromMap(elem))));
  }

  void setVariants(ProductVariantList list) => {
    this.variants = list
  };

  void setBrand(Brand brand) => {
    this.brand = brand
  };

  void setProvider(Provider provider) => {
    this.provider = provider
  };
}
