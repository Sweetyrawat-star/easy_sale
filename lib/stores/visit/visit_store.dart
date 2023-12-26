import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

import '../../models/visit/visit.dart';

part 'visit_store.g.dart';

class VisitStore = _VisitStore with _$VisitStore;

abstract class _VisitStore with Store {
  // // repository instance
  // late Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _VisitStore(Repository repository);

  static ObservableFuture<Visit?> emptyVisitResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<Visit?> fetchVisitFuture =
  ObservableFuture<Visit?>(emptyVisitResponse);

  @observable
  Visit? visit;

  @observable
  String? shopId;

  @computed
  bool get checkedIn => visit != null && visit?.checkinImgs.length != 0;

  @action
  void checkout() {
    this.visit = null;
  }
}
