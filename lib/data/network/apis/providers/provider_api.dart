import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/api/api.dart';
import '../../../../models/provider/provider.dart';
import '../../../../models/provider/provider_list.dart';


class ProviderApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  ProviderApi(this._dioClient);

  /// Returns list of post in response
  Future<dynamic> getProvidersByCateId(String cateId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getProviders,
          queryParameters: {"category_id": cateId});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<ProviderList> getProviders(Map<String, dynamic> params) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getProviders,
          queryParameters: params);
      return ProviderList.fromJson(res.data["data"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Provider> getProvider(String brandId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getProvider,
          queryParameters: {"id": brandId});
      return Provider.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
