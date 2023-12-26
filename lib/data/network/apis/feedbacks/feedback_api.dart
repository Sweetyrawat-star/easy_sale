import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';

import '../../../../models/feedback/feedback_list.dart';

class FeedbackApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance

  // injecting dio instance
  FeedbackApi(this._dioClient);

  /// Returns list of post in response
  Future<FeedbackList> getFeedbacks(Map<String, dynamic> params) async {
    try {
      final res = await _dioClient.get(Endpoints.getFeedbacks, queryParameters: params);
      return FeedbackList.fromJson(res.data["data"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

/// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return _restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
