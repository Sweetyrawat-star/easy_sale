import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';

class KpiApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  KpiApi(this._dioClient,);

  /// Returns list of post in response
  Future<int> getKpiOverallVariant() async {
    try {
      final res = await _dioClient.get(Endpoints.getKpiOverallVariant, queryParameters: {
        "status": "created,delivered,verified,shipped,canceled,returned"
      });
      var total = res.data.length > 0 ? res.data.map((elem) => elem["total"]).toList().reduce((a, b) => a + b) : 0;
      return total;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Map<String, num>> getKpiOverallOrder(String status) async {
    try {
      final res = await _dioClient.get(Endpoints.getKpiOverallOrder, queryParameters: {
        "status": status
      });
      if (res.data.length > 0) {
        return {
          "totalOrder": res.data[0]["total_order"],
          "totalShop": res.data[0]["total_shop"],
          "totalPrice": double.parse(res.data[0]["total_price"].toString()),
        };
      } else {
        return {
          "totalOrder": 0,
          "totalShop": 0,
          "totalPrice": 0,
        };
      }

    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
