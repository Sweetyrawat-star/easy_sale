import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';


class VisitApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  VisitApi(this._dioClient);

  Future<dynamic> createVisit(Map<String, dynamic> json) async {
    try {
      final res = await _dioClient.post(Endpoints.createVisit, data: json);
      return res.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> addAction(Map<String, dynamic> json) async {
    try {
      final res = await _dioClient.post(Endpoints.createVisitAction, data: json);
      return res.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
