// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStore, Store {
  Computed<int>? _$totalComputed;

  @override
  int get total => (_$totalComputed ??=
          Computed<int>(() => super.total, name: '_CartStore.total'))
      .value;

  late final _$fetchCartFutureAtom =
      Atom(name: '_CartStore.fetchCartFuture', context: context);

  @override
  ObservableFuture<Cart?> get fetchCartFuture {
    _$fetchCartFutureAtom.reportRead();
    return super.fetchCartFuture;
  }

  @override
  set fetchCartFuture(ObservableFuture<Cart?> value) {
    _$fetchCartFutureAtom.reportWrite(value, super.fetchCartFuture, () {
      super.fetchCartFuture = value;
    });
  }

  late final _$cartAtom = Atom(name: '_CartStore.cart', context: context);

  @override
  Cart? get cart {
    _$cartAtom.reportRead();
    return super.cart;
  }

  @override
  set cart(Cart? value) {
    _$cartAtom.reportWrite(value, super.cart, () {
      super.cart = value;
    });
  }

  late final _$listAtom = Atom(name: '_CartStore.list', context: context);

  @override
  ObservableList<CartItem>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(ObservableList<CartItem>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$getCartAsyncAction =
      AsyncAction('_CartStore.getCart', context: context);

  @override
  Future<dynamic> getCart() {
    return _$getCartAsyncAction.run(() => super.getCart());
  }

  late final _$_CartStoreActionController =
      ActionController(name: '_CartStore', context: context);

  @override
  void addToCart(CartItem newItem) {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.addToCart');
    try {
      return super.addToCart(newItem);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCart(String id, int quantity) {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.updateCart');
    try {
      return super.updateCart(id, quantity);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void emptyCart() {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.emptyCart');
    try {
      return super.emptyCart();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchCartFuture: ${fetchCartFuture},
cart: ${cart},
list: ${list},
total: ${total}
    ''';
  }
}
