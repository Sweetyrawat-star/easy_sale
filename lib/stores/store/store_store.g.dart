// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StoreStore on _StoreStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_StoreStore.loading'))
      .value;

  late final _$fetchStoresFutureAtom =
      Atom(name: '_StoreStore.fetchStoresFuture', context: context);

  @override
  ObservableFuture<StoreList?> get fetchStoresFuture {
    _$fetchStoresFutureAtom.reportRead();
    return super.fetchStoresFuture;
  }

  @override
  set fetchStoresFuture(ObservableFuture<StoreList?> value) {
    _$fetchStoresFutureAtom.reportWrite(value, super.fetchStoresFuture, () {
      super.fetchStoresFuture = value;
    });
  }

  late final _$createStoreFutureAtom =
      Atom(name: '_StoreStore.createStoreFuture', context: context);

  @override
  ObservableFuture<MyStore.Store?> get createStoreFuture {
    _$createStoreFutureAtom.reportRead();
    return super.createStoreFuture;
  }

  @override
  set createStoreFuture(ObservableFuture<MyStore.Store?> value) {
    _$createStoreFutureAtom.reportWrite(value, super.createStoreFuture, () {
      super.createStoreFuture = value;
    });
  }

  late final _$storeListAtom =
      Atom(name: '_StoreStore.storeList', context: context);

  @override
  StoreList get storeList {
    _$storeListAtom.reportRead();
    return super.storeList;
  }

  @override
  set storeList(StoreList value) {
    _$storeListAtom.reportWrite(value, super.storeList, () {
      super.storeList = value;
    });
  }

  late final _$successAtom =
      Atom(name: '_StoreStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$getStoresAsyncAction =
      AsyncAction('_StoreStore.getStores', context: context);

  @override
  Future<dynamic> getStores(Map<String, dynamic> params) {
    return _$getStoresAsyncAction.run(() => super.getStores(params));
  }

  late final _$createStoreAsyncAction =
      AsyncAction('_StoreStore.createStore', context: context);

  @override
  Future<dynamic> createStore(MyStore.Store store) {
    return _$createStoreAsyncAction.run(() => super.createStore(store));
  }

  late final _$_StoreStoreActionController =
      ActionController(name: '_StoreStore', context: context);

  @override
  dynamic addStore(MyStore.Store store) {
    final _$actionInfo =
        _$_StoreStoreActionController.startAction(name: '_StoreStore.addStore');
    try {
      return super.addStore(store);
    } finally {
      _$_StoreStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchStoresFuture: ${fetchStoresFuture},
createStoreFuture: ${createStoreFuture},
storeList: ${storeList},
success: ${success},
loading: ${loading}
    ''';
  }
}
