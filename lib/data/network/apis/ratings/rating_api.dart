import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';

import '../../../../models/rating/rating.dart';
import '../../../../models/rating/rating_list.dart';

class RatingApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  RatingApi(this._dioClient);

  /// Returns list of post in response
  Future<RatingList> getRatings(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getRatings, queryParameters: params);
      return RatingList.fromJson(res.data["data"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Rating> createRating(Rating rating) async {
    try {
      final res = await _dioClient.post(Endpoints.createRating, data: rating.toMap());
      return Rating.fromMap(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
