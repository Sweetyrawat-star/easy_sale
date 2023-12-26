import 'routing.dart';

class RoutingList {
  final List<Routing> routings;

  RoutingList({
    required this.routings,
  });

  factory RoutingList.fromJson(List<dynamic> json) {
    List<Routing> stores = <Routing>[];
    stores = json.map((store) => Routing.fromMap(store)).toList();

    return RoutingList(
      routings: stores,
    );
  }
}
