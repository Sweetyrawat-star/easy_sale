import 'dart:async';

import 'package:boilerplate/data/network/dio_client.dart';

import '../../../../models/cart/cart.dart';


class CartApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  CartApi(this._dioClient);

  /// Returns list of post in response
  Future<Cart> getCart() async {
    print(this._dioClient);
    return Cart.fromMap({
      "items": List.from([
        // {
        //   "variant_id": "",
        //   "variant_name": "Samsung galaxy 1",
        //   "amount": 1,
        //   "price": 109000,
        //   "brand_name": "Nokia",
        //   "attr_string": "Xanh la, M",
        //   "image": "upload/image/u3_ad_caei9j9s49g2gh6e8d0g.jpg"
        // }
      ])
    });
    // try {
    //   final ApiResponse res = await _dioClient.get(Endpoints.getCart);
    //   return res.data["data"];
    // } catch (e) {
    //   print(e.toString());
    //   throw e;
    // }
  }

  Future<Cart> updateCart(Cart cart) async {
    return cart;
  }
}
