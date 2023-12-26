import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/store/store_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

import '../../models/store/store.dart' as MyStore;

part 'store_store.g.dart';

class StoreStore = _StoreStore with _$StoreStore;

abstract class _StoreStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _StoreStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<StoreList?> emptyStoreResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<StoreList?> fetchStoresFuture =
      ObservableFuture<StoreList?>(emptyStoreResponse);
  @observable
  ObservableFuture<MyStore.Store?> createStoreFuture =
      ObservableFuture<MyStore.Store?>(ObservableFuture.value(null));

  @observable
  StoreList storeList = new StoreList(stores: []);

  @observable
  bool success = false;

  @computed
  bool get loading => fetchStoresFuture.status == FutureStatus.pending
      || createStoreFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getStores(Map<String, dynamic> params) async {
    final future = _repository.getStores(params);
    fetchStoresFuture = ObservableFuture(future);

    future.then((storeList) {
      this.storeList.addAll(storeList.stores);
    }).catchError((error) {
      print(error);
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future createStore(MyStore.Store store) async {
    final future = _repository.createStore(store);
    createStoreFuture = ObservableFuture(future);
    future.then((data) {
      this.storeList.add(data);
    }).catchError((error) {
      print('store error: ' + error);
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action addStore(MyStore.Store store) {
  }
}
