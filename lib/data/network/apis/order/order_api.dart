import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/order/order.dart';

import '../../../../models/order/order_list.dart';


class OrderApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  OrderApi(this._dioClient);

  Future<Order> createOrder(Map<String, dynamic> json) async {
    try {
      final res = await _dioClient.post(Endpoints.createOrder, data: json);
      return Order.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<OrderList> getOrders(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getOrders, queryParameters: params);
      return OrderList.fromJson(res.data["data"]);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
