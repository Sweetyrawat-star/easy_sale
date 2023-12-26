import 'package:boilerplate/models/store/store.dart';

class VisitingShop {
  String id;
  String name;
  String phone;
  String address;
  String avatar;
  Address shopAddress;

  VisitingShop({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.shopAddress,
  });
}

class Visit {
  String id;
  List<String> checkinImgs;
  List<String>? checkoutImgs;
  VisitingShop currentShop;

  Visit({
    required this.checkinImgs,
    required this.currentShop,
    required this.id,
    this.checkoutImgs,
  });

  bool stepVisited(String step) {
    print("step: " + step);
    if (step == "checkin") {
      return this.checkinImgs.length != 0;
    }
    return false;
  }
}
