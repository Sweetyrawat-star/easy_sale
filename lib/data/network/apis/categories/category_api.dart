import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/api/api.dart';


class CategoryApi {
  // dio instance
  final DioClient _dioClient;

  final RestClient _restClient;

  // injecting dio instance
  CategoryApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<dynamic> getChannel() async {
    print(this._restClient);
    try {
      final ApiResponse res =
          await _dioClient.get(Endpoints.getCategories, queryParameters: {"type": "chanel"});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> getChannel1(String? parentId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getCategories,
          queryParameters: {"parent_id": parentId, "type": "chanel_1"});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> getChannel2(String? parentId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getCategories,
          queryParameters: {"parent_id": parentId, "type": "chanel_2"});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
