import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/api/api.dart';
import 'package:boilerplate/models/brand/brand.dart';

import '../../../../models/brand/brand_list.dart';


class BrandApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  BrandApi(this._dioClient);

  /// Returns list of post in response
  Future<dynamic> getBrandsByCateId(String cateId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getBrands,
          queryParameters: {"category_id": cateId});
      return res.data["data"];
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<BrandList> getBrands(Map<String, dynamic> params) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getBrands,
          queryParameters: params);
      return BrandList.fromJson(res.data["data"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Brand> getBrand(String brandId) async {
    try {
      final ApiResponse res = await _dioClient.get(Endpoints.getBrand,
          queryParameters: {"id": brandId});
      return Brand.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
