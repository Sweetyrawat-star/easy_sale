// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_UserStore.isLoading'))
      .value;

  late final _$currentUserDataAtom =
      Atom(name: '_UserStore.currentUserData', context: context);

  @override
  User get currentUserData {
    _$currentUserDataAtom.reportRead();
    return super.currentUserData;
  }

  @override
  set currentUserData(User value) {
    _$currentUserDataAtom.reportWrite(value, super.currentUserData, () {
      super.currentUserData = value;
    });
  }

  late final _$jobRegisteredAtom =
      Atom(name: '_UserStore.jobRegistered', context: context);

  @override
  bool get jobRegistered {
    _$jobRegisteredAtom.reportRead();
    return super.jobRegistered;
  }

  @override
  set jobRegistered(bool value) {
    _$jobRegisteredAtom.reportWrite(value, super.jobRegistered, () {
      super.jobRegistered = value;
    });
  }

  late final _$successAtom = Atom(name: '_UserStore.success', context: context);

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

  late final _$loginFutureAtom =
      Atom(name: '_UserStore.loginFuture', context: context);

  @override
  ObservableFuture<User> get loginFuture {
    _$loginFutureAtom.reportRead();
    return super.loginFuture;
  }

  @override
  set loginFuture(ObservableFuture<User> value) {
    _$loginFutureAtom.reportWrite(value, super.loginFuture, () {
      super.loginFuture = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('_UserStore.login', context: context);

  @override
  Future<dynamic> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$loginSocialAsyncAction =
      AsyncAction('_UserStore.loginSocial', context: context);

  @override
  Future<dynamic> loginSocial(String type, String token) {
    return _$loginSocialAsyncAction.run(() => super.loginSocial(type, token));
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_UserStore.updateProfile', context: context);

  @override
  Future<dynamic> updateProfile(User user) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(user));
  }

  @override
  String toString() {
    return '''
currentUserData: ${currentUserData},
jobRegistered: ${jobRegistered},
success: ${success},
loginFuture: ${loginFuture},
isLoading: ${isLoading}
    ''';
  }
}
