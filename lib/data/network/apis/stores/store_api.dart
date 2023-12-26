import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/store/store.dart';

import '../../../../models/store/store_list.dart';

class StoreApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  StoreApi(this._dioClient);

  /// Returns list of post in response
  Future<StoreList> getStores(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getStores, queryParameters: params);
      return StoreList.fromJson(res.data["data"]);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Store> getStore(String id) async {
    try {
      final res = await _dioClient.get(Endpoints.getStore, queryParameters: {"id": id});
      return Store.fromMap(res.data);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Store> createStore(Store store) async {
    try {
      final res = await _dioClient.post(Endpoints.createStore, data: store.toMap());
      return Store.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
