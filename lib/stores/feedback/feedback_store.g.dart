// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FeedbackStore on _FeedbackStore, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_FeedbackStore.loading'))
      .value;

  late final _$fetchFeedbacksFutureAtom =
      Atom(name: '_FeedbackStore.fetchFeedbacksFuture', context: context);

  @override
  ObservableFuture<RatingList?> get fetchFeedbacksFuture {
    _$fetchFeedbacksFutureAtom.reportRead();
    return super.fetchFeedbacksFuture;
  }

  @override
  set fetchFeedbacksFuture(ObservableFuture<RatingList?> value) {
    _$fetchFeedbacksFutureAtom.reportWrite(value, super.fetchFeedbacksFuture,
        () {
      super.fetchFeedbacksFuture = value;
    });
  }

  late final _$ratingListAtom =
      Atom(name: '_FeedbackStore.ratingList', context: context);

  @override
  RatingList? get ratingList {
    _$ratingListAtom.reportRead();
    return super.ratingList;
  }

  @override
  set ratingList(RatingList? value) {
    _$ratingListAtom.reportWrite(value, super.ratingList, () {
      super.ratingList = value;
    });
  }

  late final _$successAtom =
      Atom(name: '_FeedbackStore.success', context: context);

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$getFeedbacksAsyncAction =
      AsyncAction('_FeedbackStore.getFeedbacks', context: context);

  @override
  Future<dynamic> getFeedbacks(Map<String, dynamic> params) {
    return _$getFeedbacksAsyncAction.run(() => super.getFeedbacks(params));
  }

  @override
  String toString() {
    return '''
fetchFeedbacksFuture: ${fetchFeedbacksFuture},
ratingList: ${ratingList},
success: ${success},
loading: ${loading}
    ''';
  }
}
