import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/api/api.dart';


class AreaApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  AreaApi(this._dioClient);

  /// Returns list of post in response
  Future<dynamic> getProvinces() async {
    try {
      final ApiResponse res =
          await _dioClient.get(Endpoints.getAreas, queryParameters: {"type": "province"});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> getDistricts(String? parentId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getAreas,
          queryParameters: {"parent_id": parentId, "type": "district"});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> getWards(String? parentId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getAreas,
          queryParameters: {"parent_id": parentId, "type": "ward"});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
