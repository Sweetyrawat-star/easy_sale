// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VisitStore on _VisitStore, Store {
  Computed<bool>? _$checkedInComputed;

  @override
  bool get checkedIn => (_$checkedInComputed ??=
          Computed<bool>(() => super.checkedIn, name: '_VisitStore.checkedIn'))
      .value;

  late final _$fetchVisitFutureAtom =
      Atom(name: '_VisitStore.fetchVisitFuture', context: context);

  @override
  ObservableFuture<Visit?> get fetchVisitFuture {
    _$fetchVisitFutureAtom.reportRead();
    return super.fetchVisitFuture;
  }

  @override
  set fetchVisitFuture(ObservableFuture<Visit?> value) {
    _$fetchVisitFutureAtom.reportWrite(value, super.fetchVisitFuture, () {
      super.fetchVisitFuture = value;
    });
  }

  late final _$visitAtom = Atom(name: '_VisitStore.visit', context: context);

  @override
  Visit? get visit {
    _$visitAtom.reportRead();
    return super.visit;
  }

  @override
  set visit(Visit? value) {
    _$visitAtom.reportWrite(value, super.visit, () {
      super.visit = value;
    });
  }

  late final _$shopIdAtom = Atom(name: '_VisitStore.shopId', context: context);

  @override
  String? get shopId {
    _$shopIdAtom.reportRead();
    return super.shopId;
  }

  @override
  set shopId(String? value) {
    _$shopIdAtom.reportWrite(value, super.shopId, () {
      super.shopId = value;
    });
  }

  late final _$_VisitStoreActionController =
      ActionController(name: '_VisitStore', context: context);

  @override
  void checkout() {
    final _$actionInfo =
        _$_VisitStoreActionController.startAction(name: '_VisitStore.checkout');
    try {
      return super.checkout();
    } finally {
      _$_VisitStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchVisitFuture: ${fetchVisitFuture},
visit: ${visit},
shopId: ${shopId},
checkedIn: ${checkedIn}
    ''';
  }
}
