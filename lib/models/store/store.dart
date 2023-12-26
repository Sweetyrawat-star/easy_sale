class Address {
  List<dynamic> areaIds;
  String detail;
  String? fullAddress;
  double? lat;
  double? lng;
  Address({
    required this.areaIds,
    required this.detail,
    this.fullAddress,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toMap() => {
        "area_ids": areaIds,
        "detail": detail,
      };

  static empty() => Address(areaIds: [], detail: "");
}

class StarInfo {
  int count;
  int value;

  StarInfo({
    required this.count,
    required this.value,
  });

  Map<String, dynamic> toMap() => {
    "count": count,
    "value": value,
  };
}

class Star {
  double average;
  int total;
  Star({
    required this.average,
    required this.total,
  });

  Map<String, dynamic> toMap() => {
        "average": average,
        "total": total,
      };
}

class Store {
  String id;
  String name;
  String phone;
  String desc;
  String avatar;
  List<dynamic> images;
  double rating;
  Address? address;
  Star? star;

  Store({
    this.name = "",
    this.phone = "",
    this.desc = "",
    this.avatar = "",
    required this.images,
    this.id = "",
    this.rating = 0,
    this.address,
    this.star,
  });

  factory Store.fromMap(Map<String, dynamic> json) {
    var _star;
    if (json["star"] != null) {
      _star = Star(
        average: double.parse(json["star"]["average"] != null ? json["star"]["average"].toString() : "0"),
        total: json["star"]["total"],
      );
    }
    if (json["address"] != null) {
      var address = Address(
          areaIds: json["address"]["area_ids"],
          detail: json["address"]["detail"],
          fullAddress: json["address"]["full_address"],
          lat: double.parse(json["address"]["lat"] != null ? json["address"]["lat"].toString() : "0"),
          lng: double.parse(json["address"]["lng"] != null ? json["address"]["lng"].toString() : "0"));
      return Store(
          name: json["name"],
          phone: json["phone"] ?? "",
          desc: json["desc"] ?? "",
          avatar: json["avatar"],
          images: json["images"] ?? [],
          id: json["id"] ?? json["_id"],
          address: address,
          star: _star);
    } else {
      return Store(
        name: json["name"],
        phone: json["phone"] ?? "",
        desc: json["desc"],
        avatar: json["avatar"],
        images: json["images"] ?? [],
        id: json["id"] ?? json["_id"],
        star: _star,
      );
    }
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "phone": phone,
        "desc": desc,
        "avatar": avatar,
        "images": images,
        "address": address?.toMap(),
        "star": star?.toMap()
      };
}
