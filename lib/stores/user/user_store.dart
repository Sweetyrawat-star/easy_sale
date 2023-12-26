import 'dart:convert';

import 'package:boilerplate/apis/google_signin_api.dart';
import 'package:boilerplate/models/user/user.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

import '../../data/repository.dart';
import '../form/form_store.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // repository instance
  final Repository _repository;

  // store for handling form errors
  final FormErrorStore formErrorStore = FormErrorStore();

  // store for handling error messages
  final ErrorStore errorStore = ErrorStore();

  // bool to check if current user is logged in
  bool isLoggedIn = false;

  @observable
  User currentUserData = new User();

  @observable
  bool jobRegistered = false;

  // constructor:---------------------------------------------------------------
  _UserStore(Repository repository) : this._repository = repository {

    // setting up disposers
    _setupDisposers();

    // checking if user is logged in
    repository.isLoggedIn.then((value) {
      this.isLoggedIn = value;
    });
    repository.isLoggedInUserData.then((value) => {
      if (value.isNotEmpty) {
        this.currentUserData = User.fromLocal(jsonDecode(value)),
        this.jobRegistered = this.currentUserData.jobRegistered
      }
    });
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<User> emptyLoginResponse =
  ObservableFuture.value(new User());

  // store variables:-----------------------------------------------------------
  @observable
  bool success = false;

  @observable
  ObservableFuture<User> loginFuture = emptyLoginResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future login(String email, String password) async {
    final future = _repository.login(email, password);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      _repository.saveIsLoggedIn(true);
      _repository.saveAuthToken(value.token);
      _repository.saveLoggedInUserData(jsonEncode(value.toMap()));
      this.isLoggedIn = true;
      this.success = true;
      this.currentUserData = value;
      this.jobRegistered = value.jobRegistered;
    }).catchError((e) {
      print("login error: " + e);
      this.isLoggedIn = false;
      this.success = false;
      throw e;
    });
  }

  @action
  Future loginSocial(String type, String token) async {
    final future = _repository.loginSocial(type, token);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      _repository.saveIsLoggedIn(true);
      _repository.saveAuthToken(value.token);
      _repository.saveLoggedInUserData(jsonEncode(value.toMap()));
      this.isLoggedIn = true;
      this.success = true;
      this.currentUserData = value;
      this.jobRegistered = value.jobRegistered;
    }).catchError((e) {
      print("login error: " + e);
      this.isLoggedIn = false;
      this.success = false;
      throw e;
    });
  }

  @action
  Future updateProfile(User user) async {
    final future = _repository.updateProfile(user);
    loginFuture = ObservableFuture(future);
    await future.then((value) async {
      _repository.saveLoggedInUserData(jsonEncode(value.toMap()));
      this.currentUserData = value;
    }).catchError((e) {
      print("login updateProfile: " + e);
      throw e;
    });
  }

  Future logout() async {
    final future = _repository.logout();
    await ObservableFuture(future).then((value) {
      this.clearUserData();
      GoogleSigninApi.logout();
    }).catchError((e) {
      print("logout error: " + e);
      this.clearUserData();
      throw e;
    });
  }

  void clearUserData() {
    this.isLoggedIn = false;
    _repository.saveIsLoggedIn(false);
    _repository.deleteUserData();
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}