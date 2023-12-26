import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';
import 'package:collection/collection.dart';

import '../../models/cart/cart.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _CartStore(Repository repository) : this._repository = repository;

  static ObservableFuture<Cart?> emptyCartResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<Cart?> fetchCartFuture =
  ObservableFuture<Cart?>(emptyCartResponse);

  @observable
  Cart? cart;

  @observable
  ObservableList<CartItem>? list;

  @computed
  int get total => fetchCartFuture.status != FutureStatus.pending && (this.list?.length != 0) ?
  this.list?.map((element) => element.qty).reduce((value, element) => value + element) ?? 0 : 0;

  // actions:-------------------------------------------------------------------
  @action
  Future getCart() async {
    final future = _repository.getCart();
    fetchCartFuture = ObservableFuture(future);
    future.then((cart) {
      this.cart = cart;
      this.list = ObservableList.of(cart.items);
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  void addToCart(CartItem newItem) {
    var tmp = [...?this.list];
    CartItem? item = tmp.firstWhereOrNull((element) => element.id == newItem.id);
    if (item != null) {
      item.qty += newItem.qty;
    } else {
      tmp.add(newItem);
    }
    this.list = ObservableList<CartItem>.of(tmp);
  }

  @action
  void updateCart(String id, int quantity) {
    var tmp = [...?this.list];
    CartItem? item = tmp.firstWhereOrNull((element) => element.id == id);
    if (item != null) {
      item.qty += quantity;
    }
    tmp = List.from(tmp.where((element) => element.qty > 0));
    this.list = ObservableList<CartItem>.of(tmp);
  }

  @action
  void emptyCart() {
    this.list = ObservableList<CartItem>.of([]);
  }
}
