import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/models/variant/variant_list.dart';

import '../../../../models/brand/brand.dart';
import '../../../../models/product/product.dart';
import '../../../../models/product/product_list.dart';
import '../../../../models/provider/provider.dart';
import '../../../../models/variant/variant.dart';

class ProductApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  ProductApi(this._dioClient);

  /// Returns list of post in response
  Future<ProductList> getProducts(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getProducts, queryParameters: params);
      return ProductList.fromJson(res.data["data"]);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Product> getProduct(String id) async {
    try {
      final res = await _dioClient.get(Endpoints.getProduct, queryParameters: {"id": id});
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      var product = Product.fromMap(res.data);
      var variants = await getProductVariants({"product_id": product.id});
      product.setVariants(variants);

      final resBrand = await _dioClient.get(Endpoints.getBrand, queryParameters: {"id": product.brandId});
      if (!resBrand.isSuccess) {
        throw res.errorMessage.toString();
      }
      var brand = Brand.fromMap(resBrand.data);
      product.setBrand(brand);

      final resProvider = await _dioClient.get(Endpoints.getProvider, queryParameters: {"id": product.providerId});
      if (!resBrand.isSuccess) {
        throw res.errorMessage.toString();
      }
      var provider = Provider.fromMap(resProvider.data);
      product.setProvider(provider);

      return product;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<ProductVariantList> getProductVariants(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getProductVariants, queryParameters: params);
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return ProductVariantList.fromJson(res.data["data"]);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<ProductVariant> getProductVariant(String id) async {
    try {
      final res = await _dioClient.get(Endpoints.getProductVariant, queryParameters: {"id": id});
      if (!res.isSuccess) {
        throw res.errorMessage.toString();
      }
      return ProductVariant.fromMap(res.data);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
