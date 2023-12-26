import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

import '../../models/rating/rating_list.dart';

part 'feedback_store.g.dart';

class FeedbackStore = _FeedbackStore with _$FeedbackStore;

abstract class _FeedbackStore with Store {
  // repository instance
  late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _FeedbackStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<RatingList?> emptyFeedbackResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<RatingList?> fetchFeedbacksFuture =
      ObservableFuture<RatingList?>(emptyFeedbackResponse);

  @observable
  RatingList? ratingList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchFeedbacksFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getFeedbacks(Map<String, dynamic> params) async {
    final future = _repository.getFeedbacks(params);
    fetchFeedbacksFuture = ObservableFuture(future);

    future.then((ratingList) {
      this.ratingList = ratingList;
    }).catchError((error) {
      print(error);
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }
}
