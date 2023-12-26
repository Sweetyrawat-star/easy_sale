import 'package:boilerplate/models/routing/routing.dart';
import 'package:boilerplate/models/store/store.dart';

class RoutingDetail {
  Routing routing;
  List<Store> stores;

  RoutingDetail({
    required this.routing,
    required this.stores,
  });

  factory RoutingDetail.fromMap(Map<String, dynamic> json) => RoutingDetail(
        routing: Routing.fromMap(json["schedule"]),
        stores:
            List<Store>.from(json["shops"].map((elem) => Store.fromMap(elem))),
      );
}
