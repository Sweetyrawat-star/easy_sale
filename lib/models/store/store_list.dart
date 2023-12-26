import 'store.dart';

class StoreList {
  final List<Store> stores;

  StoreList({
    required this.stores,
  });

  factory StoreList.fromJson(List<dynamic> json) {
    List<Store> stores = <Store>[];
    stores = json.map((store) => Store.fromMap(store)).toList();

    return StoreList(
      stores: stores,
    );
  }

  add(Store store) {
    this.stores.add(store);
  }

  addAll(List<Store> stores) {
    this.stores.addAll(stores);
  }
}
